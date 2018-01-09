package cn.edu.jit.service;

import cn.edu.jit.entry.UserPan;

import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/9 16:11
 */
public interface UserPanService {
    List<UserPan> listByUserId(String userId);

    UserPan getById(String id);

    int removeById(String id);

    void removeAll(String userId);

    int updateById(UserPan userpan);

    int save(UserPan userPan);
}
