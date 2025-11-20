package dao;

import model.Staff;
import java.sql.*;

public class StaffDAO extends DAO {
    public StaffDAO(){
        super();
    }

    public Staff getStaffInfor(String username) throws Exception {
        {
            String sql = "SELECT * FROM tblUser WHERE username = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            return rs.next() ? new Staff(rs.getInt("id"), rs.getString("username"), rs.getString("password"), rs.getString("fullName"), rs.getString("role")) : null;
        }
    }
}