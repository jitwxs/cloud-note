package cn.edu.jit.global;

/**
 * 全局常量
 * @author jitwxs
 * @date 2018/1/2 20:32
 */
public class GlobalConstant {
    // 权限枚举
    public static enum ROLE {
        // 管理员
        ADMIN("admin",1),
        // 普通用户
        USER("user",2);

        private String name;
        private int index;

        private ROLE(String name, int index) {
            this.name = name;
            this.index = index;
        }

        public String getName() {
            for (ROLE role : ROLE.values()) {
                if (role.getIndex() == index) {
                    return role.name;
                }
            }
            return null;
        }

        public void setName(String name) {
            this.name = name;
        }

        public int getIndex() {
            return index;
        }

        public void setIndex(int index) {
            this.index = index;
        }
    }
}
