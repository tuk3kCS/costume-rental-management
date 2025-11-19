<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Thêm mới mặt hàng</title>
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
    
    // Lấy danh sách provider để hiển thị
    ProviderDAO providerDAO = new ProviderDAO();
    List<Provider> providers = providerDAO.getProviderList();
%>

<h2>Thêm mới mặt hàng</h2>
<button onclick="location.href='<%= from %>'" style="float: right;">Quay lại</button>
<br><br>

<form name="addProductForm" action="doSaveProduct.jsp" method="post">
    <input type="hidden" name="from" value="<%= from %>" />
    <table border="0">
        <tr>
            <td>Nhà cung cấp</td>
            <td>
                <select name="providerId" id="providerId">
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
            <td>Tên mặt hàng</td>
            <td><input type="text" name="name" id="name" required /></td>
        </tr>
        <tr>
            <td>Kích cỡ</td>
            <td><input type="text" name="size" id="size" required /></td>
        </tr>
        <tr>
            <td>Màu sắc</td>
            <td><input type="text" name="color" id="color" required /></td>
        </tr>
        <tr>
            <td>Đơn giá</td>
            <td><input type="number" name="unitPrice" id="unitPrice" min="0" required /></td>
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

