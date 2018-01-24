package cn.edu.jit.entry;

import java.util.Date;

public class Login {
    private String tel;

    private String password;

    private Integer hasThird;

    private String thirdId;

    private String thirdType;

    private Integer roleId;

    private Date createDate;

    private Date modifiedDate;

    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel == null ? null : tel.trim();
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password == null ? null : password.trim();
    }

    public Integer getHasThird() {
        return hasThird;
    }

    public void setHasThird(Integer hasThird) {
        this.hasThird = hasThird;
    }

    public String getThirdId() {
        return thirdId;
    }

    public void setThirdId(String thirdId) {
        this.thirdId = thirdId == null ? null : thirdId.trim();
    }

    public String getThirdType() {
        return thirdType;
    }

    public void setThirdType(String thirdType) {
        this.thirdType = thirdType == null ? null : thirdType.trim();
    }

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Date getModifiedDate() {
        return modifiedDate;
    }

    public void setModifiedDate(Date modifiedDate) {
        this.modifiedDate = modifiedDate;
    }
}