package cn.edu.jit.service;

import cn.edu.jit.entry.Login;
import cn.edu.jit.entry.User;

import java.util.List;

/**
 * 用户Service
 * @author jitwxs
 * @date 2018/1/2 23:16
 */
public interface UserService {

    User getByTel(String tel);

    User getById(String id);

    int save(User user);

    int update(User user);

    int removeByTel(String tel);

    List<User> listAllUser();
}
