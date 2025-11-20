<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Xử lý lưu nhà cung cấp</title>
</head>
<body>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null){
        response.sendRedirect("login.jsp?err=timeout");
        return;
    }
    
    try {
        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phoneNo = request.getParameter("phoneNo");
        String email = request.getParameter("email");
        String from = request.getParameter("from");
        
        if (from == null || from.isEmpty()) {
            from = "providerManagementPage.jsp";
        }
        
        Provider provider = new Provider();
        if (idParam != null && !idParam.isEmpty()) {
            provider.setId(Integer.parseInt(idParam));
        }
        provider.setName(name);
        provider.setAddress(address);
        provider.setPhoneNo(phoneNo);
        provider.setEmail(email);
        
        ProviderDAO dao = new ProviderDAO();
        Provider existingProvider = dao.checkProvider(provider);
        
        if (existingProvider != null) {
            String redirectUrl;
            if (provider.getId() > 0) {
                request.setAttribute("provider_" + provider.getId(), provider);
                redirectUrl = "modifyProviderPage.jsp?id=" + provider.getId();
            }
            
            else {
                redirectUrl = "addProviderPage.jsp?from=" + from;
            }
%>
<script type="text/javascript">
    alert('Email hoặc số điện thoại đã tồn tại trên hệ thống!');
    window.location.href='<%= redirectUrl %>';
</script>
<%
        }
        
        else {
            boolean result = dao.saveProvider(provider);
            
            if (result) {
%>
<script type="text/javascript">
    alert('Lưu thành công!');
    window.location.href='<%= from %>';
</script>
<%
            }
            
            else {
                String redirectUrl;
                if (provider.getId() > 0) {
                    request.setAttribute("provider_" + provider.getId(), provider);
                    redirectUrl = "modifyProviderPage.jsp?id=" + provider.getId();
                }
                
                else {
                    redirectUrl = "addProviderPage.jsp?from=" + from;
                }
%>
<script type="text/javascript">
    alert('Lưu thất bại!');
    window.location.href='<%= redirectUrl %>';
</script>
<%
            }
        }
        
    }
    
    catch (Exception e) {
        e.printStackTrace();
        String from = request.getParameter("from");
        if (from == null || from.isEmpty()) {
            from = "providerManagementPage.jsp";
        }
%>
<script type="text/javascript">
    alert('Có lỗi xảy ra!');
    window.location.href='<%= from %>';
</script>
<%
    }
%>
</body>
</html>
