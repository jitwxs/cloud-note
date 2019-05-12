package cn.edu.jit.service;

import cn.edu.jit.entry.UserBlacklist;

import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/15 13:50
 */
public interface UserBlacklistService {
    UserBlacklist getById(String id);

    int save(UserBlacklist userBlacklist);

    int update(UserBlacklist userBlacklist);

    List<UserBlacklist> listAll(String orderBy);

    /**
     * 获取所有有效的封禁记录
     */
    List<UserBlacklist> listValid(String uid);

    int removeById(String id);
}
