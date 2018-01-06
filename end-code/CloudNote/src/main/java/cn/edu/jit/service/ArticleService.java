<<<<<<< HEAD
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

    List<Article> listArticleByTitle(String uid, String name);

    List<Article> listArticleByTag(String uid, String tagId);

    List<Article> listArticleByDir(String uid, String dirId);

    int countArticle(String uid);

}
=======
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

    List<Article> listArticleByTitle(String uid, String name);

    List<Article> listArticleByTag(String uid, String tagId);

    List<Article> listArticleByDir(String uid, String dirId);

    int countArticle(String uid);

}
>>>>>>> origin/master
