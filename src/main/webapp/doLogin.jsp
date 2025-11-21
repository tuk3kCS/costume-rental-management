<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.ArrayList,dao.*,model.*"%>
 
<%
    String username = (String) request.getParameter("username");
    String password = (String) request.getParameter("password");
    
    User user = new User();
    user.setUsername(username);
    if (password == null || password.isEmpty()) {
        response.sendRedirect("login.jsp?err=empty");
        return;
    }
    
    user.setPassword(password);
    
    UserDAO dao = new UserDAO();
    boolean result = dao.checkLogin(user);

    if (result) {
        Staff staff = new StaffDAO().getStaffInfor(username);
        session.setAttribute("staff", staff);
        response.sendRedirect("homepage.jsp");
    }
    
    else {
        response.sendRedirect("login.jsp?err=fail");
    }
%>