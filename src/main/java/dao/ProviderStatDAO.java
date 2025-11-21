package dao;

import model.Provider;
import java.sql.*;
import java.util.*;

public class ProviderStatDAO extends DAO {
    
    public static class ProviderStat {
        private Provider provider;
        private int totalExpense;
        private int totalReceipts;
        
        public ProviderStat(Provider provider, int totalExpense, int totalReceipts) {
            this.provider = provider;
            this.totalExpense = totalExpense;
            this.totalReceipts = totalReceipts;
        }
        
        public Provider getProvider() {
            return provider;
        }
        
        public int getTotalExpense() {
            return totalExpense;
        }
        
        public int getTotalReceipts() {
            return totalReceipts;
        }
    }
    
    public ProviderStatDAO(){
        super();
    }

    public List<ProviderStat> getProviderStat(java.util.Date startTime, java.util.Date endTime) throws Exception {
        List<ProviderStat> statList = new ArrayList<>();
        
        String sql = "SELECT p.id, p.name, p.address, p.phoneNo, p.email, " +
                     "COUNT(DISTINCT r.id) as totalReceipts, " +
                     "(COALESCE(SUM(rp.quantity * rp.unitPrice), 0) - " +
                     "COALESCE((SELECT SUM(d.amount) FROM tblReceipt r2 " +
                     "INNER JOIN tblDiscount d ON r2.tblDiscountId = d.id " +
                     "WHERE r2.tblProviderId = p.id " +
                     "AND r2.createdDate BETWEEN ? AND ?), 0)) as totalExpense " +
                     "FROM tblProvider p " +
                     "LEFT JOIN tblReceipt r ON p.id = r.tblProviderId " +
                     "AND r.createdDate BETWEEN ? AND ? " +
                     "LEFT JOIN tblReceiptProduct rp ON r.id = rp.tblReceiptId " +
                     "GROUP BY p.id, p.name, p.address, p.phoneNo, p.email " +
                     "ORDER BY totalExpense DESC";
        
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setDate(1, new java.sql.Date(startTime.getTime()));
        pstmt.setDate(2, new java.sql.Date(endTime.getTime()));
        pstmt.setDate(3, new java.sql.Date(startTime.getTime()));
        pstmt.setDate(4, new java.sql.Date(endTime.getTime()));
        ResultSet rs = pstmt.executeQuery();
        
        while (rs.next()) {
            Provider provider = new Provider();
            provider.setId(rs.getInt("id"));
            provider.setName(rs.getString("name"));
            provider.setAddress(rs.getString("address"));
            provider.setPhoneNo(rs.getString("phoneNo"));
            provider.setEmail(rs.getString("email"));
            
            int totalExpense = rs.getInt("totalExpense");
            int totalReceipts = rs.getInt("totalReceipts");
            
            ProviderStat stat = new ProviderStat(provider, totalExpense, totalReceipts);
            statList.add(stat);
        }
        
        return statList;
    }
}