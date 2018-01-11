package cn.edu.jit.entry;

import cn.edu.jit.dto.ArticleDto;

import java.io.Serializable;
import java.util.List;

/**
 * 通信类
 * @author jitwxs
 * @date 2018/1/8 13:20
 */
public class Message implements Serializable {
    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }

    public String getInfo() {
        return info;
    }

    public void setInfo(String info) {
        this.info = info;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getDirId() {
        return dirId;
    }

    public void setDirId(String dirId) {
        this.dirId = dirId;
    }

    public String getNoteId() {
        return noteId;
    }

    public void setNoteId(String noteId) {
        this.noteId = noteId;
    }

    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

    public List<Tag> getNoteTag() {
        return noteTag;
    }

    public void setNoteTag(List<Tag> noteTag) {
        this.noteTag = noteTag;
    }

    public List<ArticleAffix> getAffixes() {
        return affixes;
    }

    public void setAffixes(List<ArticleAffix> affixes) {
        this.affixes = affixes;
    }

    public List<UserPan> getUserFiles() {
        return userFiles;
    }

    public void setUserFiles(List<UserPan> userFiles) {
        this.userFiles = userFiles;
    }

    public List<Article> getArticles() {
        return articles;
    }

    public void setArticles(List<Article> articles) {
        this.articles = articles;
    }

    public List<ArticleDto> getArticleDtos() {
        return articleDtos;
    }

    public void setArticleDtos(List<ArticleDto> articleDtos) {
        this.articleDtos = articleDtos;
    }

    public ArticleDto getArticleDto() {
        return articleDto;
    }

    public void setArticleDto(ArticleDto articleDto) {
        this.articleDto = articleDto;
    }

    public List<User> getUsers() {
        return users;
    }

    public void setUsers(List<User> users) {
        this.users = users;
    }

    private Boolean status;

    private String info;

    private String name;

    private String userId;

    private String dirId;

    private String noteId;

    private String tel;

    private List<Article> articles;

    private ArticleDto articleDto;

    private List<ArticleDto> articleDtos;

    private List<Tag> noteTag;

    private List<ArticleAffix> affixes;

    private List<User> users;

    private List<UserPan> userFiles;

}
