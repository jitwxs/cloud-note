package cn.edu.jit.entry;

import java.io.Serializable;

/**
 * 首页支持地区实体类
 * @author jitwxs
 */
public class SupportArea implements Serializable {
    private String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }
}