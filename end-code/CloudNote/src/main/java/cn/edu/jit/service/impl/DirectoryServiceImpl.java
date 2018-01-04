package cn.edu.jit.service.impl;

import cn.edu.jit.entry.Directory;
import cn.edu.jit.mapper.DirectoryMapper;
import cn.edu.jit.service.DirectoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;

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
}
