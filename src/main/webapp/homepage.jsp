<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.ArrayList,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Quản lý hệ thống cho thuê trang phục</title>
</head>
<body>
<%
    User user = (User) session.getAttribute("user");
    String username = user.getUsername();
    if (username == null){
        response.sendRedirect("login.jsp?err=timeout");
        return;
    }
    
    String fullname = user.getFullName();
    String role = user.getRole();
%>

<h1>Quản lý hệ thống cho thuê trang phục</h1>

<table border="0" width="100%">
    <tr>
        <td valign="top" width="50%">
            <h3>Chức năng</h3>
            <table border="1">
                <%
                    if (role != null && role.equalsIgnoreCase("manager")) {
                %>
                <tr>
                    <td><a href="providerManagementPage.jsp">Quản lý thông tin nhà cung cấp</a></td>
                </tr>
                <%
                    }
                %>
                <tr>
                    <td><a href="productImportPage.jsp">Nhập trang phục về từ nhà cung cấp</a></td>
                </tr>
                <%
                    if (role != null && role.equalsIgnoreCase("manager")) {
                %>
                <tr>
                    <td><a href="statisticsPage.jsp">Thống kê</a></td>
                </tr>
                <%
                    }
                %>
            </table>
        </td>
        <td valign="top" align="right">
            <ul>
                <li>- Tên đăng nhập</li>
                <li><%= username %></li>
                <li>- Họ tên</li>
                <li><%= fullname %></li>
                <li>- Chức vụ</li>
                <li><%= role %></li>
            </ul>
            <button onclick="location.href='changePassword.jsp'">Đổi mật khẩu</button>
            <button onclick="location.href='doLogout.jsp'">Đăng xuất</button>
        </td>
    </tr>
</table>

</body>
</html>

