package cn.edu.jit.entry;

/**
 * GitHub用户信息类
 * @author jitwxs
 * @date 2018/1/22 16:21
 */
public class GitHubUser {

    /**
     * Github唯一id
     */
    private String id;

    /**
     * 用户名称
     */
    private String login;

    /**
     * 邮箱
     */
    private String email;

    /**
     * 头像url
     */
    private String avatar_url;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAvatar_url() {
        return avatar_url;
    }

    public void setAvatar_url(String avatar_url) {
        this.avatar_url = avatar_url;
    }
}
