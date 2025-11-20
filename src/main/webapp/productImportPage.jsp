<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*,java.text.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Nhập trang phục về từ nhà cung cấp</title>
</head>
<body>
<%  
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null){
        response.sendRedirect("login.jsp?err=timeout");
        return;
    }
    
    List<Receipt> receiptList = (List<Receipt>) request.getAttribute("receiptList");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>

<h1>Nhập trang phục về từ nhà cung cấp</h1>
<button onclick="location.href='homepage.jsp'" style="float: right;">Quay lại</button>
<br><br>

<form name="searchForm" action="doSearchReceipt.jsp" method="post">
    <input type="text" name="keyword" id="keyword" size="50" />
    <input type="submit" value="Tìm kiếm" />
</form>

<br>

<button onclick="location.href='createImportReceiptPage.jsp'">Tạo phiếu nhập mới</button>

<br>

<%
    if (receiptList != null && receiptList.size() > 0) {
%>
<table border="1">
    <tr>
        <th>STT</th>
        <th>Mã phiếu</th>
        <th>Ngày tạo</th>
        <th>Nhân viên</th>
        <th>Nhà cung cấp</th>
    </tr>
    <%
        int stt = 1;
        for (Receipt receipt : receiptList) {
            request.setAttribute("receipt_" + receipt.getId(), receipt);
    %>
    <tr>
        <td><%= stt++ %></td>
        <td><%= receipt.getId() %></td>
        <td><%= receipt.getCreatedDate() != null ? sdf.format(receipt.getCreatedDate()) : "" %></td>
        <td><%= receipt.getStaff() != null ? receipt.getStaff().getFullName() : "" %></td>
        <td><%= receipt.getProvider() != null ? receipt.getProvider().getName() : "" %></td>
    </tr>
    <%
        }
    %>
</table>
<%
    } else if (request.getAttribute("searched") != null && (Boolean)request.getAttribute("searched")) {
%>
<p>Không tìm thấy phiếu nhập nào.</p>
<%
    }
%>

</body>
</html>

