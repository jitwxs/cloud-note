package cn.edu.jit.service.impl;

import cn.edu.jit.entry.Login;
import cn.edu.jit.entry.LoginExample;
import cn.edu.jit.entry.NotifyExample;
import cn.edu.jit.global.GlobalConstant;
import cn.edu.jit.util.Sha1Utils;
import cn.edu.jit.mapper.LoginMapper;
import cn.edu.jit.service.LoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/2 20:38
 */
@Service
public class LoginServiceImpl implements LoginService {

    @Autowired
    private LoginMapper loginMapper;

    @Override
    public Login getByTel(String tel) {
        return loginMapper.selectByPrimaryKey(tel);
    }

    @Override
    public Login getByThirdIdAndThirdType(String thirdId, String thirdType) {
        LoginExample loginExample = new LoginExample();

        LoginExample.Criteria criteria = loginExample.createCriteria();
        criteria.andHasThirdEqualTo(1);
        criteria.andThirdIdEqualTo(thirdId);
        criteria.andThirdTypeEqualTo(thirdType);

        List<Login> list = loginMapper.selectByExample(loginExample);
        if(list.size() == 0) {
            return null;
        } else {
            return list.get(0);
        }
    }

    @Override
    public int save(Login login){
        return loginMapper.insertSelective(login);
    }

    @Override
    public int update(Login login) {
        login.setModifiedDate(new Date());
        return loginMapper.updateByPrimaryKey(login);
    }

    @Override
    public int removeByTel(String tel) {
        return loginMapper.deleteByPrimaryKey(tel);
    }
}
