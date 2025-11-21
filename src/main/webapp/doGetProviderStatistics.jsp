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
    
    String role = staff.getRole();
    if (role == null || !role.equalsIgnoreCase("manager")) {
        response.sendRedirect("homepage.jsp");
        return;
    }
    
    try {
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
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date startDate = sdf.parse(startDateStr);
        java.util.Date endDate = sdf.parse(endDateStr);
        
        java.sql.Date sqlStartDate = new java.sql.Date(startDate.getTime());
        java.sql.Date sqlEndDate = new java.sql.Date(endDate.getTime());
        
        ReceiptDAO dao = new ReceiptDAO();
        List<Receipt> receiptList = dao.getReceiptList(sqlStartDate, sqlEndDate, providerId);
        
        int totalExpense = 0;
        for (Receipt receipt : receiptList) {
            for (ReceiptProduct rp : receipt.getProducts()) {
                totalExpense += rp.getQuantity() * rp.getUnitPrice();
            }
            if (receipt.getDiscount() != null) {
                totalExpense -= receipt.getDiscount().getAmount();
            }
        }
        
        Provider provider = null;
        if (receiptList != null && receiptList.size() > 0) {
            provider = receiptList.get(0).getProvider();
        }
        
        else {
            List<ProviderStatDAO.ProviderStat> statList = (List<ProviderStatDAO.ProviderStat>) session.getAttribute("statList");
            if (statList == null) {
                throw new Exception("Không tìm thấy danh sách thống kê trong session");
            }
            
            for (ProviderStatDAO.ProviderStat stat : statList) {
                if (stat.getProvider().getId() == providerId) {
                    provider = stat.getProvider();
                    break;
                }
            }
            
            if (provider == null) {
                throw new Exception("Không tìm thấy nhà cung cấp với ID: " + providerId);
            }
        }
        
        session.setAttribute("receiptList", receiptList);
        session.setAttribute("provider", provider);
        session.setAttribute("totalExpense", totalExpense);
        session.setAttribute("totalReceipts", receiptList.size());
        session.setAttribute("providerStartDate", startDateStr);
        session.setAttribute("providerEndDate", endDateStr);
        
        response.sendRedirect("providerStatisticsPage.jsp");
        
    }
    
    catch (Exception e) {
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

