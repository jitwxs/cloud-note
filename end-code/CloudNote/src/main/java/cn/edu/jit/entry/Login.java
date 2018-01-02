package cn.edu.jit.entry;

/**
 * 登陆实体类
 * @author jitwxs
 * @date 2018/1/2 19:39
 */
public class Login {
    private String tel;

    private String password;

    private Integer role;

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

    public Integer getRole() {
        return role;
    }

    public void setRole(Integer role) {
        this.role = role;
    }
}