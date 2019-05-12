package cn.edu.jit.dto;

import cn.edu.jit.entry.UserBlacklist;

import java.io.Serializable;

/**
 * @author jitwxs
 * @date 2018/1/15 14:30
 */
public class UserBlacklistDto extends UserBlacklist implements Serializable {
    /**
     * 用户手机号码
     */
    private String tel;

    /**
     * 用户昵称
     */
    private String userName;

    /**
     * 封禁原因名称
     */
    private String illegalName;

    /**
     * 状态：失效、有效
     */
    private String status;

    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getIllegalName() {
        return illegalName;
    }

    public void setIllegalName(String illegalName) {
        this.illegalName = illegalName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
