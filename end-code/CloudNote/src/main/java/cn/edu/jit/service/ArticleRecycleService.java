package cn.edu.jit.service;

import cn.edu.jit.entry.Article;
import cn.edu.jit.entry.ArticleRecycle;
import cn.edu.jit.entry.ArticleRecycleExample;

import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/3 13:19
 */
public interface ArticleRecycleService {

    int save(ArticleRecycle articleRecycle);

    public ArticleRecycle getById(String id);

    public int removeById(String id);

    public List<ArticleRecycle> listAllRecycle();
}
