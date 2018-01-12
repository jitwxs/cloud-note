package cn.edu.jit.entry;

import java.io.Serializable;

/**
 * @author jitwxs
 * @date 2018/1/12 10:26
 */
public class Data implements Serializable{
    private String name;

    private String value;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}
