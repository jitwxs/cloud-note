package cn.edu.jit.service;

import cn.edu.jit.entry.LoginByThird;

/**
 * @author jitwxs
 * @date 2018/1/23 9:50
 */
public interface LoginByThirdService {
    int save(LoginByThird loginByThird);

    int removeById(String id);

    LoginByThird getByThirdTypeAndThirdId(String thirdType,String thirdId);
}
