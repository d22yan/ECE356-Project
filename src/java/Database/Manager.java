/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Database;
import Model.User;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
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
     
    public static void addPatientRecord(int doctorId, int patientId, String visitStartTime, String visitEndTime, String diagnosis, String prescription, String treatmentSchedule, String freeform)
            throws ClassNotFoundException, SQLException {
        Connection conection = null;
        Statement statement = null;
        try {
            conection = getConnection();
            statement = conection.createStatement();
            statement.executeUpdate(
                Database.Query.AddPatientRecord(
                    doctorId, 
                    patientId, 
                    visitStartTime, 
                    visitEndTime, 
                    diagnosis, 
                    prescription, 
                    treatmentSchedule, 
                    freeform
                )
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

    public static int selectLastPatientRecordId() {
        Connection conection = null;
        Statement statement = null;
        try {
            conection = getConnection();
            statement = conection.createStatement();
            ResultSet patientRecordSet = statement.executeQuery("SELECT * FROM patient_record ORDER BY patient_record_id DESC LIMIT 1");
            if (!patientRecordSet.first()) {
                throw new ClassNotFoundException();
            }
            return patientRecordSet.getInt("patient_record_id");
        } catch (SQLException | ClassNotFoundException ex) {
            Logger.getLogger(Manager.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (statement != null) {
                try {
                    statement.close();
                } catch (SQLException ex) {
                    Logger.getLogger(Manager.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            if (conection != null) {
                try {
                    conection.close();
                } catch (SQLException ex) {
                    Logger.getLogger(Manager.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        return 0;
    }
}
