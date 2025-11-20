<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Áp dụng chiết khấu</title>
</head>
<body>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null){
        response.sendRedirect("login.jsp?err=timeout");
        return;
    }
    
    try {
        String discountCode = request.getParameter("discountCode");
        Receipt receipt = (Receipt) session.getAttribute("currentReceipt");
        
        if (discountCode == null || discountCode.isEmpty()) {
%>
<script type="text/javascript">
    alert('Vui lòng nhập mã chiết khấu!');
    window.location.href='createImportReceiptPage.jsp';
</script>
<%
            return;
        }
        
        if (receipt == null || receipt.getProvider() == null) {
%>
<script type="text/javascript">
    alert('Không tìm thấy phiếu nhập hoặc chưa chọn nhà cung cấp!');
    window.location.href='createImportReceiptPage.jsp';
</script>
<%
            return;
        }
        
        int providerId = receipt.getProvider().getId();
        
        DiscountDAO dao = new DiscountDAO();
        DiscountDAO.Pair<Discount, Integer> result = dao.searchDiscount(discountCode, providerId);
        
        Discount discount = result.getFirst();
        int productId = result.getSecond();
        
        // Xử lý kết quả theo logic yêu cầu
        if (discount == null) {
            // Mã chiết khấu không tồn tại
%>
<script type="text/javascript">
    alert('Mã chiết khấu không tồn tại!');
    window.location.href='createImportReceiptPage.jsp';
</script>
<%
        } else if (productId == 0) {
            // Discount không rỗng, productId rỗng (= 0) -> áp dụng mã chiết khấu lên giá trị phiếu nhập
            receipt.setDiscount(discount);
            session.setAttribute("currentReceipt", receipt);
            session.removeAttribute("discountProductId"); // Xóa productId cũ nếu có
%>
<script type="text/javascript">
    alert('Áp dụng chiết khấu thành công!');
    window.location.href='createImportReceiptPage.jsp';
</script>
<%
        } else {
            // Discount không rỗng, productId không rỗng (> 0) -> kiểm tra xem có sản phẩm nào áp dụng được không
            boolean found = false;
            
            for (ReceiptProduct rp : receipt.getProducts()) {
                if (rp.getProduct().getId() == productId) {
                    found = true;
                    // Áp dụng chiết khấu lên sản phẩm này
                    receipt.setDiscount(discount);
                    session.setAttribute("discountProductId", productId); // Lưu productId để hiển thị chiết khấu
                    session.setAttribute("currentReceipt", receipt);
%>
<script type="text/javascript">
    alert('Áp dụng chiết khấu thành công!');
    window.location.href='createImportReceiptPage.jsp';
</script>
<%
                    break;
                }
            }
            
            if (!found) {
                // Không có sản phẩm nào áp dụng được chiết khấu
%>
<script type="text/javascript">
    alert('Không có sản phẩm nào áp dụng được chiết khấu!');
    window.location.href='createImportReceiptPage.jsp';
</script>
<%
            }
        }
        
    } catch (Exception e) {
        e.printStackTrace();
%>
<script type="text/javascript">
    alert('Có lỗi xảy ra!');
    window.location.href='createImportReceiptPage.jsp';
</script>
<%
    }
%>
</body>
</html>

