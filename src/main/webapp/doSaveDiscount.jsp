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
    User user = (User) session.getAttribute("user");
    if (user == null){
        response.sendRedirect("login.jsp?err=timeout");
        return;
    }
    
    // Nhận tham số from để redirect
    String from = request.getParameter("from");
    if (from == null || from.isEmpty()) {
        from = "createImportReceiptPage.jsp";
    }
    
    try {
        // Nhận các tham số từ form
        String providerIdParam = request.getParameter("providerId");
        String discountCode = request.getParameter("discountCode");
        String amountParam = request.getParameter("amount");
        String productIdParam = request.getParameter("productId");
        
        // Validate
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
        
        // Lấy thông tin provider
        ProviderDAO providerDAO = new ProviderDAO();
        Provider provider = providerDAO.getProviderById(providerId);
        
        if (provider == null) {
            %>
            <script>
                alert("Nhà cung cấp không tồn tại!");
                window.location.href = "addDiscountPage.jsp?from=<%= from %>";
            </script>
            <%
            return;
        }
        
        // Tạo đối tượng Discount (ProductDiscount hoặc ReceiptDiscount)
        Discount discount;
        Integer productId = null;
        
        if (productIdParam != null && !productIdParam.isEmpty()) {
            // Có productId -> ProductDiscount
            productId = Integer.parseInt(productIdParam);
            discount = new ProductDiscount();
        } else {
            // Không có productId -> ReceiptDiscount
            discount = new ReceiptDiscount();
        }
        
        discount.setDiscountCode(discountCode);
        discount.setAmount(amount);
        discount.setProvider(provider.getName());
        
        // Lưu vào database
        DiscountDAO discountDAO = new DiscountDAO();
        boolean result = discountDAO.saveDiscount(discount, productId);
        
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

