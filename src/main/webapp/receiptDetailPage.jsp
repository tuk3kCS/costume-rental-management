<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Chi tiết phiếu nhập</title>
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
    
    String receiptIdStr = request.getParameter("receiptId");
    if (receiptIdStr == null || receiptIdStr.isEmpty()) {
        response.sendRedirect("statisticsPage.jsp");
        return;
    }
    
    int receiptId = Integer.parseInt(receiptIdStr);
    
    List<Receipt> receiptList = (List<Receipt>) session.getAttribute("receiptList");
    if (receiptList == null) {
        response.sendRedirect("statisticsPage.jsp");
        return;
    }
    
    Receipt receipt = null;
    for (Receipt r : receiptList) {
        if (r.getId() == receiptId) {
            receipt = r;
            break;
        }
    }
    
    if (receipt == null) {
        response.sendRedirect("statisticsPage.jsp");
        return;
    }
    
    int totalDiscount = 0;
    int totalAmount = 0;
    
    for (ReceiptProduct rp : receipt.getProducts()) {
        totalAmount += rp.getQuantity() * rp.getUnitPrice();
    }
    
    if (receipt.getDiscount() != null) {
        totalDiscount = receipt.getDiscount().getAmount();
    }
    
    int finalTotal = totalAmount - totalDiscount;
%>

<h1>Chi tiết phiếu nhập</h1>
<button onclick="history.back()" style="float: right;">Quay lại</button>
<br><br>

<div>
    Nhân viên nhập: <%= receipt.getStaff() != null ? receipt.getStaff().getFullName() : "" %>
</div>
<div>
    Ngày nhập: <%= receipt.getCreatedDate() %>
</div>
<div>
    Nhà cung cấp: <%= receipt.getProvider() != null ? receipt.getProvider().getName() : "" %>
</div>
<div>
    Danh sách mặt hàng:
</div>

<br>

<table border="1">
    <tr>
        <th>Tên</th>
        <th>Cỡ</th>
        <th>Màu</th>
        <th>Đơn giá</th>
        <th>Số lượng</th>
        <th>Chiết khấu</th>
        <th>Thành tiền</th>
    </tr>
    <%
        for (ReceiptProduct rp : receipt.getProducts()) {
            int subtotal = rp.getQuantity() * rp.getUnitPrice();
    %>
    <tr>
        <td><%= rp.getProduct().getName() %></td>
        <td><%= rp.getProduct().getSize() %></td>
        <td><%= rp.getProduct().getColor() %></td>
        <td><%= rp.getUnitPrice() %></td>
        <td><%= rp.getQuantity() %></td>
        <td>0</td>
        <td><%= subtotal %></td>
    </tr>
    <%
        }
    %>
</table>

<br>

<div>
    Mã chiết khấu: <%= receipt.getDiscount() != null ? receipt.getDiscount().getDiscountCode() : "" %>
</div>

<br>

<div>
    Tổng chiết khấu: <%= totalDiscount %>
</div>
<div>
    Tổng tiền: <%= finalTotal %>
</div>

</body>
</html>

