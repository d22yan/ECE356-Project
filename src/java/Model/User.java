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
public class User {
    private String userName;
    private String password;
    private String groupName;
    private int roleId;
    
    public User(String userName, String password, String groupName, int roleId) {
        this.userName = userName;
        this.password = password;
        this.groupName = groupName;
        this.roleId = roleId;
    }
    
    public String getUserName() {
        return this.userName;
    }
    
    public void setUserName(String value) {
        this.userName = value;
    }
    
    public String getPassword() {
        return this.password;
    }
    
    public void setPassword(String value) {
        this.password = value;
    }
    
    public String getGroupName() {
        return this.groupName;
    }
    
    public void getGroupName(String value) {
        this.groupName = value;
    }
    
    public int getRoleId() {
        return this.roleId;
    }
    
    public void setRoleId(int value) {
        this.roleId = value;
    }
    
}
