<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Chỉnh sửa nhà cung cấp</title>
</head>
<body>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null){
        response.sendRedirect("login.jsp?err=timeout");
        return;
    }
    
    String role = staff.getRole();
    if (role == null || !role.equalsIgnoreCase("manager")) {
        response.sendRedirect("homepage.jsp");
        return;
    }
    
    String idParam = request.getParameter("id");
    if (idParam == null || idParam.isEmpty()) {
        response.sendRedirect("providerManagementPage.jsp");
        return;
    }
    
    int providerId = Integer.parseInt(idParam);
    
    List<Provider> providerList = (List<Provider>) session.getAttribute("providerList");
    if (providerList == null) {
        response.sendRedirect("providerManagementPage.jsp");
        return;
    }
    
    Provider provider = null;
    for (Provider p : providerList) {
        if (p.getId() == providerId) {
            provider = p;
            break;
        }
    }
    
    if (provider == null) {
        response.sendRedirect("providerManagementPage.jsp");
        return;
    }
%>

<h2>Chỉnh sửa nhà cung cấp</h2>
<button onclick="location.href='providerManagementPage.jsp'" style="float: right;">Quay lại</button>
<br><br>

<form name="modifyProviderForm" action="doSaveProvider.jsp" method="post">
    <input type="hidden" name="id" value="<%= provider.getId() %>" />
    <table border="0">
        <tr>
            <td>Tên nhà cung cấp</td>
            <td><input type="text" name="name" id="name" value="<%= provider.getName() %>" required /></td>
        </tr>
        <tr>
            <td>Địa chỉ</td>
            <td><input type="text" name="address" id="address" value="<%= provider.getAddress() %>" required /></td>
        </tr>
        <tr>
            <td>Email</td>
            <td><input type="email" name="email" id="email" value="<%= provider.getEmail() %>" required /></td>
        </tr>
        <tr>
            <td>Số điện thoại</td>
            <td><input type="text" name="phoneNo" id="phoneNo" value="<%= provider.getPhoneNo() %>" required /></td>
        </tr>
        <tr>
            <td></td>
            <td>
                <input type="submit" value="Lưu" />
                <button type="button" onclick="location.href='providerManagementPage.jsp'">Hủy</button>
            </td>
        </tr>
    </table>
</form>

</body>
</html>

