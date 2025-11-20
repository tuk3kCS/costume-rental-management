package dao;

import model.Product;
import model.ProviderProduct;
import model.Provider;
import java.sql.*;
import java.util.*;

public class ProductDAO extends DAO {
    public ProductDAO(){
        super();
    }

    public List<ProviderProduct> getProductList(int providerId) throws Exception {
        List<ProviderProduct> productList = new ArrayList<>();
        String sql = "SELECT pp.id as ppId, pp.unitPrice, p.id as productId, p.name, p.size, p.color, " +
                     "pr.id as tblProviderId, pr.name as providerName " +
                     "FROM tblProviderProduct pp " +
                     "INNER JOIN tblProduct p ON pp.tblProductId = p.id " +
                     "INNER JOIN tblProvider pr ON pp.tblProviderId = pr.id " +
                     "WHERE pp.tblProviderId = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, providerId);
        ResultSet rs = pstmt.executeQuery();
        
        while (rs.next()) {
            ProviderProduct providerProduct = new ProviderProduct();
            providerProduct.setId(rs.getInt("ppId"));
            providerProduct.setUnitPrice(rs.getInt("unitPrice"));
            
            Product product = new Product();
            product.setId(rs.getInt("productId"));
            product.setName(rs.getString("name"));
            product.setSize(rs.getString("size"));
            product.setColor(rs.getString("color"));
            providerProduct.setProduct(product);
            
            Provider provider = new Provider();
            provider.setId(rs.getInt("tblProviderId"));
            provider.setName(rs.getString("providerName"));
            providerProduct.setProvider(provider);
            
            productList.add(providerProduct);
        }
        
        return productList;
    }

    public boolean saveProduct(ProviderProduct providerProduct) throws Exception {
        try {
            // Bắt đầu transaction
            con.setAutoCommit(false);
            
            // Insert vào tblProduct
            String sqlProduct = "INSERT INTO tblProduct (name, size, color) VALUES (?, ?, ?)";
            PreparedStatement pstmtProduct = con.prepareStatement(sqlProduct, Statement.RETURN_GENERATED_KEYS);
            pstmtProduct.setString(1, providerProduct.getProduct().getName());
            pstmtProduct.setString(2, providerProduct.getProduct().getSize());
            pstmtProduct.setString(3, providerProduct.getProduct().getColor());
            int result = pstmtProduct.executeUpdate();
            
            if (result > 0) {
                // Lấy ID của product vừa insert
                ResultSet rs = pstmtProduct.getGeneratedKeys();
                int productId = 0;
                if (rs.next()) {
                    productId = rs.getInt(1);
                }
                
                // Insert vào tblProviderProduct
                String sqlProviderProduct = "INSERT INTO tblProviderProduct (tblProductId, tblProviderId, unitPrice) VALUES (?, ?, ?)";
                PreparedStatement pstmtProviderProduct = con.prepareStatement(sqlProviderProduct);
                pstmtProviderProduct.setInt(1, productId);
                pstmtProviderProduct.setInt(2, providerProduct.getProvider().getId());
                pstmtProviderProduct.setInt(3, providerProduct.getUnitPrice());
                pstmtProviderProduct.executeUpdate();
                
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

    public boolean checkProduct(Product product) throws Exception {
        String sql = "SELECT * FROM tblProduct WHERE name = ? AND size = ? AND color = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, product.getName());
        pstmt.setString(2, product.getSize());
        pstmt.setString(3, product.getColor());
        ResultSet rs = pstmt.executeQuery();
        return rs.next();
    }
}