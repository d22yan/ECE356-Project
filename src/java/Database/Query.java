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

    public static String CreateUser(String username, String password, String groupName, int roleId) {
        return 
            "INSERT INTO " +
                "user_account " +
            "VALUES( " +
                "'" + username + "', " +
                "'" + password + "', " +
                "'" + groupName + "', " +
                roleId + " " +
            "); ";
    }

    public static String CreateRole(String groupName, String name) {
        return
            "INSERT INTO " +
                groupName + "( " +
                    groupName + "_name " +
                ") " +
            "VALUES ( " +
                "'" + name + "' " +
            "); ";
    }
    
    public static String FindUser(String username) {
        return
            "SELECT " +
                    "* " +
            "FROM " +
                    "user_account " +
            "WHERE " +
                    "user_account.username = '" + username + "'; ";
    }
    
    public static String FindRealName(String groupName, int roleId) {
        return
            "SELECT " +
                    groupName + "_name " +
            "FROM " +
                    groupName + " " +
            "WHERE " +
                    groupName + "." + groupName + "_id = '" + roleId + "'; ";        
    }

    public static String getMaxRoleId(String groupName) {
        return
            "SELECT " +
                "MAX(" + groupName + "_id) as max_role_id " +
            "FROM " +
                groupName + "; ";
    }

    public static String AddPatientRecord(int doctorId, int patientId, String visitStartTime, String visitEndTime, String diagnosis, String prescription, String treatmentSchedule, String freeform) {
        return 
            "INSERT INTO "+
                "patient_record ( "+
                    "doctor_id, "+
                    "patient_id, "+
                    "visit_start_time, "+
                    "visit_end_time, "+
                    "diagnosis, "+
                    "prescription, "+
                    "treatment_schedule, "+
                    "freeform "+
                ")  "+
            "VALUES ( "+
                "'" + doctorId + "', "+
                "'" + patientId + "', "+
                "'" + visitStartTime + "', "+
                "'" + visitEndTime + "', "+
                "'" + diagnosis + "', "+
                "'" + prescription + "', "+
                "'" + treatmentSchedule + "', "+
                "'" + freeform +  "' "+
            "); ";
    }
    
    public static String DefaultPatientList() {
        return
            "SELECT  " +
                "patient.patient_id,  " +
                "patient.patient_name,  " +
                "doctor.doctor_name, " +
                "patient_record_last_visit_date.last_visit_date " + 
            "FROM  " +
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
            "LEFT JOIN " +
                "doctor " +
            "ON " +
                "patient.default_doctor_id = doctor.doctor_id " +
            "ORDER BY " +
                "patient.patient_name; ";
    }
    
    public static String DoctorPatientList(int doctorId) {
        return
            "SELECT  "+
                "patient.patient_id,  "+
                "patient.patient_name,  "+
                "doctor.doctor_name, "+
                "patient_record_last_visit_date.last_visit_date, " + 
                "assigned_patient.doctor_id  "+
            "FROM  "+
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
            "LEFT JOIN " +
                "doctor " +
            "ON " +
                "patient.default_doctor_id = doctor.doctor_id " +
            "ORDER BY " +
                "patient.patient_name; ";
    }
    
    public static String StaffPatientList(int staffId) {
        return
            "SELECT   " +
                "patient.patient_id,   " +
                "patient.patient_name,   " +
                "doctor.doctor_name,  " +
                "patient_record_last_visit_date.last_visit_date, " + 
                "assigned_staff_to_assigned_patient.staff_id  " +
            "FROM    " +
                "patient   " +
            "LEFT JOIN   " +
                "(  SELECT  " +
                                    "assigned_patient.patient_id,  " +
                                    "assigned_patient.doctor_id,  " +
                                    "assigned_staff.staff_id  " +
                            "FROM  " +
                                    "assigned_staff,  " +
                                    "doctor,  " +
                                    "assigned_patient  " +
                            "WHERE  " +
                                    "assigned_patient.doctor_id = doctor.doctor_id AND  " +
                                    "doctor.doctor_id = assigned_staff.doctor_id AND  " +
                                    "assigned_staff.staff_id = " + staffId + " " +
                    ") as assigned_staff_to_assigned_patient  " +
            "ON   " +
                "patient.patient_id = assigned_staff_to_assigned_patient.patient_id  " +
            "LEFT JOIN  " +
                    "(  SELECT  " +
                                "patient_record.patient_id,  " +
                                "max(patient_record.visit_start_time) AS last_visit_date  " +
                        "FROM  " +
                                "patient_record  " +
                        "GROUP BY  " +
                                "patient_record.patient_id  " +
                    ") AS patient_record_last_visit_date  " +
            "ON  " +
                    "patient_record_last_visit_date.patient_id = patient.patient_id  " +
            "LEFT JOIN " +
                "doctor " +
            "ON " +
                "patient.default_doctor_id = doctor.doctor_id " +
            "ORDER BY " +
                "patient.patient_name; ";
    }
    
    public static String patientAppointmentList(int patientId) {
        return
            "SELECT " +
                "appointment.appointment_id, " +
                "appointment.doctor_id, " +
                "appointment.patient_id, " +
                "appointment.appointment_start_time, " +
                "appointment.appointment_end_time, " +
                "test.patient_name, " +
                "test2.doctor_name " +
            "FROM " +
                "ece356db_d22yan.appointment " +
            "RIGHT JOIN " + 
                "( SELECT " +
                    "* " +
                "FROM " +
                    "ece356db_d22yan.patient " +
                "WHERE " +
                    "patient.patient_id = " + patientId + ") " +
            "AS " + 
                "test " + 
            "ON " +
                "appointment.patient_id = test.patient_id " +
            "LEFT JOIN " +
                "( SELECT " +
                    "* " +
                "FROM " +
                    "ece356db_d22yan.doctor ) " +
            "AS " +
                "test2 " +
            "ON " +
                "appointment.doctor_id = test2.doctor_id ";          
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
            "JOIN " +
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
    
    public static String staffDoctorList(int staffId)
    {
        return
            "SELECT " +
                "doctor.doctor_id, " +
                "doctor.doctor_name " +
            "FROM " +
                "ece356db_d22yan.doctor " +
            "RIGHT JOIN " +
            "(SELECT " +
                "* " +
            "FROM " +
                "ece356db_d22yan.assigned_staff " +
            "WHERE " +
                "assigned_staff.staff_id = " + staffId + ") " +
            "AS " +
                "test " +
            "ON " +
                "doctor.doctor_id = test.doctor_id;";
    }
    
    public static String doctorList()
    {
        return
            "SELECT " +
                "doctor.doctor_id, " +
                "doctor.doctor_name " +
            "FROM " +
                "ece356db_d22yan.doctor ";
    }

    public static String PatientRecordByDoctor(int doctorId) {
        return 
            "SELECT " +
                "patient.patient_name, " +
                "doctor.doctor_name, " +
                "patient_record.patient_record_id, " +
                "patient_record.doctor_id, " +
                "patient_record.patient_id, " +
                "date_format(date(patient_record.visit_start_time), '%m/%d/%Y') as patient_record_date, " +
                "patient_record.visit_start_time," +
                "patient_record.visit_end_time," +
                "patient_record.diagnosis, " +
                "patient_record.prescription, " +
                "patient_record.treatment_schedule, " +
                "patient_record.freeform " +
            "FROM  " +
                "doctor, " +
                "patient, " +
                "patient_record  " +
            "WHERE  " +
                "doctor.doctor_id = patient_record.doctor_id AND " +
                "patient.patient_id = patient_record.patient_id AND " +
                "patient_record.doctor_id = " + doctorId + "; ";
    }

    public static String AdminPatientRecord() {
        return 
            "SELECT " +
                "patient.patient_name, " +
                "doctor.doctor_name, " +
                "patient_record.patient_record_id, " +
                "patient_record.doctor_id, " +
                "patient_record.patient_id, " +
                "date_format(date(patient_record.visit_start_time), '%m/%d/%Y') as patient_record_date, " +
                "patient_record.visit_start_time," +
                "patient_record.visit_end_time," +
                "patient_record.diagnosis, " +
                "patient_record.prescription, " +
                "patient_record.treatment_schedule, " +
                "patient_record.freeform " +
            "FROM  " +
                "doctor, " +
                "patient, " +
                "patient_record  " +
            "WHERE  " +
                "doctor.doctor_id = patient_record.doctor_id AND " +
                "patient.patient_id = patient_record.patient_id; ";
    }

    public static String DoctorPatientRecord(int doctorId, int patientId) {
        return
            "SELECT " +
                    "patient.patient_name, " +
                    "doctor.doctor_name, " +
                    "patient_record.patient_record_id, " +
                    "patient_record.doctor_id, " +
                    "patient_record.patient_id, " +
                    "date_format(date(patient_record.visit_start_time), '%m/%d/%Y') as patient_record_date, " +
                    "patient_record.visit_start_time," +
                    "patient_record.visit_end_time," +
                    "patient_record.diagnosis, " +
                    "patient_record.prescription, " +
                    "patient_record.treatment_schedule, " +
                    "patient_record.freeform " +
            "FROM " +
                    "doctor, " +
                    "patient, " +
                    "patient_record " +
            "WHERE " +
                    "doctor.doctor_id = patient_record.doctor_id AND " +
                    "patient.patient_id = patient_record.patient_id AND " +
                    "patient_record.patient_id = " + patientId + " AND " +
                    "patient_record.doctor_id = " + doctorId + " " +
            "UNION " +
            "SELECT " +
                    "patient.patient_name, " +
                    "doctor.doctor_name, " +
                    "patient_record.patient_record_id, " +
                    "patient_record.doctor_id, " +
                    "patient_record.patient_id, " +
                    "date_format(date(patient_record.visit_start_time), '%m/%d/%Y') as patient_record_date, " +
                    "patient_record.visit_start_time," +
                    "patient_record.visit_end_time," +
                    "patient_record.diagnosis, " +
                    "patient_record.prescription, " +
                    "patient_record.treatment_schedule, " +
                    "patient_record.freeform " +
            "FROM " +
                    "doctor, " +
                    "patient, " +
                    "grant_permission, " +
                    "patient_record " +
            "WHERE " +
                    "doctor.doctor_id = patient_record.doctor_id AND " +
                    "patient.patient_id = patient_record.patient_id AND " +
                    "patient_record.doctor_id = grant_permission.granter_doctor_id AND " +
                    "grant_permission.patient_id = patient_record.patient_id AND " +
                    "grant_permission.grantee_doctor_id = " + doctorId + " AND " +
                    "patient.patient_id = " + patientId + " ;";
    }

    public static String StaffPatientRecord(int staffId, int patientId) {
        return
            "SELECT  " +
                "patient.patient_name,  " +
                "doctor.doctor_name,  " +
                "patient_record.patient_record_id,  " +
                "patient_record.doctor_id,  " +
                "patient_record.patient_id,  " +
                "date_format(date(patient_record.visit_start_time), '%m/%d/%Y') as patient_record_date,  " +
                "patient_record.visit_start_time, " +
                "patient_record.visit_end_time, " +
                "patient_record.diagnosis,  " +
                "patient_record.prescription,  " +
                "patient_record.treatment_schedule,  " +
                "patient_record.freeform  " +
            "FROM  " +
                "doctor,  " +
                "patient,  " +
                "patient_record, " +
                "staff, " +
                "assigned_staff " +
            "WHERE  " +
                "doctor.doctor_id = patient_record.doctor_id AND  " +
                "patient.patient_id = patient_record.patient_id AND  " +
                "patient_record.patient_id = " + patientId + " AND  " +
                "patient_record.doctor_id = assigned_staff.doctor_id AND " +
                "assigned_staff.staff_id = staff.staff_id AND  " +
                "staff.staff_id = " + staffId + " ;";
    }

    public static String PatientRecord(int patientId) {
        return
            "SELECT  " +
                "patient.patient_name,  " +
                "doctor.doctor_name,  " +
                "patient_record.patient_record_id,  " +
                "patient_record.doctor_id,  " +
                "patient_record.patient_id,  " +
                "date_format(date(patient_record.visit_start_time), '%m/%d/%Y') as patient_record_date,  " +
                "patient_record.visit_start_time, " +
                "patient_record.visit_end_time, " +
                "patient_record.diagnosis,  " +
                "patient_record.prescription,  " +
                "patient_record.treatment_schedule,  " +
                "patient_record.freeform  " +
            "FROM  " +
                "doctor,  " +
                "patient,  " +
                "patient_record " +
            "WHERE  " +
                "doctor.doctor_id = patient_record.doctor_id AND  " +
                "patient.patient_id = patient_record.patient_id AND  " +
                "patient_record.patient_id = " + patientId + "; ";
    }
    
    public static String modifyAppointment(int appointmentId, int doctorId, int patientId, String startDate, String endDate)
    {
        return
            "UPDATE " +
                "ece356db_d22yan.appointment " +
            "SET " +
                "doctor_id = " + doctorId + ", " +
                "patient_id = " + patientId + ", " +
                "appointment_start_time = \"" + startDate + "\", " +
                "appointment_end_time = \"" + endDate + "\" " +
            "WHERE " +
                "appointment.appointment_id = " + appointmentId + ";";
    }
    
    public static String createAppointment(int appointmentId, int doctorId, int patientId, String startDate, String endDate)
    {
        return
            "INSERT INTO " +
                "ece356db_d22yan.appointment " +
            "VALUES (" +
                appointmentId + ", " +
                doctorId + ", " +
                patientId + ", " +
                "\"" + startDate + "\", " +
                "\"" + endDate + "\");";
    }

    public static String HistoryTable(String historyTable) {
        return 
            "SELECT " +
                "* " +
            "FROM " +
                historyTable + " ; ";
    }

    public static String HistoryTableColumn(String historyTable) {
        return
            "SHOW " +
                "COLUMNS " +
            "FROM " +
                historyTable + " ; ";
    }

    public static String DoctorAssignedStaff(int doctorId) {
        return
            "SELECT " +
                "staff.staff_id, " +
                "staff.staff_name, " +
                "assigned_staff.doctor_id " +
            "FROM  " +
                "staff " +
            "LEFT JOIN " +
                "assigned_staff  " +
            "ON  " +
                "staff.staff_id = assigned_staff.staff_id AND " +
                "assigned_staff.doctor_id = " + doctorId + "; ";
    }

    public static String DoctorAssignedPatient(int doctorId) {
        return
            "SELECT  " +
                "patient.patient_id, " +
                "patient.patient_name, " +
                "assigned_patient.doctor_id " +
            "FROM " +
                "patient " +
            "LEFT JOIN  " +
                "assigned_patient " +
            "ON " +
                "patient.patient_id = assigned_patient.patient_id AND " +
                "assigned_patient.doctor_id = " + doctorId + "; ";
    }

    public static String DoctorGrantedStaff(int doctorId) {
        return
            "SELECT    " +
                "staff.staff_id, " +
                "staff.staff_name, " +
                "assigned_staff.view_patient_permission " +
            "FROM   " +
                "assigned_staff, " +
                "staff   " +
            "WHERE  " +
                "staff.staff_id = assigned_staff.staff_id AND " +
                "assigned_staff.doctor_id = " + doctorId + "; ";
    }

}

