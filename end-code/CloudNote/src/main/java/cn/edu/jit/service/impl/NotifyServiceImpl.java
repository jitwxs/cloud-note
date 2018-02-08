package cn.edu.jit.service.impl;

import cn.edu.jit.entry.Notify;
import cn.edu.jit.entry.NotifyExample;
import cn.edu.jit.entry.Page;
import cn.edu.jit.entry.PanDirExample;
import cn.edu.jit.global.GlobalConstant;
import cn.edu.jit.mapper.NotifyMapper;
import cn.edu.jit.service.NotifyService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/19 10:03
 */
@Service
public class NotifyServiceImpl implements NotifyService {
    @Autowired
    NotifyMapper notifyMapper;


    @Override
    public int save(Notify notify) {
        return notifyMapper.insertSelective(notify);
    }

    @Override
    public int removeById(String id) {
        return notifyMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int update(Notify notify) {
        notify.setModifedDate(new Date());
        return notifyMapper.updateByPrimaryKey(notify);
    }

    @Override
    public int countUnRead(String recvId) {
        NotifyExample notifyExample = new NotifyExample();

        NotifyExample.Criteria criteria = notifyExample.createCriteria();
        criteria.andRecvIdEqualTo(recvId);
        criteria.andStatusEqualTo(GlobalConstant.NOTIFY_STATUS.UNREAD.getIndex());

        return notifyMapper.countByExample(notifyExample);
    }

    @Override
    public Notify getById(String id) {
        return notifyMapper.selectByPrimaryKey(id);
    }

    @Override
    public List<Notify> listAll(String orderBy) {
        NotifyExample notifyExample = new NotifyExample();
        notifyExample.setOrderByClause(orderBy);
        return notifyMapper.selectByExample(notifyExample);
    }

    @Override
    public List<Notify> listByRecvId(String recvId, String type, Integer status, String orderBy) {
        NotifyExample notifyExample = new NotifyExample();
        if(!StringUtils.isBlank(orderBy)) {
            notifyExample.setOrderByClause(orderBy);
        }
        NotifyExample.Criteria criteria = notifyExample.createCriteria();
        criteria.andRecvIdEqualTo(recvId);
        if(!StringUtils.isBlank(type)) {
            criteria.andTypeEqualTo(type);
        }
        if(status != null) {
            criteria.andStatusEqualTo(status);
        }

        return notifyMapper.selectByExample(notifyExample);
    }

    @Override
    public List<Notify> listByRecvId(String recvId, String type, Integer status, Page page) {
        return notifyMapper.listByRecvId(recvId, type, status, page);
    }

    @Override
    public int countByRecvId(String recvId, String type) {
        NotifyExample notifyExample = new NotifyExample();

        NotifyExample.Criteria criteria = notifyExample.createCriteria();
        criteria.andRecvIdEqualTo(recvId);
        if(!StringUtils.isBlank(type)) {
            criteria.andTypeEqualTo(type);
        }

        return notifyMapper.countByExample(notifyExample);
    }
}
