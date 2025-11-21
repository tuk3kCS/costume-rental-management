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
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null){
        response.sendRedirect("login.jsp?err=timeout");
        return;
    }
    
    Receipt receipt = (Receipt) session.getAttribute("currentReceipt");
    if (receipt == null || request.getParameter("new") != null) {
        receipt = new Receipt();
        receipt.setCreatedDate(new java.util.Date());
        receipt.setStaff(staff);
        
        receipt.setProducts(new ArrayList<ReceiptProduct>());
        session.setAttribute("currentReceipt", receipt);
    }
    
    ProviderDAO providerDAO = new ProviderDAO();
    ProductDAO productDAO = new ProductDAO();
    List<Provider> providers = providerDAO.getProviderList();
    
    String providerIdParam = request.getParameter("providerId");
    if (providerIdParam != null && !providerIdParam.isEmpty()) {
        int providerId = Integer.parseInt(providerIdParam);
        
        boolean providerChanged = (receipt.getProvider() == null || receipt.getProvider().getId() != providerId);
        
        if (providerChanged) {
            Receipt newReceipt = new Receipt();
            newReceipt.setCreatedDate(receipt.getCreatedDate());
            newReceipt.setStaff(receipt.getStaff());
            newReceipt.setProducts(new ArrayList<ReceiptProduct>());
            
            for (Provider p : providers) {
                if (p.getId() == providerId) {
                    newReceipt.setProvider(p);
                    break;
                }
            }
            
            receipt = newReceipt;
            session.setAttribute("currentReceipt", receipt);
            session.removeAttribute("discountProductId");
        }
    }
    
    List<ProviderProduct> providerProducts = new ArrayList<ProviderProduct>();
    if (receipt.getProvider() != null) {
        providerProducts = productDAO.getProductList(receipt.getProvider().getId());
    }
%>

<h2>Tạo phiếu nhập mới</h2>
<button onclick="location.href='productImportPage.jsp'" style="float: right;">Quay lại</button>
<br><br>

<form name="selectProviderForm" method="post">
    Nhà cung cấp
    <select name="providerId" id="providerId" onchange="this.form.submit()">
        <option value="">Chọn nhà cung cấp</option>
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

<br>

<form name="addProductForm" method="post">
    Mặt hàng
    <select name="providerProductId" id="providerProductId" <%= (receipt.getProvider() == null ? "disabled" : "") %>>
        <option value="">Chọn mặt hàng</option>
        <%
            for (ProviderProduct pp : providerProducts) {
        %>
        <option value="<%= pp.getId() %>"><%= pp.getProduct().getName() %> - <%= pp.getProduct().getSize() %> - <%= pp.getProduct().getColor() %> (Giá: <%= pp.getUnitPrice() %>)</option>
        <%
            }
        %>
    </select>
    Số lượng
    <input type="number" name="quantity" id="quantity" min="1" value="1" <%= (receipt.getProvider() == null ? "disabled" : "") %> />
    <button type="submit" name="action" value="addProduct" <%= (receipt.getProvider() == null ? "disabled" : "") %>>Nhập thêm</button>
    <button type="button" onclick="location.href='addProductPage.jsp?from=createImportReceiptPage.jsp'">Thêm mặt hàng chưa có trong DS</button>
</form>

<%
    String action = request.getParameter("action");
    if ("addProduct".equals(action)) {
        String providerProductIdParam = request.getParameter("providerProductId");
        String quantityParam = request.getParameter("quantity");
        
        if (providerProductIdParam != null && !providerProductIdParam.isEmpty() && quantityParam != null) {
            int providerProductId = Integer.parseInt(providerProductIdParam);
            int quantity = Integer.parseInt(quantityParam);
            
            for (ProviderProduct pp : providerProducts) {
                if (pp.getId() == providerProductId) {
                    boolean productExists = false;
                    for (ReceiptProduct rp : receipt.getProducts()) {
                        if (rp.getProduct().getId() == pp.getProduct().getId()) {
                            rp.setQuantity(rp.getQuantity() + quantity);
                            productExists = true;
                            break;
                        }
                    }
                    
                    if (!productExists) {
                        ReceiptProduct rp = new ReceiptProduct();
                        rp.setProduct(pp.getProduct());
                        rp.setQuantity(quantity);
                        rp.setUnitPrice(pp.getUnitPrice());
                        receipt.getProducts().add(rp);
                    }
                    
                    session.setAttribute("currentReceipt", receipt);
                    break;
                }
            }
        }
    }
    
    if ("removeProduct".equals(action)) {
        String indexParam = request.getParameter("index");
        if (indexParam != null) {
            int index = Integer.parseInt(indexParam);
            ReceiptProduct removedProduct = receipt.getProducts().get(index);
            
            Integer discountProductId = (Integer) session.getAttribute("discountProductId");
            if (discountProductId != null && removedProduct.getProduct().getId() == discountProductId) {
                receipt.setDiscount(null);
                session.removeAttribute("discountProductId");
            }
            
            receipt.getProducts().remove(index);
            session.setAttribute("currentReceipt", receipt);
        }
    }
%>

<br>

    Nhân viên nhập: <%= receipt.getStaff() != null ? receipt.getStaff().getFullName() : "" %><br>
    Nhà cung cấp: <%= receipt.getProvider() != null ? receipt.getProvider().getName() : "" %><br>
    Danh sách mặt hàng:

<br>

<%
    int totalAmount = 0;
    int totalDiscount = 0;
    int finalTotal = 0;
    
    Integer discountProductId = (Integer) session.getAttribute("discountProductId");
    
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
        for (int i = 0; i < receipt.getProducts().size(); i++) {
            ReceiptProduct rp = receipt.getProducts().get(i);
            int subtotal = rp.getUnitPrice() * rp.getQuantity();
            totalAmount += subtotal;
            
            int productDiscount = 0;
            if (receipt.getDiscount() != null && discountProductId != null && rp.getProduct().getId() == discountProductId) {
                productDiscount = receipt.getDiscount().getAmount();
                totalDiscount += productDiscount;
            }
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
        
        int receiptDiscount = 0;
        if (receipt.getDiscount() != null && discountProductId == null) {
            receiptDiscount = receipt.getDiscount().getAmount();
            totalDiscount += receiptDiscount;
        }
        
        finalTotal = totalAmount - totalDiscount;
    %>
</table>
<%
    }
    
    else {
%>
<p>Chưa có sản phẩm nào</p>
<%
    }
%>

<br>

<form name="discountForm" action="doSearchDiscount.jsp" method="post">
    Mã chiết khấu
    <input type="text" name="discountCode" id="discountCode" />
    <button type="submit">Áp dụng</button>
    <button type="button" onclick="location.href='addDiscountPage.jsp'">Thêm mã chiết khấu</button>
</form>

<br>

    Tổng chiết khấu: <%= totalDiscount %><br>
    Tổng tiền: <%= finalTotal %><br>

<br>

<form action="doSaveReceipt.jsp" method="post">
    <button type="submit">Lưu</button>
    <button type="button" onclick="if(confirm('Hủy tạo phiếu nhập?')) location.href='productImportPage.jsp'">Hủy</button>
</form>

</body>
</html>

