package cn.edu.jit.service;

import cn.edu.jit.entry.Login;

/**
 * 登陆Service
 * @author jitwxs
 * @date 2018/1/2 20:38
 */
public interface LoginService {

    Login getByTel(String tel);

    int save(Login login);

    int update(Login login);

    int removeByTel(String tel);

}
