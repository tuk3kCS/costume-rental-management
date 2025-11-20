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
        
        if (discount == null) {
%>
<script type="text/javascript">
    alert('Không tồn tại mã chiết khấu!');
    window.location.href='createImportReceiptPage.jsp';
</script>
<%
        } else {
            boolean isProductDiscount = discount instanceof ProductDiscount;
            boolean applied = false;
            
            if (isProductDiscount) {
                ProductDiscount productDiscount = (ProductDiscount) discount;
                int productId = productDiscount.getId();
                
                boolean found = false;
                for (ReceiptProduct rp : receipt.getProducts()) {
                    if (rp.getProduct().getId() == productId) {
                        found = true;
                        applied = true;
                        
                        receipt.setDiscount(discount);
                        session.setAttribute("currentReceipt", receipt);
                        break;
                    }
                }
                
                if (!found) {
%>
<script type="text/javascript">
    alert('Không có sản phẩm nào được áp dụng chiết khấu!');
    window.location.href='createImportReceiptPage.jsp';
</script>
<%
                }
            } else {
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

