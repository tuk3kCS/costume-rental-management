<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Thống kê</title>
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
%>

<h1>Thống kê</h1>
<button onclick="location.href='homepage.jsp'" style="float: right;">Quay lại</button>
<br><br>

<form name="statisticsForm" action="doGetExpenseStatistics.jsp" method="post">
    <table border="0">
        <tr>
            <td>Chọn loại thống kê</td>
            <td>
                <select name="statisticsType" id="statisticsType">
                    <option value="doanh_chi">Theo doanh chi</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>Ngày bắt đầu</td>
            <td><input type="date" name="startDate" id="startDate" required /></td>
        </tr>
        <tr>
            <td>Ngày kết thúc</td>
            <td><input type="date" name="endDate" id="endDate" required /></td>
        </tr>
        <tr>
            <td></td>
            <td><button type="submit">Thống kê</button></td>
        </tr>
    </table>
</form>

</body>
</html>

