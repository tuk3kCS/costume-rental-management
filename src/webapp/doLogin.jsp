<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.ArrayList,java.dao.*,java.model.*"%>
 
<%
    String username = (String) request.getParameter ("username");
    String password = (String) request.getParameter ("password");
    
    User user = new User();
    user.setUsername(username);
    if (password == null || password.isEmpty()) {
        response.sendRedirect("login.jsp?err=empty");
        return;
    }
    user.setPassword(password);
 
    UserDAO dao = new UserDAO();
    boolean kq = dao.checkLogin(user);

    if (kq) {
        session.setAttribute("user", user);
        response.sendRedirect("homepage.jsp");
    }
    else {
        response.sendRedirect("login.jsp?err=fail");
    }
%>