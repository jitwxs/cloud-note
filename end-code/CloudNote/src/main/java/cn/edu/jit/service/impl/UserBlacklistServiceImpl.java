package cn.edu.jit.service.impl;

import cn.edu.jit.entry.Tag;
import cn.edu.jit.entry.TagExample;
import cn.edu.jit.entry.UserBlacklist;
import cn.edu.jit.entry.UserBlacklistExample;
import cn.edu.jit.mapper.UserBlacklistMapper;
import cn.edu.jit.service.UserBlacklistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/2 23:17
 */
@Service
public class UserBlacklistServiceImpl implements UserBlacklistService {

    @Autowired
    UserBlacklistMapper userBlacklistMapper;

    @Override
    public UserBlacklist getById(String id) {
        return userBlacklistMapper.selectByPrimaryKey(id);
    }

    @Override
    public int save(UserBlacklist userBlacklist) {
        return userBlacklistMapper.insertSelective(userBlacklist);
    }

    @Override
    public int update(UserBlacklist userBlacklist) {
        return userBlacklistMapper.updateByPrimaryKey(userBlacklist);
    }

    @Override
    public List<UserBlacklist> listAll(String orderBy) {
        UserBlacklistExample userBlacklistExample = new UserBlacklistExample();
        userBlacklistExample.setOrderByClause(orderBy);
        return userBlacklistMapper.selectByExample(userBlacklistExample);
    }

    @Override
    public List<UserBlacklist> listValid(String uid) {
        UserBlacklistExample userBlacklistExample = new UserBlacklistExample();

        UserBlacklistExample.Criteria criteria = userBlacklistExample.createCriteria();
        criteria.andUserIdEqualTo(uid);
        criteria.andEndDateGreaterThanOrEqualTo(new Date());

        return userBlacklistMapper.selectByExample(userBlacklistExample);
    }

    @Override
    public int removeById(String id) {
        return userBlacklistMapper.deleteByPrimaryKey(id);
    }
}
