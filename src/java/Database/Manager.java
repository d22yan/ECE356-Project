/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Database;
import Model.User;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
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

    public static void CreateRole(String username, String password,  String groupName, String name) 
    throws ClassNotFoundException, SQLException {
        Connection conection = null;
        Statement statement = null;
        try {
            conection = getConnection();
            statement = conection.createStatement();
            String asd = Database.Query.getMaxRoleId(groupName);
            ResultSet maxRoleIdSet = statement.executeQuery(Database.Query.getMaxRoleId(groupName));

            if (!maxRoleIdSet.first()) {
                throw new ClassNotFoundException();
            }

            int nextRoleId = maxRoleIdSet.getInt("max_role_id") + 1;
            String asd2 = Database.Query.CreateRole(groupName, name);
            statement.executeUpdate(Database.Query.CreateRole(groupName, name));
            statement.executeUpdate(Database.Query.CreateUser(username, password, groupName, nextRoleId));
        } finally {
            if (statement != null) {
                statement.close();
            }
            if (conection != null) {
                conection.close();
            }
        }
    }
     
    public static User findUser(String username)
    throws ClassNotFoundException, SQLException {
        Connection conection = null;
        Statement statement = null;
        try {
            conection = getConnection();
            statement = conection.createStatement();
            ResultSet userSet = statement.executeQuery(Database.Query.FindUser(username));
            return (!userSet.first()) ? null : new User(userSet.getString("username"), userSet.getString("password"), userSet.getString("group_name"), userSet.getInt("role_id"));
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
    
    public static void modifyAppointment(int appointmentId, int doctorId, int patId, String startDate, String endDate)
            throws ClassNotFoundException, SQLException {
        Connection conection = null;
        Statement statement = null;
        try {
            conection = getConnection();
            statement = conection.createStatement();
            statement.executeUpdate(
                Database.Query.modifyAppointment(appointmentId, doctorId, patId, startDate, endDate)
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
    
    public static boolean verifyAppointment( Date start, Date end, int doctorId, int appointmentId )
    {
        Connection conection = null;
        Statement statement = null;
        try {
            conection = getConnection();
            statement = conection.createStatement();
            ResultSet patientRecordSet = statement.executeQuery("SELECT * FROM appointment WHERE appointment.doctor_id = " + doctorId + " AND appointment.appointment_id != " + appointmentId);
            while( patientRecordSet.next() )
            {
                Date tempTestStart = start;
                Date tempTestEnd = end;
                String tempStartDateString = patientRecordSet.getString("appointment_start_time");
                String tempEndDateString = patientRecordSet.getString("appointment_end_time");
                
                SimpleDateFormat tempformatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
                Date tempStart = tempformatter.parse(tempStartDateString);
                Date tempEnd = tempformatter.parse(tempEndDateString);
                
                if ( tempStart.before(end) && tempEnd.after(start) ) 
                {
                    return false;
                }
            }
            if ( end.before(start) )
            {
                return false;
            }
            return true;
        } catch (SQLException | ClassNotFoundException ex) {
            Logger.getLogger(Manager.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ParseException ex) {
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
        return false;
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
