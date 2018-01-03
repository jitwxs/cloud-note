package cn.edu.jit.web;

import cn.edu.jit.entry.User;
import cn.edu.jit.service.ArticleService;
import cn.edu.jit.service.LoginService;
import cn.edu.jit.service.UserService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 用户控制
 * @author jitwxs
 * @date 2018/1/3 13:10
 */

@Controller
@RequestMapping(value = "/user")
public class UserController {

    @Resource(name = "userServiceImpl")
    private UserService userService;

    @Resource(name = "articleServiceImpl")
    private ArticleService articleService;

    /*---------   普通方法区域（START）   ----------*/

    /**
     * 获取登陆用户id
     * @return
     */
    public String getSelfId() {
        User user = userService.getByTel(getSelfTel());
        return user.getId();
    }

    public String getSelfTel() {
        Subject subject = SecurityUtils.getSubject();
        return (String) subject.getPrincipal();
    }

    /*---------   普通方法区域（START）   ----------*/

    /*---------   文章管理区域（START）   ----------*/

    // TODO 保存文章
    @RequestMapping(value = "/saveArticle", method = {RequestMethod.POST})
    public void saveArticle(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");

    }

    @RequestMapping(value = "/removeArticle", method = {RequestMethod.GET})
    public void removeArticle(String id) {
        articleService.removeById(id);
    }

    /*---------   文章管理区域（END）   ----------*/

}
