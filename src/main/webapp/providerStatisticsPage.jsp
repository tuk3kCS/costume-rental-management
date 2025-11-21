<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Thống kê chi tiết nhà cung cấp</title>
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
    
    List<Receipt> receiptList = (List<Receipt>) session.getAttribute("receiptList");
    Provider provider = (Provider) session.getAttribute("provider");
    Integer totalExpense = (Integer) session.getAttribute("totalExpense");
    Integer totalReceipts = (Integer) session.getAttribute("totalReceipts");
    String startDate = (String) session.getAttribute("providerStartDate");
    String endDate = (String) session.getAttribute("providerEndDate");
    
    if (receiptList == null || provider == null || startDate == null || endDate == null) {
        response.sendRedirect("statisticsPage.jsp");
        return;
    }
%>

<h1>Thống kê chi tiết nhà cung cấp</h1>
<button onclick="location.href='statisticsPage.jsp'" style="float: right;">Quay lại</button>
<br><br>

<div>
    Thống kê từ ngày <input type="text" value="<%= startDate %>" readonly size="12" /> 
    tới ngày <input type="text" value="<%= endDate %>" readonly size="12" />
</div>

<br>

<div>
    Nhà cung cấp: <input type="text" value="<%= provider.getName() %>" readonly size="50" />
</div>

<br>

<%
    if (receiptList != null && receiptList.size() > 0) {
%>
<table border="1">
    <tr>
        <th>STT</th>
        <th>Người nhập</th>
        <th>Ngày nhập</th>
        <th>Tổng số sản phẩm</th>
        <th>Tổng tiền</th>
        <th>Tùy chọn</th>
    </tr>
    <%
        int stt = 1;
        for (Receipt receipt : receiptList) {
            int totalQuantity = 0;
            int receiptTotal = 0;
            
            for (ReceiptProduct rp : receipt.getProducts()) {
                totalQuantity += rp.getQuantity();
                receiptTotal += rp.getQuantity() * rp.getUnitPrice();
            }
            
            if (receipt.getDiscount() != null) {
                receiptTotal -= receipt.getDiscount().getAmount();
            }
    %>
    <tr>
        <td><%= stt++ %></td>
        <td><%= receipt.getStaff() != null ? receipt.getStaff().getFullName() : "" %></td>
        <td><%= receipt.getCreatedDate() %></td>
        <td><%= totalQuantity %></td>
        <td><%= receiptTotal %></td>
        <td>
            <a href="receiptDetailPage.jsp?receiptId=<%= receipt.getId() %>">Xem chi tiết</a>
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
<p>Không có phiếu nhập nào trong khoảng thời gian này.</p>
<%
    }
%>

</body>
</html>

