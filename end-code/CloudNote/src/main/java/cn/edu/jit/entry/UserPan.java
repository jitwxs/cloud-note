package cn.edu.jit.entry;

import java.io.Serializable;
import java.util.Date;

/**
 * 网盘实体类
 * @author jitwxs
 */
public class UserPan implements Serializable {
    private String id;

    private String userid;

    private String name;

    private String size;

    private String dirId;

    private Date createTime;

    private Date modifedTime;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    public String getUserid() {
        return userid;
    }

    public void setUserid(String userid) {
        this.userid = userid == null ? null : userid.trim();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size == null ? null : size.trim();
    }

    public String getDirId() {
        return dirId;
    }

    public void setDirId(String dirId) {
        this.dirId = dirId == null ? null : dirId.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getModifedTime() {
        return modifedTime;
    }

    public void setModifedTime(Date modifedTime) {
        this.modifedTime = modifedTime;
    }
}