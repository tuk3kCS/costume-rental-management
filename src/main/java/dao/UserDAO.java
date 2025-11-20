package dao;

import model.User;
import java.sql.*;

public class UserDAO extends DAO {
    public UserDAO(){
        super();
    }

    public boolean checkLogin(User user) throws Exception {
        {
            String sql = "SELECT * FROM tblUser WHERE username = ? AND password = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            ResultSet rs = pstmt.executeQuery();
            return rs.next();
        }
    }
}