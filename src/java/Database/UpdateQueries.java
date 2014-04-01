/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Database;

import Model.User;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author sanghoonlee
 */


public class UpdateQueries {
    //list of table names
    public static final String PATIENT_TABLE_NAME       = "patient";
    public static final String USER_ACCOUNT_TABLE_NAME  = "user_account";
    public static final String DOCTOR_TABLE_NAME        = "doctor";
    public static final String STAFF_TABLE_NAME         = "staff";
    
    //list of different types for patient
    public static final int PATIENT_UPDATE_NAME         = 1;
    public static final int PATIENT_UPDATE_ADDRESS      = 2;
    public static final int PATIENT_UPDATE_PHONENUMB    = 3;
    public static final int PATIENT_UPDATE_HEALTHCARD   = 4;
    public static final int PATIENT_UPDATE_SINCARD      = 5;
    public static final int PATIENT_UPDATE_HEALTHSTATUS = 6;
    
    //list of different types for user_account
    public static final int USER_ACCOUNT_USERNAME       = 1;
    public static final int USER_ACCOUNT_PASSWORD       = 2;
    
    //list of different types for doctor
    public static final int DOCTOR_UPDATE_NAME       = 1;
    
    //list of different types for staff
    public static final int STAFF_UPDATE_NAME       = 1;
    
    public static PreparedStatement getPreparedStatement(HttpServletRequest request, String tableName, int type, int ID) throws ClassNotFoundException, SQLException {
        String queryStatement = null;
        switch(tableName) {
            case PATIENT_TABLE_NAME:
                queryStatement=getPatientUpdateStatement(type);
                break;
            case USER_ACCOUNT_TABLE_NAME:
                queryStatement=getUserAccountUpdateStatement(type,request,ID);
                break;  
            case DOCTOR_TABLE_NAME:
                queryStatement=getDoctorAccountUpdateStatement(type);
                break; 
            case STAFF_TABLE_NAME:
                queryStatement=getStaffAccountUpdateStatement(type);
                break; 
            default:
                break;
        }
        return queryStatement!=null? Manager.getConnection().prepareStatement(queryStatement) : null; 
    }
    
    public static String getPatientUpdateStatement(int type) {
        String updateStatement = "UPDATE " + PATIENT_TABLE_NAME + " SET ";
        switch(type) {
            case PATIENT_UPDATE_NAME:
                updateStatement+="patient_name= ?";
                break;
            case PATIENT_UPDATE_ADDRESS:
                updateStatement+="address= ?";
                break; 
            case PATIENT_UPDATE_PHONENUMB:
                updateStatement+="phone_number= ?";
                break;
            case PATIENT_UPDATE_HEALTHCARD:
                updateStatement+="health_card= ?";
                break;  
            case PATIENT_UPDATE_SINCARD:
                updateStatement+="social_insurance_number= ?";
                break; 
            case PATIENT_UPDATE_HEALTHSTATUS:
                updateStatement+="current_health= ?";
                break; 
            default:
                updateStatement = null;
                break;
       }
        return updateStatement!=null? updateStatement + " WHERE patient_id=?;" : null;
    }
    
    public static String getUserAccountUpdateStatement(int type, HttpServletRequest request,int ID) {
        String updateStatement  = "UPDATE " + USER_ACCOUNT_TABLE_NAME + " SET ";
        User    user            = (User) request.getSession().getAttribute("user");
        switch(type) {
            case USER_ACCOUNT_USERNAME:
                updateStatement+="username= ?";
                break;
            case USER_ACCOUNT_PASSWORD:
                updateStatement+="password= ?";
                break; 
            default:
                updateStatement = null;
                break;
        }
        
        String groupName = ID>0? "patient" :user.getGroupName();
        return updateStatement!=null? updateStatement + " WHERE role_id=? and group_name='"+groupName+"';" : null;
    }
    
    public static String getDoctorAccountUpdateStatement(int type) {
        String updateStatement = "UPDATE " + DOCTOR_TABLE_NAME + " SET ";
        switch(type) {
            case DOCTOR_UPDATE_NAME:
                updateStatement+="doctor_name= ?";
                break;
            default:
                updateStatement = null;
                break;
       }
        return updateStatement!=null? updateStatement + " WHERE doctor_id=?;" : null;
    }
    
    public static String getStaffAccountUpdateStatement(int type) {
        String updateStatement = "UPDATE " + STAFF_TABLE_NAME + " SET ";
        switch(type) {
            case STAFF_UPDATE_NAME:
                updateStatement+="staff_name= ?";
                break;
            default:
                updateStatement = null;
                break;
       }
        return updateStatement!=null? updateStatement + " WHERE staff_id=?;" : null;
    }
    
}
