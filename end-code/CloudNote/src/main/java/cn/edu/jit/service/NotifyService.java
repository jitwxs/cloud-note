package cn.edu.jit.service;

import cn.edu.jit.entry.Notify;
import cn.edu.jit.entry.Page;
import org.aspectj.weaver.ast.Not;

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

    /**
     * 返回消息集合
     * @param recvId 接收者id
     * @param type 消息类型，为null时返回所有
     * @param status 消息状态，为null时返回所有
     * @return
     */
    List<Notify> listByRecvId(String recvId, String type, Integer status, String orderBy);

    List<Notify> listByRecvId(String recvId, String type, Integer status, Page page);

    /**
     * 统计消息条数
     * @param recvId 接收者id
     * @param type 消息类型，为null时返回所有
     * @return
     */
    int countByRecvId(String recvId, String type);
}
