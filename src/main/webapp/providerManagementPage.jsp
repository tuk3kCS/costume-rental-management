<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Quản lý thông tin nhà cung cấp</title>
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
    
    List<Provider> providerList = (List<Provider>) request.getAttribute("providerList");
%>

<h1>Quản lý thông tin nhà cung cấp</h1>
<button onclick="location.href='homepage.jsp'" style="float: right;">Quay lại</button>
<br><br>

<form name="searchForm" action="doSearchProvider.jsp" method="post">
    <input type="text" name="keyword" id="keyword" size="50" />
    <input type="submit" value="Tìm kiếm" />
</form>

<br>

<button onclick="location.href='addProviderPage.jsp'">Thêm nhà cung cấp</button>

<br>

<%
    if (providerList != null && providerList.size() > 0) {
%>
<table border="1">
    <tr>
        <th>STT</th>
        <th>Tên</th>
        <th>Địa chỉ</th>
        <th>Số ĐT</th>
        <th>Email</th>
        <th>Tùy chọn</th>
    </tr>
    <%
        int stt = 1;
        for (Provider provider : providerList) {
            request.setAttribute("provider_" + provider.getId(), provider);
    %>
    <tr>
        <td><%= stt++ %></td>
        <td><%= provider.getName() %></td>
        <td><%= provider.getAddress() %></td>
        <td><%= provider.getPhoneNo() %></td>
        <td><%= provider.getEmail() %></td>
        <td>
            <a href="modifyProviderPage.jsp?id=<%= provider.getId() %>">Sửa</a> /
            <a href="deleteProviderPage.jsp?id=<%= provider.getId() %>">xóa</a>
        </td>
    </tr>
    <%
        }
    %>
</table>
<%
    } else if (request.getAttribute("searched") != null && (Boolean)request.getAttribute("searched")) {
%>
<p>Không tìm thấy nhà cung cấp nào.</p>
<%
    }
%>

</body>
</html>

