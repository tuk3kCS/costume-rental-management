package dao;

import model.Provider;
import java.sql.*;
import java.util.*;

public class ProviderDAO extends DAO {
    public ProviderDAO(){
        super();
    }

    public List<Provider> searchProvider(String keyword) throws Exception {
        List<Provider> providerList = new ArrayList<>();
        String sql = "SELECT * FROM tblprovider WHERE name LIKE ? OR address LIKE ? OR phoneNo LIKE ? OR email LIKE ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        String searchPattern = "%" + keyword + "%";
        pstmt.setString(1, searchPattern);
        pstmt.setString(2, searchPattern);
        pstmt.setString(3, searchPattern);
        pstmt.setString(4, searchPattern);
        ResultSet rs = pstmt.executeQuery();
        
        while (rs.next()) {
            Provider provider = new Provider();
            provider.setId(rs.getInt("id"));
            provider.setName(rs.getString("name"));
            provider.setAddress(rs.getString("address"));
            provider.setPhoneNo(rs.getString("phoneNo"));
            provider.setEmail(rs.getString("email"));
            providerList.add(provider);
        }
        
        return providerList;
    }

    public boolean saveProvider(Provider provider) throws Exception {
        String sql;
        PreparedStatement pstmt;
        
        if (provider.getId() > 0) {
            sql = "UPDATE tblprovider SET name = ?, address = ?, phoneNo = ?, email = ? WHERE id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, provider.getName());
            pstmt.setString(2, provider.getAddress());
            pstmt.setString(3, provider.getPhoneNo());
            pstmt.setString(4, provider.getEmail());
            pstmt.setInt(5, provider.getId());
        }
        
        else {
            sql = "INSERT INTO tblprovider (name, address, phoneNo, email) VALUES (?, ?, ?, ?)";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, provider.getName());
            pstmt.setString(2, provider.getAddress());
            pstmt.setString(3, provider.getPhoneNo());
            pstmt.setString(4, provider.getEmail());
        }
        
        int result = pstmt.executeUpdate();
        return result > 0;
    }

    public boolean deleteProvider(Provider provider) throws Exception {
        String sql = "DELETE FROM tblprovider WHERE id = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, provider.getId());
        int result = pstmt.executeUpdate();
        return result > 0;
    }

    public Provider getProviderById(int id) throws Exception {
        String sql = "SELECT * FROM tblprovider WHERE id = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, id);
        ResultSet rs = pstmt.executeQuery();
        
        if (rs.next()) {
            Provider provider = new Provider();
            provider.setId(rs.getInt("id"));
            provider.setName(rs.getString("name"));
            provider.setAddress(rs.getString("address"));
            provider.setPhoneNo(rs.getString("phoneNo"));
            provider.setEmail(rs.getString("email"));
            return provider;
        }
        
        return null;
    }
    
    public Provider checkProvider(Provider provider) throws Exception {
        String sql;
        PreparedStatement pstmt;
        
        if (provider.getId() > 0) {
            sql = "SELECT * FROM tblprovider WHERE (email = ? OR phoneNo = ?) AND id != ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, provider.getEmail());
            pstmt.setString(2, provider.getPhoneNo());
            pstmt.setInt(3, provider.getId());
        }
        
        else {
            sql = "SELECT * FROM tblprovider WHERE email = ? OR phoneNo = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, provider.getEmail());
            pstmt.setString(2, provider.getPhoneNo());
        }
        
        ResultSet rs = pstmt.executeQuery();
        
        if (rs.next()) {
            Provider existingProvider = new Provider();
            existingProvider.setId(rs.getInt("id"));
            existingProvider.setName(rs.getString("name"));
            existingProvider.setAddress(rs.getString("address"));
            existingProvider.setPhoneNo(rs.getString("phoneNo"));
            existingProvider.setEmail(rs.getString("email"));
            return existingProvider;
        }
        
        return null;
    }

    public List<Provider> getProviderList() throws Exception {
        List<Provider> providerList = new ArrayList<>();
        String sql = "SELECT * FROM tblprovider";
        PreparedStatement pstmt = con.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery();
        
        while (rs.next()) {
            Provider provider = new Provider();
            provider.setId(rs.getInt("id"));
            provider.setName(rs.getString("name"));
            provider.setAddress(rs.getString("address"));
            provider.setPhoneNo(rs.getString("phoneNo"));
            provider.setEmail(rs.getString("email"));
            providerList.add(provider);
        }
        
        return providerList;
    }
}