<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,java.text.*,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Xử lý thống kê chi tiết nhà cung cấp</title>
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
        // Lấy tham số từ URL
        String providerIdStr = request.getParameter("providerId");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        
        if (providerIdStr == null || providerIdStr.isEmpty() || 
            startDateStr == null || startDateStr.isEmpty() || 
            endDateStr == null || endDateStr.isEmpty()) {
%>
<script type="text/javascript">
    alert('Thiếu thông tin!');
    window.location.href='statisticsPage.jsp';
</script>
<%
            return;
        }
        
        int providerId = Integer.parseInt(providerIdStr);
        
        // Parse date
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date startDate = sdf.parse(startDateStr);
        java.util.Date endDate = sdf.parse(endDateStr);
        
        // Chuyển sang java.sql.Date
        java.sql.Date sqlStartDate = new java.sql.Date(startDate.getTime());
        java.sql.Date sqlEndDate = new java.sql.Date(endDate.getTime());
        
        // Gọi DAO để lấy danh sách phiếu nhập
        ReceiptDAO dao = new ReceiptDAO();
        List<Receipt> receiptList = dao.getReceiptList(sqlStartDate, sqlEndDate, providerId);
        
        // Tính tổng doanh chi cho nhà cung cấp này
        int totalExpense = 0;
        for (Receipt receipt : receiptList) {
            for (ReceiptProduct rp : receipt.getProducts()) {
                totalExpense += rp.getQuantity() * rp.getUnitPrice();
            }
            if (receipt.getDiscount() != null) {
                totalExpense -= receipt.getDiscount().getAmount();
            }
        }
        
        // Lấy thông tin provider (từ receipt đầu tiên hoặc query lại)
        Provider provider = null;
        if (receiptList != null && receiptList.size() > 0) {
            provider = receiptList.get(0).getProvider();
        } else {
            // Nếu không có receipt, query thông tin provider
            ProviderDAO providerDAO = new ProviderDAO();
            provider = providerDAO.getProviderById(providerId);
        }
        
        // Lưu vào request để forward sang trang hiển thị
        request.setAttribute("receiptList", receiptList);
        request.setAttribute("provider", provider);
        request.setAttribute("totalExpense", totalExpense);
        request.setAttribute("totalReceipts", receiptList.size());
        request.setAttribute("startDate", startDateStr);
        request.setAttribute("endDate", endDateStr);
        
        // Forward sang trang hiển thị kết quả
        request.getRequestDispatcher("providerStatisticsPage.jsp").forward(request, response);
        
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

