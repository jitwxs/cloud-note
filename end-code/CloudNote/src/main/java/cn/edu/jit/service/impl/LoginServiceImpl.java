<<<<<<< HEAD
package cn.edu.jit.service.impl;

import cn.edu.jit.entry.Login;
import cn.edu.jit.global.GlobalConstant;
import cn.edu.jit.util.Sha1Utils;
import cn.edu.jit.mapper.LoginMapper;
import cn.edu.jit.service.LoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;

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
    public int save(Login login){
        login.setRoleId(GlobalConstant.ROLE.USER.getIndex());
        login.setCreateDate(new Date());
        login.setPassword(Sha1Utils.entryptPassword(login.getPassword()));

        return loginMapper.insertSelective(login);
    }

    @Override
    public int update(Login login) {
        login.setModifiedDate(new Date());
        return loginMapper.updateByPrimaryKey(login);
    }
}
=======
package cn.edu.jit.service.impl;

import cn.edu.jit.entry.Login;
import cn.edu.jit.global.GlobalConstant;
import cn.edu.jit.util.Sha1Utils;
import cn.edu.jit.mapper.LoginMapper;
import cn.edu.jit.service.LoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;

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
    public int save(Login login){
        login.setRoleId(GlobalConstant.ROLE.USER.getIndex());
        login.setCreateDate(new Date());
        login.setPassword(Sha1Utils.entryptPassword(login.getPassword()));

        return loginMapper.insertSelective(login);
    }

    @Override
    public int update(Login login) {
        login.setModifiedDate(new Date());
        return loginMapper.updateByPrimaryKey(login);
    }
}
>>>>>>> origin/master
