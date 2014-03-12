/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Model;

/**
 *
 * @author root
 */
public class Doctor {
    private int id;
    private String name;
    
    public Doctor(int id, String name) {
        this.id = id;
        this.name = name;
    }
    
    public int getDoctorId() {
        return this.id;
    }
    
    public void setDoctorId(int value) {
        id = value;
    }
    
    public String getDoctorName() {
        return this.name;
    }
    
    public void setDoctorName(String value) {
        name = value;
    }
}
