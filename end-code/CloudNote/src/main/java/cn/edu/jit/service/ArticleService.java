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

    List<Article> listArticleByUid(String uid);

    /**
     * 查询指定用户按标题匹配笔记
     * @param uid 用户id
     * @param name 笔记名
     * @return
     */
    List<Article> listArticleByTitle(String uid, String name);

    /**
     * 查询指定用户按标签名匹配笔记
     * @param uid 用户id
     * @param tagName 标签名
     * @return
     */
    List<Article> listArticleByTagName(String uid, String tagName);

    /**
     * 查询指定用户指定目录下的所有笔记
     * @param uid 用户id
     * @param dirId 目录id
     * @return
     */
    List<Article> listArticleByDir(String uid, String dirId);

    /**
     * 查询指定用户所有分享的笔记
     * @param uid 用户id
     * @return
     */
    List<Article> listArticleByShare(String uid);

    /**
     * 查询非指定用户以外的其他用户的分享笔记
     * @param uid 用户id
     * @return
     */
    List<Article> listAnotherShareArticle(String uid);

    /**
     * 查询用户笔记数量
     * @param uid 用户id
     * @return
     */
    int countArticle(String uid);

    List<Article> listAllArticle();

    public List<Article> listAllShareArticle();

}
