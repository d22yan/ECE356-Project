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
            ResultSet resultSet = statement.executeQuery(
                "SELECT * " + 
                "FROM user_account " + 
                "WHERE username = '" + username + "' AND password = '" + password + "';"
            );
            String asdf = null;
            String asdf2 = null;
            int groupId = 0;
            int roleId = 0;
            if (resultSet.first()) {
                asdf = resultSet.getString("username");
                asdf2 = resultSet.getString("password");
                groupId = resultSet.getInt("group_id");
                roleId = resultSet.getInt("role_id");
            }
            return new User(
                    asdf,
                    asdf2,
                    groupId,
                    roleId
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
