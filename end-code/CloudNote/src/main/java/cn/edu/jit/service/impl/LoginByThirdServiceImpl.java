package cn.edu.jit.service.impl;

import cn.edu.jit.entry.LoginByThird;
import cn.edu.jit.entry.LoginByThirdExample;
import cn.edu.jit.entry.User;
import cn.edu.jit.entry.UserExample;
import cn.edu.jit.mapper.LoginByThirdMapper;
import cn.edu.jit.service.LoginByThirdService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/23 9:52
 */
@Service
public class LoginByThirdServiceImpl implements LoginByThirdService {
    @Autowired
    LoginByThirdMapper loginByThirdMapper;

    @Override
    public int save(LoginByThird loginByThird) {
        return loginByThirdMapper.insertSelective(loginByThird);
    }

    @Override
    public int removeById(String id) {
        return loginByThirdMapper.deleteByPrimaryKey(id);
    }

    @Override
    public LoginByThird getByThirdTypeAndThirdId(String thirdType, String thirdId) {
        LoginByThirdExample loginByThirdExample = new LoginByThirdExample();

        LoginByThirdExample.Criteria criteria = loginByThirdExample.createCriteria();
        criteria.andThirdTypeEqualTo(thirdType);
        criteria.andThirdIdEqualTo(thirdId);

        List<LoginByThird> list = loginByThirdMapper.selectByExample(loginByThirdExample);

        if(list.size() == 0) {
            return null;
        } else {
            return list.get(0);
        }
    }
}
