package cn.edu.jit.service;

import cn.edu.jit.entry.Login;
import cn.edu.jit.entry.User;

/**
 * 用户Service
 * @author jitwxs
 * @date 2018/1/2 23:16
 */
public interface UserService {
    /**
     * 根据手机号码查询
     * @param tel 手机号码
     * @return User对象
     */
    User getByTel(String tel);

    /**
     * 保存用户信息
     * @param user User对象
     * @return 影响行数
     */
    int save(User user);
}
