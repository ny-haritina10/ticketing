package database;

import java.sql.*;
import java.util.Properties;
import java.io.FileInputStream;
import java.io.IOException;

public class Database {

    private static final String CONFIG_FILE = "D:\\Studies\\ITU\\S5\\INF313_Framework\\ticketing\\conf\\_db.properties";
    private static Database instance;
    private Connection connection;
    
    public Database() {
        try {
            Properties props = loadProperties();

            String url = props.getProperty("db.url");
            String user = props.getProperty("db.username");
            String password = props.getProperty("db.password");
            String driver = props.getProperty("db.driver");

            Class.forName(driver);
            
            connection = DriverManager.getConnection(url, user, password);
        } catch (Exception e) {
            throw new RuntimeException("Failed to initialize database connection", e);
        }
    }
    
    private Properties loadProperties() throws IOException {
        Properties props = new Properties();
        FileInputStream input = new FileInputStream(CONFIG_FILE);
        props.load(input);
        return props;
    }
    
    public static synchronized Database getInstance() {
        if (instance == null) {
            instance = new Database();
        }
        return instance;
    }
    
    public Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                instance = new Database();
            }
            return connection;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get database connection", e);
        }
    }
}