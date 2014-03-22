/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Database;
import Model.User;
import java.sql.*;
/**
 *
 * @author root
 */
public class Manager {
    public static void testConnection()
            throws ClassNotFoundException, SQLException {
        Connection con = null;
        try {
            con = getConnection();
        } finally {
            if (con != null) {
                con.close();
            }
        }
    }
    
    public static Connection getConnection() 
        throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.jdbc.Driver");
        Connection connection = DriverManager.getConnection(ServiceConstant.url, ServiceConstant.user, ServiceConstant.pwd);
        Statement stmt = null;
        try {
            connection.createStatement();
            stmt = connection.createStatement();
            stmt.execute("USE " + ServiceConstant.database);
        } finally {
            if (stmt != null) {
                stmt.close();
            }
        }
        return connection;
    }
    
     public static User getLogin(String username, String password)
            throws ClassNotFoundException, SQLException {
        Connection conection = null;
        Statement statement = null;
        try {
            conection = getConnection();
            statement = conection.createStatement();
            ResultSet userSet = statement.executeQuery(Database.Query.Login(username, password));
            
            if (!userSet.first()) {
                throw new ClassNotFoundException();
            }

            return new User(
                    userSet.getString("username"),
                    userSet.getString("password"),
                    userSet.getString("group_name"),
                    userSet.getInt("role_id")
            );
        } finally {
            if (statement != null) {
                statement.close();
            }
            if (conection != null) {
                conection.close();
            }
        }
    }
}
