<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<%
    String keyword = request.getParameter("keyword");
    
    if (keyword == null) {
        keyword = "";
    }
    
    try {
        ProviderDAO dao = new ProviderDAO();
        
        List<Provider> providerList = dao.searchProvider(keyword);
        
        request.setAttribute("providerList", providerList);
        request.setAttribute("searched", true);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("providerManagementPage.jsp");
        dispatcher.forward(request, response);
        
    }
    
    catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("providerManagementPage.jsp?err=search_failed");
    }
%>

