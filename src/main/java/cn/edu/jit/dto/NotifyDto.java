package cn.edu.jit.dto;

import cn.edu.jit.entry.Notify;

import java.io.Serializable;

/**
 * @author jitwxs
 * @date 2018/1/21 10:25
 */
public class NotifyDto extends Notify implements Serializable {
    /**
     * 发送者类型
     */
    private String sendUserType;

    /**
     * 发送者手机号
     */
    private String sendUser;

    /**
     * 接收者手机号
     */
    private String recvUser;

    /**
     * 状态名称
     */
    private String statusName;

    public String getSendUserType() {
        return sendUserType;
    }

    public void setSendUserType(String sendUserType) {
        this.sendUserType = sendUserType;
    }

    public String getSendUser() {
        return sendUser;
    }

    public void setSendUser(String sendUser) {
        this.sendUser = sendUser;
    }

    public String getRecvUser() {
        return recvUser;
    }

    public void setRecvUser(String recvUser) {
        this.recvUser = recvUser;
    }

    public String getStatusName() {
        return statusName;
    }

    public void setStatusName(String statusName) {
        this.statusName = statusName;
    }
}
