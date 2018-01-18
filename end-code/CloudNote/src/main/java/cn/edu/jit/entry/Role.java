package cn.edu.jit.entry;

import java.io.Serializable;
import java.util.Date;

/**
 * 权限实体类
 * @author jitwxs
 */
public class Role implements Serializable {
    private Integer id;

    private String name;

    private Date createTime;

    private Date modifiedTime;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getModifiedTime() {
        return modifiedTime;
    }

    public void setModifiedTime(Date modifiedTime) {
        this.modifiedTime = modifiedTime;
    }
}