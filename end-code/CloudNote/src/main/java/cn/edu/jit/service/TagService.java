package cn.edu.jit.service;

import cn.edu.jit.entry.Tag;

import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/3 13:38
 */
public interface TagService {
    int save(Tag tag);

    int update(Tag tag);

    int remove(String id);

    Tag getById(String id);

    List<Tag> listByName(String name);
}
