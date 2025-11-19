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
            String sqlReceipt = "INSERT INTO tblReceipt (createdDate, staffId, providerId, discountId) VALUES (?, ?, ?, ?)";
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
                String sqlProduct = "INSERT INTO tblReceiptProduct (receiptId, productId, quantity, unitPrice) VALUES (?, ?, ?, ?)";
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
        return new ArrayList<>();
    }

    public List<Receipt> searchReceipt(String keyword) throws Exception {
        List<Receipt> receiptList = new ArrayList<>();
        String sql = "SELECT r.*, s.fullName as staffName, p.name as providerName, p.id as providerId " +
                     "FROM tblreceipt r " +
                     "LEFT JOIN tblstaff s ON r.staffId = s.id " +
                     "LEFT JOIN tblprovider p ON r.providerId = p.id " +
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
            staff.setId(rs.getInt("staffId"));
            staff.setFullName(rs.getString("staffName"));
            receipt.setStaff(staff);
            
            Provider provider = new Provider();
            provider.setId(rs.getInt("providerId"));
            provider.setName(rs.getString("providerName"));
            receipt.setProvider(provider);
            
            receiptList.add(receipt);
        }
        
        return receiptList;
    }
}