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
%>

<h1>Nhập trang phục về từ nhà cung cấp</h1>
<button onclick="location.href='homepage.jsp'" style="float: right;">Quay lại</button>
<br><br>

<form name="searchForm" method="post">
    <input type="text" name="keyword" id="keyword" size="50" />
    <input type="submit" value="Tìm kiếm" />
</form>

<br>

<button onclick="location.href='createImportReceiptPage.jsp'">Tạo phiếu nhập mới</button>

<br>

</body>
</html>