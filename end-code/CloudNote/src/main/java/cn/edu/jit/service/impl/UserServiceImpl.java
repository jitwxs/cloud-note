package cn.edu.jit.service.impl;

import cn.edu.jit.entry.*;
import cn.edu.jit.global.GlobalConstant;
import cn.edu.jit.global.GlobalFunction;
import cn.edu.jit.mapper.LoginMapper;
import cn.edu.jit.mapper.UserMapper;
import cn.edu.jit.service.UserService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/2 23:17
 */
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    UserMapper userMapper;

    @Override
    public User getByTel(String tel) {
        UserExample userExample = new UserExample();

        UserExample.Criteria criteria = userExample.createCriteria();
        criteria.andTelEqualTo(tel);

        List<User> list = userMapper.selectByExample(userExample);

        if (list.size() > 0) {
            return list.get(0);
        } else {
            return null;
        }
    }

    @Override
    public User getById(String id) {
        return userMapper.selectByPrimaryKey(id);
    }

    @Override
    public int save(User user) {
        return userMapper.insertSelective(user);
    }

    @Override
    public int update(User user) {
        user.setModifedDate(new Date());
        return userMapper.updateByPrimaryKey(user);
    }

    @Override
    public int removeByTel(String tel) {
        UserExample userExample = new UserExample();
        UserExample.Criteria criteria = userExample.createCriteria();
        criteria.andTelEqualTo(tel);
        return userMapper.deleteByExample(userExample);
    }

    @Override
    public int countBySex(String sex) {
        UserExample userExample = new UserExample();
        UserExample.Criteria criteria = userExample.createCriteria();
        criteria.andSexEqualTo(sex);
        return userMapper.countByExample(userExample);
    }

    @Override
    public List<User> listAllUser(String orderBy) {
        UserExample userExample = new UserExample();
        userExample.setOrderByClause(orderBy);
        return userMapper.selectByExample(userExample);
    }
}
