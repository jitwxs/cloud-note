package cn.edu.jit.service;

import cn.edu.jit.entry.Article;
import cn.edu.jit.entry.ArticleTagKey;

import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/3 13:39
 */
public interface ArticleTagService {
    int save(ArticleTagKey articleTagKey);

    int remove(ArticleTagKey articleTagKey);

    List<ArticleTagKey> listByArticleId(String articleId);

    int countByArticleId(String articleId);
}
