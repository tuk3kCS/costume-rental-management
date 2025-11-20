<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Thêm nhà cung cấp</title>
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
        from = "providerManagementPage.jsp";
    }
%>

<h2>Thêm nhà cung cấp</h2>

<form name="addProviderForm" action="doSaveProvider.jsp" method="post">
    <input type="hidden" name="from" value="<%= from %>" />
    <table border="0">
        <tr>
            <td>Tên:</td>
            <td><input type="text" name="name" id="name" required /></td>
        </tr>
        <tr>
            <td>Địa chỉ:</td>
            <td><input type="text" name="address" id="address" required /></td>
        </tr>
        <tr>
            <td>Email:</td>
            <td><input type="email" name="email" id="email" required /></td>
        </tr>
        <tr>
            <td>Số ĐT:</td>
            <td><input type="text" name="phoneNo" id="phoneNo" required /></td>
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

