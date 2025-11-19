<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Lưu phiếu nhập</title>
</head>
<body>
<%
    try {
        Receipt receipt = (Receipt) session.getAttribute("currentReceipt");
        
        if (receipt == null) {
%>
<script type="text/javascript">
    alert('Không tìm thấy phiếu nhập!');
    window.location.href='createImportReceiptPage.jsp';
</script>
<%
            return;
        }
        
        // Kiểm tra dữ liệu
        if (receipt.getProvider() == null) {
%>
<script type="text/javascript">
    alert('Vui lòng chọn nhà cung cấp!');
    window.location.href='createImportReceiptPage.jsp';
</script>
<%
            return;
        }
        
        if (receipt.getProducts() == null || receipt.getProducts().size() == 0) {
%>
<script type="text/javascript">
    alert('Vui lòng thêm ít nhất một sản phẩm!');
    window.location.href='createImportReceiptPage.jsp';
</script>
<%
            return;
        }
        
        // Lưu receipt vào database
        ReceiptDAO dao = new ReceiptDAO();
        boolean result = dao.saveReceipt(receipt);
        
        if (result) {
            // Xóa receipt khỏi session sau khi lưu thành công
            session.removeAttribute("currentReceipt");
%>
<script type="text/javascript">
    alert('Lưu phiếu nhập thành công!');
    window.location.href='productImportPage.jsp';
</script>
<%
        } else {
%>
<script type="text/javascript">
    alert('Lưu phiếu nhập thất bại!');
    window.location.href='createImportReceiptPage.jsp';
</script>
<%
        }
        
    } catch (Exception e) {
        e.printStackTrace();
%>
<script type="text/javascript">
    alert('Có lỗi xảy ra: <%= e.getMessage() %>');
    window.location.href='createImportReceiptPage.jsp';
</script>
<%
    }
%>
</body>
</html>

