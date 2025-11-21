package dao;

import model.Discount;
import java.sql.*;

public class DiscountDAO extends DAO {
    
    public static class Pair<T, U> {
        private T first;
        private U second;
        
        public Pair(T first, U second) {
            this.first = first;
            this.second = second;
        }
        
        public T getFirst() {
            return first;
        }
        
        public U getSecond() {
            return second;
        }
    }
    
    public DiscountDAO(){
        super();
    }
    
    public boolean saveDiscount(Discount discount, int providerId, Integer productId) throws Exception {
        try {
            con.setAutoCommit(false);

            String sqlDiscount = "INSERT INTO tblDiscount (discountCode, amount, tblProviderId) VALUES (?, ?, ?)";
            PreparedStatement pstmtDiscount = con.prepareStatement(sqlDiscount, Statement.RETURN_GENERATED_KEYS);
            pstmtDiscount.setString(1, discount.getDiscountCode());
            pstmtDiscount.setInt(2, discount.getAmount());
            pstmtDiscount.setInt(3, providerId);
            
            int result = pstmtDiscount.executeUpdate();
            
            if (result > 0) {
                ResultSet rs = pstmtDiscount.getGeneratedKeys();
                int discountId = 0;
                if (rs.next()) {
                    discountId = rs.getInt(1);
                }

                if (productId != null && productId > 0) {
                    String sqlProductDiscount = "INSERT INTO tblProductDiscount (tblDiscountId, tblProductId) VALUES (?, ?)";
                    PreparedStatement pstmtProductDiscount = con.prepareStatement(sqlProductDiscount);
                    pstmtProductDiscount.setInt(1, discountId);
                    pstmtProductDiscount.setInt(2, productId);
                    pstmtProductDiscount.executeUpdate();
                }
                
                else {
                    String sqlReceiptDiscount = "INSERT INTO tblReceiptDiscount (tblDiscountId) VALUES (?)";
                    PreparedStatement pstmtReceiptDiscount = con.prepareStatement(sqlReceiptDiscount);
                    pstmtReceiptDiscount.setInt(1, discountId);
                    pstmtReceiptDiscount.executeUpdate();
                }
                
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

    public Pair<Discount, Integer> searchDiscount(String discountCode, int providerId) throws Exception {
        String sql = "SELECT * FROM tblDiscount WHERE discountCode = ? AND tblProviderId = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, discountCode);
        pstmt.setInt(2, providerId);
        ResultSet rs = pstmt.executeQuery();
        
        if (rs.next()) {
            int discountId = rs.getInt("id");
            
            Discount discount = new Discount();
            discount.setId(discountId);
            discount.setDiscountCode(rs.getString("discountCode"));
            discount.setAmount(rs.getInt("amount"));
            
            String sqlProductDiscount = "SELECT tblProductId FROM tblProductDiscount WHERE tblDiscountId = ?";
            PreparedStatement pstmtProduct = con.prepareStatement(sqlProductDiscount);
            pstmtProduct.setInt(1, discountId);
            ResultSet rsProduct = pstmtProduct.executeQuery();
            
            int productId = 0;
            if (rsProduct.next()) {
                productId = rsProduct.getInt("tblProductId");
            }
            
            return new Pair<>(discount, productId);
        }
        
        return new Pair<>(null, 0);
    }
}