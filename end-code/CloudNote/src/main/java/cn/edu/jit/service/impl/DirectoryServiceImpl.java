<<<<<<< HEAD
package cn.edu.jit.service.impl;

import cn.edu.jit.entry.ArticleExample;
import cn.edu.jit.entry.Directory;
import cn.edu.jit.entry.DirectoryExample;
import cn.edu.jit.mapper.DirectoryMapper;
import cn.edu.jit.service.DirectoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/3 14:14
 */

@Service
public class DirectoryServiceImpl implements DirectoryService {
    @Autowired
    DirectoryMapper directoryMapper;

    @Override
    public int save(Directory directory) {
        return directoryMapper.insertSelective(directory);
    }

    @Override
    public int remove(String id) {
        return directoryMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int update(Directory directory) {
        directory.setModifedDate(new Date());
        return directoryMapper.updateByPrimaryKey(directory);
    }

    @Override
    public Directory getById(String id) {
        return directoryMapper.selectByPrimaryKey(id);
    }

    @Override
    public List<Directory> listByUid(String uid) {
        DirectoryExample directoryExample = new DirectoryExample();

        DirectoryExample.Criteria criteria = directoryExample.createCriteria();
        criteria.andUidEqualTo(uid);

        return directoryMapper.selectByExample(directoryExample);
    }

    @Override
    public List<Directory> listByParentId(String uid, String parentId) {
        DirectoryExample directoryExample = new DirectoryExample();

        DirectoryExample.Criteria criteria = directoryExample.createCriteria();
        criteria.andUidEqualTo(uid);
        criteria.andParentIdEqualTo(parentId);

        return directoryMapper.selectByExample(directoryExample);
    }
}
=======
package cn.edu.jit.service.impl;

import cn.edu.jit.entry.ArticleExample;
import cn.edu.jit.entry.Directory;
import cn.edu.jit.entry.DirectoryExample;
import cn.edu.jit.mapper.DirectoryMapper;
import cn.edu.jit.service.DirectoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/3 14:14
 */

@Service
public class DirectoryServiceImpl implements DirectoryService {
    @Autowired
    DirectoryMapper directoryMapper;

    @Override
    public int save(Directory directory) {
        return directoryMapper.insertSelective(directory);
    }

    @Override
    public int remove(String id) {
        return directoryMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int update(Directory directory) {
        directory.setModifedDate(new Date());
        return directoryMapper.updateByPrimaryKey(directory);
    }

    @Override
    public Directory getById(String id) {
        return directoryMapper.selectByPrimaryKey(id);
    }

    @Override
    public List<Directory> listByUid(String uid) {
        DirectoryExample directoryExample = new DirectoryExample();

        DirectoryExample.Criteria criteria = directoryExample.createCriteria();
        criteria.andUidEqualTo(uid);

        return directoryMapper.selectByExample(directoryExample);
    }

    @Override
    public List<Directory> listByParentId(String uid, String parentId) {
        DirectoryExample directoryExample = new DirectoryExample();

        DirectoryExample.Criteria criteria = directoryExample.createCriteria();
        criteria.andUidEqualTo(uid);
        criteria.andParentIdEqualTo(parentId);

        return directoryMapper.selectByExample(directoryExample);
    }
}
>>>>>>> origin/master
