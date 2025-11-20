<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Lưu mã chiết khấu</title>
</head>
<body>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null){
        response.sendRedirect("login.jsp?err=timeout");
        return;
    }
    
    String from = request.getParameter("from");
    if (from == null || from.isEmpty()) {
        from = "createImportReceiptPage.jsp";
    }
    
    try {
        String providerIdParam = request.getParameter("providerId");
        String discountCode = request.getParameter("discountCode");
        String amountParam = request.getParameter("amount");
        String productIdParam = request.getParameter("productId");
        
        if (providerIdParam == null || providerIdParam.isEmpty() ||
            discountCode == null || discountCode.trim().isEmpty() ||
            amountParam == null || amountParam.isEmpty()) {
            %>
            <script>
                alert("Vui lòng điền đầy đủ thông tin!");
                window.location.href = "addDiscountPage.jsp?from=<%= from %>";
            </script>
            <%
            return;
        }
        
        int providerId = Integer.parseInt(providerIdParam);
        int amount = Integer.parseInt(amountParam);
        Integer productId = null;
        
        // Tạo đối tượng Discount
        Discount discount;
        if (productIdParam != null && !productIdParam.isEmpty()) {
            productId = Integer.parseInt(productIdParam);
            discount = new ProductDiscount();
        } else {
            discount = new ReceiptDiscount();
        }
        
        discount.setDiscountCode(discountCode);
        discount.setAmount(amount);
        
        // Lưu vào database
        DiscountDAO discountDAO = new DiscountDAO();
        boolean result = discountDAO.saveDiscount(discount, providerId, productId);
        
        if (result) {
            %>
            <script>
                alert("Lưu mã chiết khấu thành công!");
                window.location.href = "<%= from %>";
            </script>
            <%
        } else {
            %>
            <script>
                alert("Lưu mã chiết khấu thất bại!");
                window.location.href = "addDiscountPage.jsp?from=<%= from %>";
            </script>
            <%
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        %>
        <script>
            alert("Lỗi: <%= e.getMessage() %>");
            window.location.href = "addDiscountPage.jsp?from=<%= from %>";
        </script>
        <%
    }
%>
</body>
</html>

