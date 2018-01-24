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

    List<Notify> listAll(String orderBy);

    List<Notify> listByRecvId(String recvId, String type, Integer status, String orderBy);
}
