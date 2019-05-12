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

    /**
     * 作者头像
     */
    private String authorIcon;

    /**
     * 摘要信息
     */
    private String abstractText;

    public String getAbstractText() {
        return abstractText;
    }

    public void setAbstractText(String abstractText) {
        this.abstractText = abstractText;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public String getAuthorTel() { return authorTel; }

    public void setAuthorTel(String authorTel) { this.authorTel = authorTel; }

    public String getAuthorIcon() {
        return authorIcon;
    }

    public void setAuthorIcon(String authorIcon) {
        this.authorIcon = authorIcon;
    }
}
