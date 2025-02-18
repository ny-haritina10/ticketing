package service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import model.Client;

public class ClientService {
    
    // auth method for client
    public static boolean auth(Connection connection, Client client) 
        throws Exception 
    {
        String query = "SELECT COUNT(*) FROM clients WHERE email = ? AND password_hash = ?";
        
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, client.getEmail());
            statement.setString(2, client.getPassword());
            
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