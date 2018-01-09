package cn.edu.jit.service;

import cn.edu.jit.entry.ArticleAffix;

import java.util.List;


/**
 * @author jitwxs
 * @date 2018/1/9 16:06
 */
public interface ArticleAffixService {

    ArticleAffix getById(String affixId);

    List<ArticleAffix> listByArticleId(String articleId);

    int removeById(String id);

    int removeAllByArticleId(String articleId);

    int save(ArticleAffix articleAffix);
}
