package cn.edu.jit.service.impl;

import cn.edu.jit.entry.UserPan;
import cn.edu.jit.entry.UserPanExample;
import cn.edu.jit.mapper.UserPanMapper;
import cn.edu.jit.service.UserPanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/9 16:14
 */
@Service
public class UserPanServiceImpl implements UserPanService {
    @Autowired
    UserPanMapper userPanMapper;

    @Override
    public List<UserPan> listByUserId(String userId) {
        UserPanExample userPanExample = new UserPanExample();

        UserPanExample.Criteria criteria = userPanExample.createCriteria();
        criteria.andUseridEqualTo(userId);

        return userPanMapper.selectByExample(userPanExample);
    }

    @Override
    public UserPan getById(String id) {
        return userPanMapper.selectByPrimaryKey(id);
    }

    @Override
    public int removeById(String id) {
        return userPanMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void removeAll(String userId) {
        UserPanExample userPanExample = new UserPanExample();

        UserPanExample.Criteria criteria = userPanExample.createCriteria();
        criteria.andUseridEqualTo(userId);

        userPanMapper.deleteByExample(userPanExample);
    }

    @Override
    public int updateById(UserPan userpan) {
        userpan.setModifedTime(new Date());
        return userPanMapper.updateByPrimaryKey(userpan);
    }

    @Override
    public int save(UserPan userPan) {
       return userPanMapper.insertSelective(userPan);
    }
}
