package dao;

import model.Receipt;
import model.ReceiptProduct;
import model.Staff;
import model.Provider;
import java.sql.*;
import java.util.*;

public class ReceiptDAO extends DAO {
    public ReceiptDAO(){
        super();
    }

    public boolean saveReceipt(Receipt receipt) throws Exception {
        try {
            // Bắt đầu transaction
            con.setAutoCommit(false);
            
            // Insert vào tblReceipt
            String sqlReceipt = "INSERT INTO tblReceipt (createdDate, tblUserId, tblProviderId, tblDiscountId) VALUES (?, ?, ?, ?)";
            PreparedStatement pstmtReceipt = con.prepareStatement(sqlReceipt, Statement.RETURN_GENERATED_KEYS);
            pstmtReceipt.setDate(1, new java.sql.Date(receipt.getCreatedDate().getTime()));
            pstmtReceipt.setInt(2, receipt.getStaff().getId());
            pstmtReceipt.setInt(3, receipt.getProvider().getId());
            
            if (receipt.getDiscount() != null) {
                pstmtReceipt.setInt(4, receipt.getDiscount().getId());
            } else {
                pstmtReceipt.setNull(4, java.sql.Types.INTEGER);
            }
            
            int result = pstmtReceipt.executeUpdate();
            
            if (result > 0) {
                // Lấy ID của receipt vừa insert
                ResultSet rs = pstmtReceipt.getGeneratedKeys();
                int receiptId = 0;
                if (rs.next()) {
                    receiptId = rs.getInt(1);
                }
                
                // Insert các sản phẩm vào tblReceiptProduct
                String sqlProduct = "INSERT INTO tblReceiptProduct (tblReceiptId, tblProductId, quantity, unitPrice) VALUES (?, ?, ?, ?)";
                PreparedStatement pstmtProduct = con.prepareStatement(sqlProduct);
                
                for (ReceiptProduct rp : receipt.getProducts()) {
                    pstmtProduct.setInt(1, receiptId);
                    pstmtProduct.setInt(2, rp.getProduct().getId());
                    pstmtProduct.setInt(3, rp.getQuantity());
                    pstmtProduct.setInt(4, rp.getUnitPrice());
                    pstmtProduct.addBatch();
                }
                
                pstmtProduct.executeBatch();
                
                // Commit transaction
                con.commit();
                con.setAutoCommit(true);
                return true;
            }
            
            con.rollback();
            con.setAutoCommit(true);
            return false;
            
        } catch (Exception e) {
            con.rollback();
            con.setAutoCommit(true);
            throw e;
        }
    }

    public List<Receipt> getReceiptList(java.sql.Date startTime, java.sql.Date endTime, int providerId) throws Exception {
        List<Receipt> receiptList = new ArrayList<>();
        
        // Query để lấy danh sách phiếu nhập theo providerId và khoảng thời gian
        String sql = "SELECT r.id, r.createdDate, r.tblUserId, r.tblProviderId, r.tblDiscountId, " +
                     "u.username, u.fullName, u.role, " +
                     "p.name as providerName, p.address, p.phoneNo, p.email " +
                     "FROM tblReceipt r " +
                     "INNER JOIN tblUser u ON r.tblUserId = u.id " +
                     "INNER JOIN tblProvider p ON r.tblProviderId = p.id " +
                     "WHERE r.tblProviderId = ? AND r.createdDate BETWEEN ? AND ? " +
                     "ORDER BY r.createdDate DESC";
        
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, providerId);
        pstmt.setDate(2, startTime);
        pstmt.setDate(3, endTime);
        ResultSet rs = pstmt.executeQuery();
        
        while (rs.next()) {
            Receipt receipt = new Receipt();
            receipt.setId(rs.getInt("id"));
            receipt.setCreatedDate(rs.getDate("createdDate"));
            
            // Tạo đối tượng Staff
            Staff staff = new Staff();
            staff.setId(rs.getInt("tblUserId"));
            staff.setUsername(rs.getString("username"));
            staff.setFullName(rs.getString("fullName"));
            staff.setRole(rs.getString("role"));
            receipt.setStaff(staff);
            
            // Tạo đối tượng Provider
            Provider provider = new Provider();
            provider.setId(rs.getInt("tblProviderId"));
            provider.setName(rs.getString("providerName"));
            provider.setAddress(rs.getString("address"));
            provider.setPhoneNo(rs.getString("phoneNo"));
            provider.setEmail(rs.getString("email"));
            receipt.setProvider(provider);
            
            // Lấy Discount (nếu có)
            int discountId = rs.getInt("tblDiscountId");
            if (!rs.wasNull() && discountId > 0) {
                String sqlDiscount = "SELECT * FROM tblDiscount WHERE id = ?";
                PreparedStatement pstmtDiscount = con.prepareStatement(sqlDiscount);
                pstmtDiscount.setInt(1, discountId);
                ResultSet rsDiscount = pstmtDiscount.executeQuery();
                
                if (rsDiscount.next()) {
                    model.Discount discount = new model.Discount();
                    discount.setId(rsDiscount.getInt("id"));
                    discount.setDiscountCode(rsDiscount.getString("discountCode"));
                    discount.setAmount(rsDiscount.getInt("amount"));
                    receipt.setDiscount(discount);
                }
            }
            
            // Lấy danh sách sản phẩm trong phiếu nhập
            String sqlProducts = "SELECT rp.id, rp.quantity, rp.unitPrice, " +
                                 "prod.id as productId, prod.name, prod.size, prod.color " +
                                 "FROM tblReceiptProduct rp " +
                                 "INNER JOIN tblProduct prod ON rp.tblProductId = prod.id " +
                                 "WHERE rp.tblReceiptId = ?";
            PreparedStatement pstmtProducts = con.prepareStatement(sqlProducts);
            pstmtProducts.setInt(1, receipt.getId());
            ResultSet rsProducts = pstmtProducts.executeQuery();
            
            ArrayList<ReceiptProduct> products = new ArrayList<>();
            while (rsProducts.next()) {
                ReceiptProduct rp = new ReceiptProduct();
                rp.setId(rsProducts.getInt("id"));
                rp.setQuantity(rsProducts.getInt("quantity"));
                rp.setUnitPrice(rsProducts.getInt("unitPrice"));
                
                model.Product product = new model.Product();
                product.setId(rsProducts.getInt("productId"));
                product.setName(rsProducts.getString("name"));
                product.setSize(rsProducts.getString("size"));
                product.setColor(rsProducts.getString("color"));
                rp.setProduct(product);
                
                products.add(rp);
            }
            receipt.setProducts(products);
            
            receiptList.add(receipt);
        }
        
        return receiptList;
    }

    public List<Receipt> searchReceipt(String keyword) throws Exception {
        List<Receipt> receiptList = new ArrayList<>();
        String sql = "SELECT r.*, s.fullName as staffName, p.name as providerName, p.id as tblProviderId " +
                     "FROM tblReceipt r " +
                     "LEFT JOIN tblUser s ON r.tblUserId = s.id " +
                     "LEFT JOIN tblProvider p ON r.tblProviderId = p.id " +
                     "WHERE CAST(r.id AS CHAR) LIKE ? OR s.fullName LIKE ? OR p.name LIKE ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        String searchPattern = "%" + keyword + "%";
        pstmt.setString(1, searchPattern);
        pstmt.setString(2, searchPattern);
        pstmt.setString(3, searchPattern);
        ResultSet rs = pstmt.executeQuery();
        
        while (rs.next()) {
            Receipt receipt = new Receipt();
            receipt.setId(rs.getInt("id"));
            receipt.setCreatedDate(rs.getDate("createdDate"));
            
            Staff staff = new Staff();
            staff.setId(rs.getInt("tblUserId"));
            staff.setFullName(rs.getString("staffName"));
            receipt.setStaff(staff);
            
            Provider provider = new Provider();
            provider.setId(rs.getInt("tblProviderId"));
            provider.setName(rs.getString("providerName"));
            receipt.setProvider(provider);
            
            receiptList.add(receipt);
        }
        
        return receiptList;
    }
}