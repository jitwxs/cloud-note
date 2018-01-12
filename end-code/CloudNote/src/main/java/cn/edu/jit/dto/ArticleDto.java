package cn.edu.jit.dto;

import cn.edu.jit.entry.Article;

/**
 * @author jitwxs
 * @date 2018/1/8 20:40
 */
public class ArticleDto extends Article {
    /**
     * 作者昵称
     */
    private String authorName;

    private String authorTel;

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public String getAuthorTel() { return authorTel; }

    public void setAuthorTel(String authorTel) { this.authorTel = authorTel; }
}
