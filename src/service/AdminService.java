package service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Admin;

public class AdminService {
 
    // auth method for admin
    public static boolean auth(Connection connection, Admin admin) 
        throws Exception 
    {
        String query = "SELECT COUNT(*) FROM admins WHERE email = ? AND password_hash = ?";
        
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, admin.getEmail());
            statement.setString(2, admin.getPassword());
            
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) 
                { return resultSet.getInt(1) > 0; }
            }
        } 
        
        catch (Exception e) 
        { throw e; }

        return false;
    } 
}