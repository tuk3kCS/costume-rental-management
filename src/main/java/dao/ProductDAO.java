package dao;

import model.Product;
import java.sql.*;
import java.util.*;

public class ProductDAO extends DAO {
    public ProductDAO(){
        super();
    }

    public List<Product> getProductList() throws Exception {
        List<Product> productList = new ArrayList<>();
        String sql = "SELECT * FROM tblProduct";
        PreparedStatement pstmt = con.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery();
        
        while (rs.next()) {
            Product product = new Product();
            product.setId(rs.getInt("id"));
            product.setName(rs.getString("name"));
            product.setSize(rs.getString("size"));
            product.setColor(rs.getString("color"));
            productList.add(product);
        }
        
        return productList;
    }

    public boolean saveProduct(Product product) throws Exception {
        String sql = "INSERT INTO tblProduct (name, size, color) VALUES (?, ?, ?)";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, product.getName());
        pstmt.setString(2, product.getSize());
        pstmt.setString(3, product.getColor());
        int result = pstmt.executeUpdate();
        return result > 0;
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