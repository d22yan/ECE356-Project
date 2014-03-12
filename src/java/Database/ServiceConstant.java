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
public class ServiceConstant {
    public static final String url = "jdbc:mysql://eceweb.uwaterloo.ca:3306/";
    public static final String user = "user_d22yan";
    public static final String pwd = "d22yan_user";
    public static final String database = "ece356db_d22yan";
    
    public static enum Group {
        LEGAL,
        FINANCE,
        DOCTOR,
        STAFF,
        PATIENT
    }
}
