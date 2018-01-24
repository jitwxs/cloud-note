package cn.edu.jit.service.impl;

import cn.edu.jit.entry.Reason;
import cn.edu.jit.entry.ReasonExample;
import cn.edu.jit.mapper.ReasonMapper;
import cn.edu.jit.service.ReasonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/3 13:19
 */
@Service
public class ReasonServiceImpl implements ReasonService {
    @Autowired
    ReasonMapper reasonMapper;

    @Override
    public List<Reason> listAllByType(Integer type) {
        ReasonExample reasonExample = new ReasonExample();
        ReasonExample.Criteria criteria = reasonExample.createCriteria();
        criteria.andTypeEqualTo(type);
        return reasonMapper.selectByExample(reasonExample);
    }

    @Override
    public Reason getById(String id) {
        return reasonMapper.selectByPrimaryKey(id);
    }

    @Override
    public int update(Reason reason) {
        reason.setModifedDate(new Date());
        return reasonMapper.updateByPrimaryKey(reason);
    }

    @Override
    public int removeById(String id) {
        return reasonMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int save(Reason reason) {
        return reasonMapper.insertSelective(reason);
    }

    @Override
    public List<Reason> getByTypeAndName(int type, String name) {
        ReasonExample reasonExample = new ReasonExample();
        ReasonExample.Criteria criteria = reasonExample.createCriteria();
        criteria.andTypeEqualTo(type);
        criteria.andNameEqualTo(name);
        return reasonMapper.selectByExample(reasonExample);
    }
}