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
    private int groupId;
    private int roleId;
    
    public User(String userName, String password, int groupId, int roleId) {
        this.userName = userName;
        this.password = password;
        this.groupId = groupId;
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
    
    public int getGroupId() {
        return this.groupId;
    }
    
    public void getGroupId(int value) {
        this.groupId = value;
    }
    
    public int getRoleId() {
        return this.roleId;
    }
    
    public void setRoleId(int value) {
        this.roleId = value;
    }
    
}
