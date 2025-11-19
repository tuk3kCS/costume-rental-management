<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Xử lý lưu mặt hàng</title>
</head>
<body>
<%
    try {
        String name = request.getParameter("name");
        String size = request.getParameter("size");
        String color = request.getParameter("color");
        String unitPriceParam = request.getParameter("unitPrice");
        String providerIdParam = request.getParameter("providerId");
        String from = request.getParameter("from");
        
        // Xác định trang trở về
        if (from == null || from.isEmpty()) {
            from = "createImportReceiptPage.jsp";
        }
        
        // Tạo Product object
        Product product = new Product();
        product.setName(name);
        product.setSize(size);
        product.setColor(color);
        
        // Lưu product
        ProductDAO dao = new ProductDAO();
        boolean result = dao.saveProduct(product);
        
        if (result) {
%>
<script type="text/javascript">
    alert('Lưu thành công!');
    window.location.href='<%= from %>';
</script>
<%
        } else {
%>
<script type="text/javascript">
    alert('Lưu thất bại!');
    window.location.href='addProductPage.jsp?from=<%= from %>';
</script>
<%
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        String from = request.getParameter("from");
        if (from == null || from.isEmpty()) {
            from = "createImportReceiptPage.jsp";
        }
%>
<script type="text/javascript">
    alert('Có lỗi xảy ra!');
    window.location.href='<%= from %>';
</script>
<%
    }
%>
</body>
</html>

