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
    
    String tempName = (String) session.getAttribute("tempProviderName");
    String tempAddress = (String) session.getAttribute("tempProviderAddress");
    String tempPhoneNo = (String) session.getAttribute("tempProviderPhoneNo");
    String tempEmail = (String) session.getAttribute("tempProviderEmail");
    String duplicateField = (String) session.getAttribute("duplicateField");
    
    session.removeAttribute("tempProviderName");
    session.removeAttribute("tempProviderAddress");
    session.removeAttribute("tempProviderPhoneNo");
    session.removeAttribute("tempProviderEmail");
    session.removeAttribute("duplicateField");
    
    if (tempName == null) tempName = "";
    if (tempAddress == null) tempAddress = "";
    if (tempPhoneNo == null) tempPhoneNo = "";
    if (tempEmail == null) tempEmail = "";
%>

<h2>Thêm nhà cung cấp</h2>
<button onclick="location.href='<%= from %>'" style="float: right;">Quay lại</button>
<br><br>

<form name="addProviderForm" action="doSaveProvider.jsp" method="post">
    <input type="hidden" name="from" value="<%= from %>" />
    <table border="0">
        <tr>
            <td>Tên:</td>
            <td><input type="text" name="name" id="name" value="<%= tempName %>" required /></td>
        </tr>
        <tr>
            <td>Địa chỉ:</td>
            <td><input type="text" name="address" id="address" value="<%= tempAddress %>" required /></td>
        </tr>
        <tr>
            <td>Email:</td>
            <td><input type="email" name="email" id="email" value="<%= tempEmail %>" required /></td>
        </tr>
        <tr>
            <td>Số ĐT:</td>
            <td><input type="text" name="phoneNo" id="phoneNo" value="<%= tempPhoneNo %>" required /></td>
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

<%
    if (duplicateField != null && !duplicateField.isEmpty()) {
%>
<script type="text/javascript">
    window.onload = function() {
        var duplicateFields = '<%= duplicateField %>'.split(',');
        
        for (var i = 0; i < duplicateFields.length; i++) {
            var field = document.getElementById(duplicateFields[i]);
            if (field) {
                field.style.border = '2px solid red';
                field.style.backgroundColor = '#ffe6e6';
            }
        }
        
        if (duplicateFields.length > 0) {
            var firstField = document.getElementById(duplicateFields[0]);
            if (firstField) {
                firstField.focus();
                firstField.select();
            }
        }
    }
</script>
<%
    }
%>

</body>
</html>

