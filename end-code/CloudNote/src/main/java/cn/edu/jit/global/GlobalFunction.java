package cn.edu.jit.global;

import cn.edu.jit.entry.Login;
import cn.edu.jit.entry.User;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;

import java.util.UUID;

/**
 * 全局方法
 * @author jitwxs
 * @date 2018/1/2 22:33
 */
public class GlobalFunction {

    /**
     * 获取UUID
     * @return 返回UUID
     */
    public static String getUUID() {
        String uuid = UUID.randomUUID().toString();
        return uuid.replaceAll("-", "");
    }

    public static User login2User(Login login) {
        User user = new User();
        user.setTel(login.getTel());
        user.setId(GlobalFunction.getUUID());
        user.setCreateDate(login.getCreateDate());
        return user;
    }
}
