<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Thống kê nhà cung cấp theo doanh chi</title>
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
    
    List<ProviderStatDAO.ProviderStat> statList = (List<ProviderStatDAO.ProviderStat>) session.getAttribute("statList");
    Integer totalExpense = (Integer) session.getAttribute("totalExpense");
    String startDate = (String) session.getAttribute("startDate");
    String endDate = (String) session.getAttribute("endDate");
    
    if (statList == null || totalExpense == null || startDate == null || endDate == null) {
        response.sendRedirect("statisticsPage.jsp");
        return;
    }
%>

<h1>Thống kê nhà cung cấp theo doanh chi</h1>
<button onclick="location.href='statisticsPage.jsp'" style="float: right;">Quay lại</button>
<br><br>

<div>
    Thống kê từ ngày <input type="text" value="<%= startDate %>" readonly size="12" /> 
    tới ngày <input type="text" value="<%= endDate %>" readonly size="12" />
</div>

<br>

<div>
    Tổng doanh chi: <input type="text" value="<%= totalExpense %>" readonly size="20" />
</div>

<br>

<%
    if (statList != null && statList.size() > 0) {
%>
<table border="1">
    <tr>
        <th>STT</th>
        <th>Tên</th>
        <th>Địa chỉ</th>
        <th>Doanh chi</th>
        <th>Số phiếu nhập</th>
        <th>Tùy chọn</th>
    </tr>
    <%
        int stt = 1;
        for (ProviderStatDAO.ProviderStat stat : statList) {
            Provider provider = stat.getProvider();
    %>
    <tr>
        <td><%= stt++ %></td>
        <td><%= provider.getName() %></td>
        <td><%= provider.getAddress() %></td>
        <td><%= stat.getTotalExpense() %></td>
        <td><%= stat.getTotalReceipts() %></td>
        <td>
            <a href="doGetProviderStatistics.jsp?providerId=<%= provider.getId() %>&startDate=<%= startDate %>&endDate=<%= endDate %>">Xem chi tiết</a>
        </td>
    </tr>
    <%
        }
    %>
</table>
<%
    }
    
    else {
%>
<p>Không có dữ liệu thống kê trong khoảng thời gian này.</p>
<%
    }
%>

</body>
</html>

