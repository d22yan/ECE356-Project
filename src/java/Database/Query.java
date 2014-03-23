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
        return
            "SELECT " + 
                "* " + 
            "FROM " + 
                "user_account " + 
            "WHERE " +
                "username = '" + username + "' AND " +
                "password = '" + password + "';";
    }
    
    public static String DefaultPatientList() {
        return
            "SELECT  " +
                "patient.patient_id,  " +
                "patient.patient_name,  " +
                "doctor.doctor_name, " +
                    "patient_record_last_visit_date.last_visit_date " +
            "FROM  " +
                "doctor,  " +
                "patient  " +
            "LEFT JOIN " +
                    "(	SELECT " +
                                    "patient_record.patient_id, " +
                                    "max(patient_record.visit_start_time) AS last_visit_date " +
                            "FROM " +
                                    "patient_record " +
                            "GROUP BY " +
                                    "patient_record.patient_id " +
                    ") AS patient_record_last_visit_date " +
            "ON " +
                    "patient_record_last_visit_date.patient_id = patient.patient_id " +
            "WHERE  " +
                "patient.default_doctor_id = doctor.doctor_id; ";
    }
    
    public static String DoctorPatientList(int doctorId) {
        return
            "SELECT  "+
                "patient.patient_id,  "+
                "patient.patient_name,  "+
                "doctor.doctor_name, "+
                    "patient_record_last_visit_date.last_visit_date, "+
                "assigned_patient.doctor_id  "+
            "FROM  "+
                "doctor,  "+
                "patient  "+
            "LEFT JOIN  "+
                "assigned_patient  "+
            "ON  "+
                "patient.patient_id = assigned_patient.patient_id AND  "+
                "assigned_patient.doctor_id = " + doctorId + " " +
            "LEFT JOIN "+
                    "(	SELECT "+
                                    "patient_record.patient_id, "+
                                    "max(patient_record.visit_start_time) AS last_visit_date "+
                            "FROM "+
                                    "patient_record "+
                            "GROUP BY "+
                                    "patient_record.patient_id "+
                    ") AS patient_record_last_visit_date "+
            "ON "+
                    "patient_record_last_visit_date.patient_id = patient.patient_id "+
            "WHERE  "+
                "patient.default_doctor_id = doctor.doctor_id; ";
    }
    
    public static String StaffPatientList(int staffId) {
        return
            "SELECT  " +
                "patient.patient_id,  " +
                "patient.patient_name,  " +
                "doctor.doctor_name, " +
                "patient_record_last_visit_date.last_visit_date, " +
                "assigned_staff_to_assigned_patient.staff_id " +
            "FROM  " +
                "doctor,  " +
                "patient  " +
            "LEFT JOIN  " +
                "(	SELECT " +
                                    "assigned_patient.patient_id, " +
                                    "assigned_patient.doctor_id, " +
                                    "assigned_staff.staff_id " +
                            "FROM " +
                                    "assigned_staff, " +
                                    "doctor, " +
                                    "assigned_patient " +
                            "WHERE " +
                                    "assigned_patient.doctor_id = doctor.doctor_id AND " +
                                    "doctor.doctor_id = assigned_staff.doctor_id AND " +
                                    "assigned_staff.staff_id = " + staffId + " " +
                    ") as assigned_staff_to_assigned_patient " +
            "ON  " +
                "patient.patient_id = assigned_staff_to_assigned_patient.patient_id " +
            "LEFT JOIN " +
                    "(	SELECT " +
                                "patient_record.patient_id, " +
                                "max(patient_record.visit_start_time) AS last_visit_date " +
                        "FROM " +
                                "patient_record " +
                        "GROUP BY " +
                                "patient_record.patient_id " +
                    ") AS patient_record_last_visit_date " +
            "ON " +
                    "patient_record_last_visit_date.patient_id = patient.patient_id " +
            "WHERE  " +
                "patient.default_doctor_id = doctor.doctor_id; ";
    }
}
