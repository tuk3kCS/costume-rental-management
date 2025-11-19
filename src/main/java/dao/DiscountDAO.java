package dao;

import model.Discount;
import model.ProductDiscount;
import model.ReceiptDiscount;
import java.sql.*;

public class DiscountDAO extends DAO {
    public DiscountDAO(){
        super();
    }
    
    public boolean saveDiscount(Discount discount, Integer productId) throws Exception {
        try {
            // Bắt đầu transaction
            con.setAutoCommit(false);
            
            // Insert vào tblDiscount
            String sqlDiscount = "INSERT INTO tblDiscount (discountCode, amount, provider) VALUES (?, ?, ?)";
            PreparedStatement pstmtDiscount = con.prepareStatement(sqlDiscount, Statement.RETURN_GENERATED_KEYS);
            pstmtDiscount.setString(1, discount.getDiscountCode());
            pstmtDiscount.setInt(2, discount.getAmount());
            pstmtDiscount.setString(3, discount.getProvider());
            
            int result = pstmtDiscount.executeUpdate();
            
            if (result > 0) {
                // Lấy ID của discount vừa insert
                ResultSet rs = pstmtDiscount.getGeneratedKeys();
                int discountId = 0;
                if (rs.next()) {
                    discountId = rs.getInt(1);
                }
                
                // Kiểm tra có productId hay không
                if (productId != null && productId > 0) {
                    // Có productId -> Insert vào tblProductDiscount
                    String sqlProductDiscount = "INSERT INTO tblProductDiscount (discountId, productId) VALUES (?, ?)";
                    PreparedStatement pstmtProductDiscount = con.prepareStatement(sqlProductDiscount);
                    pstmtProductDiscount.setInt(1, discountId);
                    pstmtProductDiscount.setInt(2, productId);
                    pstmtProductDiscount.executeUpdate();
                } else {
                    // Không có productId -> Insert vào tblReceiptDiscount
                    String sqlReceiptDiscount = "INSERT INTO tblReceiptDiscount (discountId) VALUES (?)";
                    PreparedStatement pstmtReceiptDiscount = con.prepareStatement(sqlReceiptDiscount);
                    pstmtReceiptDiscount.setInt(1, discountId);
                    pstmtReceiptDiscount.executeUpdate();
                }
                
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

    public Discount searchDiscount(String discountCode) throws Exception {
        String sql = "SELECT d.*, p.id as productId FROM tblDiscount d " +
                     "LEFT JOIN tblProduct p ON d.productId = p.id " +
                     "WHERE d.discountCode = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, discountCode);
        ResultSet rs = pstmt.executeQuery();
        
        if (rs.next()) {
            int productId = rs.getInt("productId");
            
            if (productId > 0) {
                // Đây là ProductDiscount
                ProductDiscount discount = new ProductDiscount();
                discount.setId(productId); // Lưu productId vào id để kiểm tra
                discount.setDiscountCode(rs.getString("discountCode"));
                discount.setAmount(rs.getInt("amount"));
                discount.setProvider(rs.getString("provider"));
                return discount;
            } else {
                // Đây là ReceiptDiscount
                ReceiptDiscount discount = new ReceiptDiscount();
                discount.setId(rs.getInt("id"));
                discount.setDiscountCode(rs.getString("discountCode"));
                discount.setAmount(rs.getInt("amount"));
                discount.setProvider(rs.getString("provider"));
                return discount;
            }
        }
        
        return null;
    }
}