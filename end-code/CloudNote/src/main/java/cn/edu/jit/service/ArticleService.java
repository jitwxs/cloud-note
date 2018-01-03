package cn.edu.jit.service;

import cn.edu.jit.entry.Article;

import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/3 13:19
 */
public interface ArticleService {

    int removeById(String id);

    int save(Article article);

    int update(Article article);

    Article getById(String id);

    List<Article> listSbTitle(String uid, String name);

    List<Article> listSbByTag(String uid, String tagId);

    int countSbArticle(String uid);
}
