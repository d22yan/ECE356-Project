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
public class Patient {
    private int id;
    private String name;
    private String address;
    private int phoneNumber;
    private String healthCard;
    private int socialInsuranceNumber;
    private int totalVisitCount;
    private int defaultDoctorId;
    private String currentHealth;
    
    public Patient(int id, String name, String address, int phoneNumber, String healthCard, int socialInsuranceNumber, int totalVisitCount, int defaultDoctorId, String currentHealth) {
        this.id = id;
        this.name = name;
        this.address = address;
        this.phoneNumber = phoneNumber;
        this.healthCard = healthCard;
        this.socialInsuranceNumber = socialInsuranceNumber;
        this.totalVisitCount = totalVisitCount;
        this.defaultDoctorId = defaultDoctorId;
        this.currentHealth = currentHealth;
    }
    
    public int getId() {
        return this.id;
    }

    public void setId(int value) {    
        this.id = value;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String value) {    
        this.name = value;
    }

    public String getAddress() {
        return this.address;
    }

    public void setAddress(String value) {    
        this.address = value;
    }

    public int getPhoneNumber() {
        return this.phoneNumber;
    }

    public void setPhoneNumber(int value) {    
        this.phoneNumber = value;
    }

    public String getHealthCard() {
        return this.healthCard;
    }

    public void setHealthCard(String value) {    
        this.healthCard = value;
    }

    public int getSocialInsuranceNumber() {
        return this.socialInsuranceNumber;
    }

    public void setSocialInsuranceNumber(int value) {    
        this.socialInsuranceNumber = value;
    }

    public int getTotalVisitCount() {
        return this.totalVisitCount;
    }

    public void setTotalVisitCount(int value) {    
        this.totalVisitCount = value;
    }

    public int getDefaultDoctorId() {
        return this.defaultDoctorId;
    }

    public void setDefaultDoctorId(int value) {    
        this.defaultDoctorId = value;
    }

    public String getCurrentHealth() {
        return this.currentHealth;
    }

    public void setCurrentHealth(String value) {    
        this.currentHealth = value;
    }
}
