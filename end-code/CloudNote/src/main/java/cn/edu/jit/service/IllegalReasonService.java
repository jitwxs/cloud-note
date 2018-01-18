package cn.edu.jit.service;

import cn.edu.jit.entry.IllegalReason;

import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/15 9:50
 */
public interface IllegalReasonService {

    List<IllegalReason> listAll();

    IllegalReason getById(String id);

    int update(IllegalReason illegalReason);

    int removeById(String id);

    int save(IllegalReason illegalReason);
}
