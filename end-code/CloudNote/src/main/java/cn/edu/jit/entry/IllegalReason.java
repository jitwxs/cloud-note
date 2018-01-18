package cn.edu.jit.entry;

import java.io.Serializable;

/**
 * 违禁原因实体类
 * @author jitwxs
 */
public class IllegalReason implements Serializable {
    private String id;

    private String name;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }
}