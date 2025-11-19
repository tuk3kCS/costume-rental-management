<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Tạo phiếu nhập mới</title>
</head>
<body>
<%
    User user = (User) session.getAttribute("user");
    if (user == null){
        response.sendRedirect("login.jsp?err=timeout");
        return;
    }
    
    // Tạo Receipt object khi vào trang lần đầu
    Receipt receipt = (Receipt) session.getAttribute("currentReceipt");
    if (receipt == null || request.getParameter("new") != null) {
        receipt = new Receipt();
        receipt.setCreatedDate(new java.util.Date());
        
        Staff staff = new Staff();
        staff.setId(user.getId());
        staff.setUsername(user.getUsername());
        staff.setFullName(user.getFullName());
        receipt.setStaff(staff);
        
        receipt.setProducts(new ArrayList<ReceiptProduct>());
        session.setAttribute("currentReceipt", receipt);
    }
    
    // Lấy danh sách provider và product để hiển thị trong dropdown
    ProviderDAO providerDAO = new ProviderDAO();
    ProductDAO productDAO = new ProductDAO();
    List<Provider> providers = providerDAO.getProviderList();
    List<Product> products = productDAO.getProductList();
%>

<h2>Tạo phiếu nhập mới</h2>
<button onclick="location.href='productImportPage.jsp'" style="float: right;">Quay lại</button>
<br><br>

<!-- Form chọn nhà cung cấp -->
<form name="selectProviderForm" method="post">
    Nhà cung cấp
    <select name="providerId" id="providerId" onchange="this.form.submit()">
        <option value="">-- Chọn nhà cung cấp --</option>
        <%
            for (Provider p : providers) {
                String selected = (receipt.getProvider() != null && receipt.getProvider().getId() == p.getId()) ? "selected" : "";
        %>
        <option value="<%= p.getId() %>" <%= selected %>><%= p.getName() %></option>
        <%
            }
        %>
    </select>
    <button type="button" onclick="location.href='addProviderPage.jsp?from=createImportReceiptPage.jsp'">Thêm nhà cung cấp</button>
</form>

<%
    // Xử lý chọn provider
    String providerIdParam = request.getParameter("providerId");
    if (providerIdParam != null && !providerIdParam.isEmpty()) {
        int providerId = Integer.parseInt(providerIdParam);
        for (Provider p : providers) {
            if (p.getId() == providerId) {
                receipt.setProvider(p);
                session.setAttribute("currentReceipt", receipt);
                break;
            }
        }
    }
%>

<br>

<!-- Form chọn mặt hàng và nhập số lượng -->
<form name="addProductForm" method="post">
    Mặt hàng
    <select name="productId" id="productId">
        <option value="">-- Chọn mặt hàng --</option>
        <%
            for (Product prod : products) {
        %>
        <option value="<%= prod.getId() %>"><%= prod.getName() %> - <%= prod.getSize() %> - <%= prod.getColor() %></option>
        <%
            }
        %>
    </select>
    Số lượng
    <input type="number" name="quantity" id="quantity" min="1" value="1" />
    <button type="submit" name="action" value="addProduct">Nhập thêm</button>
    <button type="button" onclick="location.href='addProductPage.jsp?from=createImportReceiptPage.jsp'">Thêm mặt hàng chưa có trong DS</button>
</form>

<%
    // Xử lý thêm sản phẩm vào receipt
    String action = request.getParameter("action");
    if ("addProduct".equals(action)) {
        String productIdParam = request.getParameter("productId");
        String quantityParam = request.getParameter("quantity");
        
        if (productIdParam != null && !productIdParam.isEmpty() && quantityParam != null) {
            int productId = Integer.parseInt(productIdParam);
            int quantity = Integer.parseInt(quantityParam);
            
            for (Product prod : products) {
                if (prod.getId() == productId) {
                    ReceiptProduct rp = new ReceiptProduct();
                    rp.setProduct(prod);
                    rp.setQuantity(quantity);
                    rp.setUnitPrice(100000); // Giá mặc định, có thể lấy từ database
                    receipt.getProducts().add(rp);
                    session.setAttribute("currentReceipt", receipt);
                    break;
                }
            }
        }
    }
    
    // Xử lý xóa sản phẩm
    if ("removeProduct".equals(action)) {
        String indexParam = request.getParameter("index");
        if (indexParam != null) {
            int index = Integer.parseInt(indexParam);
            receipt.getProducts().remove(index);
            session.setAttribute("currentReceipt", receipt);
        }
    }
%>

<br>

<!-- Hiển thị thông tin nhân viên nhập và nhà cung cấp -->
Nhân viên nhập: <%= receipt.getStaff() != null ? receipt.getStaff().getFullName() : "" %><br>
Nhà cung cấp: <%= receipt.getProvider() != null ? receipt.getProvider().getName() : "" %><br>
Danh sách mặt hàng:<br>

<!-- Bảng danh sách sản phẩm -->
<%
    if (receipt.getProducts() != null && receipt.getProducts().size() > 0) {
%>
<table border="1">
    <tr>
        <th>Tên</th>
        <th>Cỡ</th>
        <th>Màu</th>
        <th>Đơn giá</th>
        <th>Số lượng</th>
        <th>Chiết khấu</th>
        <th>Thành tiền</th>
        <th>Tùy chọn</th>
    </tr>
    <%
        int totalAmount = 0;
        int totalDiscount = 0;
        for (int i = 0; i < receipt.getProducts().size(); i++) {
            ReceiptProduct rp = receipt.getProducts().get(i);
            int subtotal = rp.getUnitPrice() * rp.getQuantity();
            totalAmount += subtotal;
            
            // Tính chiết khấu cho sản phẩm này nếu có
            int productDiscount = 0;
            if (receipt.getDiscount() != null && receipt.getDiscount() instanceof ProductDiscount) {
                // Kiểm tra xem discount có áp dụng cho product này không
                // Logic này sẽ được xử lý trong doSearchDiscount.jsp
            }
            totalDiscount += productDiscount;
    %>
    <tr>
        <td><%= rp.getProduct().getName() %></td>
        <td><%= rp.getProduct().getSize() %></td>
        <td><%= rp.getProduct().getColor() %></td>
        <td><%= rp.getUnitPrice() %></td>
        <td><%= rp.getQuantity() %></td>
        <td><%= productDiscount %></td>
        <td><%= subtotal %></td>
        <td>
            <form method="post" style="display:inline;">
                <input type="hidden" name="action" value="removeProduct" />
                <input type="hidden" name="index" value="<%= i %>" />
                <button type="submit">Xóa</button>
            </form>
        </td>
    </tr>
    <%
        }
        
        // Tính chiết khấu receipt nếu có
        int receiptDiscount = 0;
        if (receipt.getDiscount() != null && receipt.getDiscount() instanceof ReceiptDiscount) {
            receiptDiscount = receipt.getDiscount().getAmount();
            totalDiscount += receiptDiscount;
        }
        
        int finalTotal = totalAmount - totalDiscount;
    %>
</table>
<%
    } else {
%>
<p>Chưa có sản phẩm nào</p>
<%
    }
%>

<br>

<!-- Form nhập mã chiết khấu -->
<form name="discountForm" action="doSearchDiscount.jsp" method="post">
    Mã chiết khấu
    <input type="text" name="discountCode" id="discountCode" />
    <button type="button" onclick="location.href='addDiscountPage.jsp'">Thêm mã chiết khấu</button>
    <button type="submit">Áp dụng</button>
</form>

<br>

<!-- Hiển thị tổng tiền -->
Tổng chiết khấu: <%= totalDiscount %><br>
Tổng tiền: <%= finalTotal %><br>

<br>

<!-- Nút Lưu và Hủy -->
<form action="doSaveReceipt.jsp" method="post">
    <button type="submit">Lưu</button>
    <button type="button" onclick="if(confirm('Hủy tạo phiếu nhập?')) location.href='productImportPage.jsp'">Hủy</button>
</form>

</body>
</html>

