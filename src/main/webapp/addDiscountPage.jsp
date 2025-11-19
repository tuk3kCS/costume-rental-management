<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Thêm mã chiết khấu</title>
</head>
<body>
<%
    User user = (User) session.getAttribute("user");
    if (user == null){
        response.sendRedirect("login.jsp?err=timeout");
        return;
    }
    
    // Nhận tham số from để biết trang gọi
    String from = request.getParameter("from");
    if (from == null || from.isEmpty()) {
        from = "createImportReceiptPage.jsp";
    }
    
    // Lấy danh sách provider và product để hiển thị trong dropdown
    ProviderDAO providerDAO = new ProviderDAO();
    ProductDAO productDAO = new ProductDAO();
    List<Provider> providers = providerDAO.getProviderList();
    List<Product> products = productDAO.getProductList();
%>

<h2>Thêm mã chiết khấu</h2>
<button onclick="location.href='<%= from %>'" style="float: right;">Quay lại</button>
<br><br>

<form name="addDiscountForm" action="doSaveDiscount.jsp" method="post">
    <input type="hidden" name="from" value="<%= from %>" />
    <table border="0">
        <tr>
            <td>Nhà cung cấp</td>
            <td>
                <select name="providerId" id="providerId" required>
                    <option value="">-- Chọn nhà cung cấp --</option>
                    <%
                        for (Provider p : providers) {
                    %>
                    <option value="<%= p.getId() %>"><%= p.getName() %></option>
                    <%
                        }
                    %>
                </select>
            </td>
        </tr>
        <tr>
            <td>Mã chiết khấu</td>
            <td><input type="text" name="discountCode" id="discountCode" required /></td>
        </tr>
        <tr>
            <td>Số tiền chiết khấu</td>
            <td><input type="number" name="amount" id="amount" min="0" required /></td>
        </tr>
        <tr>
            <td>Mặt hàng</td>
            <td>
                <select name="productId" id="productId">
                    <option value="">-- Không chọn (áp dụng cho toàn phiếu) --</option>
                    <%
                        for (Product prod : products) {
                    %>
                    <option value="<%= prod.getId() %>"><%= prod.getName() %> - <%= prod.getSize() %> - <%= prod.getColor() %></option>
                    <%
                        }
                    %>
                </select>
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <input type="submit" value="Lưu" />
                <button type="button" onclick="location.href='<%= from %>'">Hủy</button>
            </td>
        </tr>
    </table>
</form>

</body>
</html>

