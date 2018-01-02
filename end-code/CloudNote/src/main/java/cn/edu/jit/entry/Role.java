package cn.edu.jit.entry;

/**
 * 权限实体类
 * @author jitwxs
 * @date 2018/1/2 19:39
 */
public class Role {
    private Integer role;

    private String name;

    public Integer getRole() {
        return role;
    }

    public void setRole(Integer role) {
        this.role = role;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }
}