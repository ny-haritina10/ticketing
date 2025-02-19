package service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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


            System.out.println("email: " + client.getEmail());
            System.out.println("password: " + client.getPassword());
            
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) 
                { return resultSet.getInt(1) > 0; }
            }
        } 
        
        catch (Exception e) 
        { throw e; }

        return false;
    } 

    public static void savePassportImage(Connection connection, Client client, String path) 
        throws Exception 
    {
        String query = "UPDATE clients SET passport_image = ? WHERE id = ?";

        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, path);          
            preparedStatement.setInt(2, client.getId());  

            int rowsAffected = preparedStatement.executeUpdate();

            if (rowsAffected == 0) {
                throw new Exception("Failed to update passport image: Client with ID " + client.getId() + " not found.");
            }

            System.out.println("Passport image updated successfully for client ID: " + client.getId());
        } 
        
        catch (SQLException e) {
            throw new Exception("Error updating passport image in the database: " + e.getMessage(), e);
        }
    }
}