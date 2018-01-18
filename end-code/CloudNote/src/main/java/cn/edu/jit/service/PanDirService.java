package cn.edu.jit.service;

import cn.edu.jit.entry.ArticleDir;
import cn.edu.jit.entry.PanDir;

import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/3 14:13
 */
public interface PanDirService {

    int save(PanDir panDir);

    int remove(String id);

    int update(PanDir panDir);

    PanDir getById(String id);

    List<PanDir> listByParentId(String uid, String parentId);

    List<PanDir> listPanDirByTitle(String uid, String title);

    List<PanDir> getByName(String uid, String parentDir, String name);
}
