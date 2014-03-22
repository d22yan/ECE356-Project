/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Database;

/**
 *
 * @author root
 */
public class Query {
    public static String Login(String username, String password) {
        String queryStatement = "" + 
                "SELECT " + 
                    "* " + 
                "FROM " + 
                    "user_account " + 
                "WHERE " +
                    "username = '" + username + "' AND " +
                    "password = '" + password + "';";
        return queryStatement;
    }
    
    public static String PatientList() {
        String queryStatement = "" +
            "SELECT " +
                "patient.patient_id, " +
                "patient.patient_name, " +
                "doctor.doctor_name," +
                "patient.total_visit_count," +
                "assigned_patient.doctor_id " +
            "FROM " +
                "doctor, " +
                "patient " +
            "LEFT JOIN " +
                "assigned_patient " +
            "ON " +
                "patient.patient_id = assigned_patient.patient_id " +
            "WHERE " +
                "patient.default_doctor_id = doctor.doctor_id;";
        return queryStatement;
    }
    
    public static String PatientList(int doctorId) {
        String queryStatement = "" +
            "SELECT " +
                "patient.patient_id, " +
                "patient.patient_name, " +
                "doctor.doctor_name," +
                "patient.total_visit_count," +
                "assigned_patient.doctor_id " +
            "FROM " +
                "doctor, " +
                "patient " +
            "LEFT JOIN " +
                "assigned_patient " +
            "ON " +
                "patient.patient_id = assigned_patient.patient_id AND " +
                "assigned_patient.doctor_id = " + doctorId + " " +
            "WHERE " +
                "patient.default_doctor_id = doctor.doctor_id;";
        return queryStatement;
    }
}
