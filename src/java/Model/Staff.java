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
public class Staff {
     private int id;
     private String name;
     
     public Staff(int id, String name) {
         this.id = id;
         this.name = name;
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
}
