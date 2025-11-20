<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null){
        response.sendRedirect("login.jsp?err=timeout");
        return;
    }
    
    String keyword = request.getParameter("keyword");
    
    if (keyword == null) {
        keyword = "";
    }
    
    try {
        ReceiptDAO dao = new ReceiptDAO();
        
        List<Receipt> receiptList = dao.searchReceipt(keyword);
        
        request.setAttribute("receiptList", receiptList);
        request.setAttribute("searched", true);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("productImportPage.jsp");
        dispatcher.forward(request, response);
        
    }
    
    catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("productImportPage.jsp?err=search_failed");
    }
%>

