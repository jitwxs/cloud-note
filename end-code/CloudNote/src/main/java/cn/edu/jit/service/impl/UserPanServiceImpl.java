package cn.edu.jit.service.impl;

import cn.edu.jit.entry.PanDir;
import cn.edu.jit.entry.PanDirExample;
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
    public UserPan getById(String id) {
        return userPanMapper.selectByPrimaryKey(id);
    }

    @Override
    public List<UserPan> getByName(String dirId, String name) {
        UserPanExample userPanExample = new UserPanExample();
        UserPanExample.Criteria criteria = userPanExample.createCriteria();
        criteria.andNameEqualTo(name);
        criteria.andDirIdEqualTo(dirId);
        return userPanMapper.selectByExample(userPanExample);
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

    @Override
    public List<UserPan> listUserPanByDir(String uid, String dirId) {
        UserPanExample userPanExample = new UserPanExample();

        UserPanExample.Criteria criteria = userPanExample.createCriteria();
        criteria.andUseridEqualTo(uid);
        criteria.andDirIdEqualTo(dirId);
        return userPanMapper.selectByExample(userPanExample);
    }

    @Override
    public List<UserPan> listUserPanByTitle(String uid, String title) {
        UserPanExample userPanExample = new UserPanExample();

        UserPanExample.Criteria criteria = userPanExample.createCriteria();
        criteria.andUseridEqualTo(uid);
        // 加上通配符
        title = "%" + title + "%";
        criteria.andNameLike(title);

        return userPanMapper.selectByExample(userPanExample);
    }
}
