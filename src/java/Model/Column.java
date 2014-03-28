/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Model;

/**
 *
 * @author Lewis
 */

public class Column {
    private String id; //sql column id used to access value from sql result
    private String value; //value used to identify select options in filter
    private String label; //actual text displayed in table header and search options
    private String type; //used to perform typed comparisons on column values for filtering
    private boolean isDefault; //used to determine which search option is initially selected
    
    public Column(String id, String value, String label, String type, boolean isDefault) {
        this.id = id;
        this.value = value;
        this.label = label;
        this.type = type;
        this.isDefault = isDefault;
    }
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
    
    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public boolean isIsDefault() {
        return isDefault;
    }

    public void setIsDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }
}
