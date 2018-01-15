package cn.edu.jit.entry;

import java.io.Serializable;

/**
 * 管理员用户信息
 * @author jitwxs
 * @date 2018/1/13 18:56
 */
public class UserInfo implements Serializable {

    /**
     * 日期串
     */
    private String date;

    /**
     * 当日男性注册数量
     */
    private Integer maleNum;

    /**
     * 当如女性注册数量
     */
    private Integer femaleNum;

    /**
     * 最初到当日的总注册量
     */
    private Integer tempTotal;

    public UserInfo() {
        this.maleNum = 0;
        this.femaleNum = 0;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public Integer getMaleNum() {
        return maleNum;
    }

    public void setMaleNum(Integer maleNum) {
        this.maleNum = maleNum;
    }

    public Integer getFemaleNum() {
        return femaleNum;
    }

    public void setFemaleNum(Integer femaleNum) {
        this.femaleNum = femaleNum;
    }

    public Integer getTempTotal() {
        return tempTotal;
    }

    public void setTempTotal(Integer tempTotal) {
        this.tempTotal = tempTotal;
    }
}
