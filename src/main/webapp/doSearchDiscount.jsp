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
        
        if (receipt == null) {
%>
<script type="text/javascript">
    alert('Không tìm thấy phiếu nhập!');
    window.location.href='createImportReceiptPage.jsp';
</script>
<%
            return;
        }
        
        DiscountDAO dao = new DiscountDAO();
        Discount discount = dao.searchDiscount(discountCode);
        
        // Trường hợp 1: Không tìm thấy mã chiết khấu
        if (discount == null) {
%>
<script type="text/javascript">
    alert('Không tồn tại mã chiết khấu!');
    window.location.href='createImportReceiptPage.jsp';
</script>
<%
        } else {
            // Kiểm tra xem discount có phải là ProductDiscount không
            boolean isProductDiscount = discount instanceof ProductDiscount;
            boolean applied = false;
            
            if (isProductDiscount) {
                // Discount cho sản phẩm cụ thể
                ProductDiscount productDiscount = (ProductDiscount) discount;
                int productId = productDiscount.getId(); // ID của product được áp dụng discount
                
                // Tìm product trong danh sách
                boolean found = false;
                for (ReceiptProduct rp : receipt.getProducts()) {
                    if (rp.getProduct().getId() == productId) {
                        // Trường hợp 2: Có product trong danh sách
                        found = true;
                        applied = true;
                        
                        // Áp dụng chiết khấu cho sản phẩm này
                        // Có thể lưu discount riêng cho product hoặc tính toán
                        receipt.setDiscount(discount);
                        session.setAttribute("currentReceipt", receipt);
                        break;
                    }
                }
                
                if (!found) {
                    // Trường hợp 3: Discount cho product nhưng không có trong danh sách
%>
<script type="text/javascript">
    alert('Không có sản phẩm nào được áp dụng chiết khấu!');
    window.location.href='createImportReceiptPage.jsp';
</script>
<%
                }
            } else {
                // Trường hợp 4: Discount cho toàn bộ receipt
                applied = true;
                receipt.setDiscount(discount);
                session.setAttribute("currentReceipt", receipt);
            }
            
            if (applied) {
%>
<script type="text/javascript">
    alert('Áp dụng chiết khấu thành công!');
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

