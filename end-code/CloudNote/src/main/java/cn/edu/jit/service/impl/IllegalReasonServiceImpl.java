package cn.edu.jit.service.impl;

import cn.edu.jit.entry.IllegalReason;
import cn.edu.jit.entry.IllegalReasonExample;
import cn.edu.jit.mapper.IllegalReasonMapper;
import cn.edu.jit.service.IllegalReasonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/3 13:19
 */
@Service
public class IllegalReasonServiceImpl implements IllegalReasonService {
    @Autowired
    IllegalReasonMapper illegalReasonMapper;

    @Override
    public List<IllegalReason> listAll() {
        IllegalReasonExample illegalReasonExample = new IllegalReasonExample();
        return illegalReasonMapper.selectByExample(illegalReasonExample);
    }

    @Override
    public IllegalReason getById(String id) {
        return illegalReasonMapper.selectByPrimaryKey(id);
    }

    @Override
    public int update(IllegalReason illegalReason) {
        return illegalReasonMapper.updateByPrimaryKey(illegalReason);
    }

    @Override
    public int removeById(String id) {
        return illegalReasonMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int save(IllegalReason illegalReason) {
        return illegalReasonMapper.insertSelective(illegalReason);
    }
}
