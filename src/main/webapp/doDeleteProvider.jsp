<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Xử lý xóa nhà cung cấp</title>
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
        
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("providerManagementPage.jsp");
            return;
        }
        
        int id = Integer.parseInt(idParam);
        ProviderDAO dao = new ProviderDAO();
        
        Provider provider = new Provider();
        provider.setId(id);
        
        boolean result = dao.deleteProvider(provider);
        
        if (result) {
%>
<script type="text/javascript">
    alert('Xóa thành công!');
    window.location.href='providerManagementPage.jsp';
</script>
<%
        }
        
        else {
%>
<script type="text/javascript">
    alert('Xóa thất bại!');
    window.location.href='providerManagementPage.jsp';
</script>
<%
        }
    }
    
    catch (Exception e) {
        e.printStackTrace();
%>
<script type="text/javascript">
    alert('Có lỗi xảy ra!');
    window.location.href='providerManagementPage.jsp';
</script>
<%
    }
%>
</body>
</html>

