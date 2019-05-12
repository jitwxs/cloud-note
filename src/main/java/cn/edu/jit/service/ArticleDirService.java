package cn.edu.jit.service;

import cn.edu.jit.entry.ArticleDir;

import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/3 14:13
 */
public interface ArticleDirService {

    int save(ArticleDir articleDir);

    int remove(String id);

    int update(ArticleDir articleDir);

    ArticleDir getById(String id);

    /**
     * 指定用户指定目录下所有子目录
     */
    List<ArticleDir> listByParentId(String uid, String parentId, String orderBy);

    List<ArticleDir> getByName(String uid, String parentId, String dirName);
}
