package cn.edu.jit.service;

import cn.edu.jit.entry.Reason;

import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/15 9:50
 */
public interface ReasonService {

    List<Reason> listAllByType(Integer type);

    Reason getById(String id);

    int update(Reason reason);

    int removeById(String id);

    int save(Reason reason);
}
