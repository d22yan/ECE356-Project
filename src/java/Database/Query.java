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
                    "date_format(date(patient_record_last_visit_date.last_visit_date),'%m/%d/%Y') as last_visit_date " +
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
                    "date_format(date(patient_record_last_visit_date.last_visit_date),'%m/%d/%Y') as last_visit_date, "+
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
                "date_format(date(patient_record_last_visit_date.last_visit_date),'%m/%d/%Y') as last_visit_date, " +
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
    public static String staffAppointmentList(int staffId) {
        return
            "SELECT " +
                "appointment.appointment_id, " +
                "appointment.doctor_id, " +
                "appointment.patient_id, " +
                "appointment.appointment_start_time, " +
                "appointment.appointment_end_time, " +
                "test.doctor_name, " +
                "test2.patient_name " +
            "FROM " +
                "ece356db_d22yan.appointment " +
            "LEFT JOIN " + 
                "( SELECT " +
                    "* " +
                "FROM " +
                    "ece356db_d22yan.doctor ) " +
            "AS " + 
                "test " + 
            "ON " +
                "appointment.doctor_id = test.doctor_id " +
            "LEFT JOIN " +
                "( SELECT " +
                    "* " +
                "FROM " +
                    "ece356db_d22yan.patient ) " +
            "AS " +
                "test2 " +
            "ON " +
                "appointment.patient_id = test2.patient_id " +
            "RIGHT JOIN " +
                "(SELECT " +
                    "* " +
                "FROM " +
                    "ece356db_d22yan.assigned_staff " +
                "WHERE " +
                    "assigned_staff.staff_id = " + staffId + ") " +
            "AS " +
                "test3 " +
            "ON " +
                "appointment.doctor_id = test3.doctor_id;";
    }
    public static String doctorAppointmentList(int doctorId) {
        return
            "SELECT " +
                "appointment.appointment_id, " +
                "appointment.doctor_id, " +
                "appointment.patient_id, " +
                "appointment.appointment_start_time, " +
                "appointment.appointment_end_time, " +
                "test.doctor_name, " +
                "test2.patient_name " +
            "FROM " +
                "ece356db_d22yan.appointment " +
            "RIGHT JOIN " + 
                "( SELECT " +
                    "* " +
                "FROM " +
                    "ece356db_d22yan.doctor " +
                "WHERE " +
                    "doctor.doctor_id = " + doctorId + ") " +
            "AS " + 
                "test " + 
            "ON " +
                "appointment.doctor_id = test.doctor_id " +
            "LEFT JOIN " +
                "( SELECT " +
                    "* " +
                "FROM " +
                    "ece356db_d22yan.patient ) " +
            "AS " +
                "test2 " +
            "ON " +
                "appointment.patient_id = test2.patient_id ";
    }
}
