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
            con.setAutoCommit(false);
            
            int productId = -1;
            
            String sqlCheckProduct = "SELECT id FROM tblProduct WHERE name = ? AND size = ? AND color = ?";
            PreparedStatement pstmtCheckProduct = con.prepareStatement(sqlCheckProduct);
            pstmtCheckProduct.setString(1, providerProduct.getProduct().getName());
            pstmtCheckProduct.setString(2, providerProduct.getProduct().getSize());
            pstmtCheckProduct.setString(3, providerProduct.getProduct().getColor());
            ResultSet rsProduct = pstmtCheckProduct.executeQuery();
            
            if (rsProduct.next()) {
                productId = rsProduct.getInt("id");
            }
            
            else {
                String sqlInsertProduct = "INSERT INTO tblProduct (name, size, color) VALUES (?, ?, ?)";
                PreparedStatement pstmtInsertProduct = con.prepareStatement(sqlInsertProduct, Statement.RETURN_GENERATED_KEYS);
                pstmtInsertProduct.setString(1, providerProduct.getProduct().getName());
                pstmtInsertProduct.setString(2, providerProduct.getProduct().getSize());
                pstmtInsertProduct.setString(3, providerProduct.getProduct().getColor());
                pstmtInsertProduct.executeUpdate();
                
                ResultSet rsInserted = pstmtInsertProduct.getGeneratedKeys();
                if (rsInserted.next()) {
                    productId = rsInserted.getInt(1);
                }
                
                else {
                    con.rollback();
                    con.setAutoCommit(true);
                    return false;
                }
            }
            
            String sqlCheckProviderProduct = "SELECT id FROM tblProviderProduct WHERE tblProductId = ? AND tblProviderId = ?";
            PreparedStatement pstmtCheckProviderProduct = con.prepareStatement(sqlCheckProviderProduct);
            pstmtCheckProviderProduct.setInt(1, productId);
            pstmtCheckProviderProduct.setInt(2, providerProduct.getProvider().getId());
            ResultSet rsProviderProduct = pstmtCheckProviderProduct.executeQuery();
            
            if (rsProviderProduct.next()) {
                con.rollback();
                con.setAutoCommit(true);
                return false;
            }
            
            String sqlInsertProviderProduct = "INSERT INTO tblProviderProduct (tblProductId, tblProviderId, unitPrice) VALUES (?, ?, ?)";
            PreparedStatement pstmtInsertProviderProduct = con.prepareStatement(sqlInsertProviderProduct);
            pstmtInsertProviderProduct.setInt(1, productId);
            pstmtInsertProviderProduct.setInt(2, providerProduct.getProvider().getId());
            pstmtInsertProviderProduct.setInt(3, providerProduct.getUnitPrice());
            pstmtInsertProviderProduct.executeUpdate();
            
            con.commit();
            con.setAutoCommit(true);
            return true;
            
        }
        
        catch (Exception e) {
            con.rollback();
            con.setAutoCommit(true);
            throw e;
        }
    }
}