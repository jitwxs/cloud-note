package cn.edu.jit.service;

import cn.edu.jit.entry.PanDir;
import cn.edu.jit.entry.UserPan;

import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/9 16:11
 */
public interface UserPanService {
    UserPan getById(String id);

    List<UserPan> getByName(String dirId, String name);

    int removeById(String id);

    void removeAll(String userId);

    int updateById(UserPan userpan);

    int save(UserPan userPan);

    /**
     * 查询指定用户指定目录下的所有笔记
     * @param uid 用户id
     * @param dirId 目录id
     * @return
     */
    List<UserPan> listUserPanByDir(String uid, String dirId);

    List<UserPan> listUserPanByTitle(String uid, String title);
}
