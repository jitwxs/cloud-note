package cn.edu.jit.dto;

import cn.edu.jit.entry.Article;
import cn.edu.jit.entry.ArticleRecycle;

/**
 * @author jitwxs
 * @date 2018/1/8 20:40
 */
public class ArticleRecycleDto extends ArticleRecycle {
    /**
     * 作者名称，目前使用手机号
     */
    private String authorName;

    private String authorTel;

    public String getAuthorName() { return authorName; }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public String getAuthorTel() { return authorTel; }

    public void setAuthorTel(String authorTel) { this.authorTel = authorTel; }
}
