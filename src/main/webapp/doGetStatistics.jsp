<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,java.text.*,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Xử lý thống kê</title>
</head>
<body>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null){
        response.sendRedirect("login.jsp?err=timeout");
        return;
    }
    
    // Kiểm tra quyền truy cập
    String role = staff.getRole();
    if (role == null || !role.equalsIgnoreCase("manager")) {
        response.sendRedirect("homepage.jsp");
        return;
    }
    
    try {
        // Lấy tham số từ form
        String statisticsType = request.getParameter("statisticsType");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        
        if (startDateStr == null || startDateStr.isEmpty() || endDateStr == null || endDateStr.isEmpty()) {
%>
<script type="text/javascript">
    alert('Vui lòng nhập đầy đủ thông tin!');
    window.location.href='statisticsPage.jsp';
</script>
<%
            return;
        }
        
        // Parse date
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date startDate = sdf.parse(startDateStr);
        java.util.Date endDate = sdf.parse(endDateStr);
        
        // Kiểm tra ngày kết thúc phải sau ngày bắt đầu
        if (endDate.before(startDate)) {
%>
<script type="text/javascript">
    alert('Ngày kết thúc phải sau ngày bắt đầu!');
    window.location.href='statisticsPage.jsp';
</script>
<%
            return;
        }
        
        // Gọi DAO để lấy thống kê
        ProviderStatDAO dao = new ProviderStatDAO();
        List<ProviderStatDAO.ProviderStat> statList = dao.getProviderStat(startDate, endDate);
        
        // Tính tổng doanh chi
        int totalExpense = 0;
        for (ProviderStatDAO.ProviderStat stat : statList) {
            totalExpense += stat.getTotalExpense();
        }
        
        // Lưu vào request để forward sang trang hiển thị
        request.setAttribute("statList", statList);
        request.setAttribute("totalExpense", totalExpense);
        request.setAttribute("startDate", startDateStr);
        request.setAttribute("endDate", endDateStr);
        
        // Forward sang trang hiển thị kết quả
        request.getRequestDispatcher("expenseStatisticsPage.jsp").forward(request, response);
        
    } catch (Exception e) {
        e.printStackTrace();
%>
<script type="text/javascript">
    alert('Có lỗi xảy ra: <%= e.getMessage() %>');
    window.location.href='statisticsPage.jsp';
</script>
<%
    }
%>
</body>
</html>

