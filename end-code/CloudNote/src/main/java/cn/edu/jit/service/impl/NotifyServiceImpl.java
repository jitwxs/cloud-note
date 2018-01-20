package cn.edu.jit.service.impl;

import cn.edu.jit.entry.Notify;
import cn.edu.jit.entry.NotifyExample;
import cn.edu.jit.entry.PanDirExample;
import cn.edu.jit.global.GlobalConstant;
import cn.edu.jit.mapper.NotifyMapper;
import cn.edu.jit.service.NotifyService;
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
    public List<Notify> listBySendId(String sendId) {
        NotifyExample notifyExample = new NotifyExample();

        NotifyExample.Criteria criteria = notifyExample.createCriteria();
        criteria.andSendIdEqualTo(sendId);

        return notifyMapper.selectByExample(notifyExample);
    }

    @Override
    public List<Notify> listByRecvId(String recvId, String orderBy) {
        NotifyExample notifyExample = new NotifyExample();
        notifyExample.setOrderByClause(orderBy);
        NotifyExample.Criteria criteria = notifyExample.createCriteria();
        criteria.andRecvIdEqualTo(recvId);

        return notifyMapper.selectByExample(notifyExample);
    }

    @Override
    public List<Notify> listByRecvIdAndType(String recvId, String type, String orderBy) {
        NotifyExample notifyExample = new NotifyExample();
        notifyExample.setOrderByClause(orderBy);
        NotifyExample.Criteria criteria = notifyExample.createCriteria();
        criteria.andRecvIdEqualTo(recvId);
        criteria.andTypeEqualTo(type);

        return notifyMapper.selectByExample(notifyExample);
    }
}
