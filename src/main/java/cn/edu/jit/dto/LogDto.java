package cn.edu.jit.dto;

import cn.edu.jit.entry.Log;

import java.io.Serializable;

/**
 * @author jitwxs
 * @date 2018/1/16 21:50
 */
public class LogDto extends Log implements Serializable {
    private String userName;

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }
}
