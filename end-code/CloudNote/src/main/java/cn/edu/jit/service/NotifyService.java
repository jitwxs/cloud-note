package cn.edu.jit.service;

import cn.edu.jit.entry.Notify;

import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/19 10:00
 */
public interface NotifyService {
    int save(Notify notify);

    int removeById(String id);

    int update(Notify notify);

    int countUnRead(String recvId);

    Notify getById(String id);

    List<Notify> listBySendId(String sendId);

    List<Notify> listByRecvId(String recvId, String orderBy);

    List<Notify> listByRecvIdAndType(String recvId, String type, String orderBy);
}
