package cn.edu.jit.service;

import cn.edu.jit.entry.Article;
import cn.edu.jit.entry.ArticleTagKey;

import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/3 13:39
 */
public interface ArticleTagService {
    ArticleTagKey getByArticleIdAndTagId(String articleId, String tagId);

    int save(ArticleTagKey articleTagKey);

    int remove(ArticleTagKey articleTagKey);

    /**
     * 移除文章所有标签
     */
    int removeAllByArticleId(String articleId);

    /**
     * 获取文章所有标签
     */
    List<ArticleTagKey> listByArticleId(String articleId);
}
