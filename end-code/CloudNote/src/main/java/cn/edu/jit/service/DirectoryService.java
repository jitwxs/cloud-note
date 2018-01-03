package cn.edu.jit.service;

import cn.edu.jit.entry.Directory;

/**
 * @author jitwxs
 * @date 2018/1/3 14:13
 */
public interface DirectoryService {
    int save(Directory directory);

    int remove(String id);

    int update(Directory directory);

    Directory getById(String id);
}
