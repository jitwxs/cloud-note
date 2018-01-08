package cn.edu.jit.dto;

import cn.edu.jit.entry.Article;

/**
 * @author jitwxs
 * @date 2018/1/8 20:40
 */
public class ArticleDto extends Article {
    /**
     * 作者名称，目前使用手机号
     */
    private String authorName;

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }
}
