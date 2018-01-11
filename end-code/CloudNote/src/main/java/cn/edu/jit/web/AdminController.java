package cn.edu.jit.web;

import cn.edu.jit.entry.Article;
import cn.edu.jit.entry.Login;
import cn.edu.jit.entry.Message;
import cn.edu.jit.entry.User;
import cn.edu.jit.global.GlobalConstant;
import cn.edu.jit.global.GlobalFunction;
import cn.edu.jit.service.ArticleService;
import cn.edu.jit.service.LoginService;
import cn.edu.jit.service.UserService;
import cn.edu.jit.util.Sha1Utils;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.List;

/**
 * 管理员web层
 * @author jitwxs
 * @date 2018/1/6 9:16
 */
@Controller
@RequestMapping(value = "/admin")
public class AdminController {

    @Resource(name = "userServiceImpl")
    private UserService userService;

    @Resource(name = "articleServiceImpl")
    private ArticleService articleService;

    @Resource(name = "loginServiceImpl")
    private LoginService loginService;

    /*---------   普通方法区域（START）   ----------*/

    /**
     * 获取当前用户id
     */
    private String getSelfId() {
        User user = userService.getByTel(GlobalFunction.getSelfTel());
        return user.getId();
    }

    /*---------   普通方法区域（END）   ----------*/

    @RequestMapping(value = "index")
    public String index(HttpServletRequest request, HttpServletResponse response) {
        String data = GlobalFunction.getDate();
        Cookie cookie = new Cookie("lastLoginTime", data);
        // 登录时间保存30天
        cookie.setMaxAge(60 * 60 * 24 * 30);
        response.addCookie(cookie);

        Cookie[] cookies = request.getCookies();
        String result = "";
        if(cookies.length > 0) {
            for (Cookie ck: cookies) {
                if("lastLoginTime".equals(ck.getName())) {
                    String lastLoginTime = ck.getValue();
                    result = "上次登陆：" + lastLoginTime.replace('#',' ');
                }
            }
        } else {
            result = "上次登陆：未知";
        }
        // 是否显示登陆信息
        if(GlobalConstant.HAS_SHOW_LOGIN_INFO) {
            request.setAttribute("lastLoginTime", result);
            GlobalConstant.HAS_SHOW_LOGIN_INFO = false;
        }
        return "admin/left";
    }


    /*---------   用户管理区域（Start）   ----------*/
    /**
     * 获取所有普通用户
     */
    @RequestMapping(value = "showAllUser", method = {RequestMethod.POST})
    public void showAllUser(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        try {
            List<User> users = userService.listAllUser();
            Message message = new Message();
            message.setUsers(users);
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 获取指定用户所有文章
     */
    @RequestMapping(value = "showUserArticle", method = {RequestMethod.POST})
    public void showUserArticle(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        try {
            String userId = request.getParameter("id");
            List<Article> articles = articleService.listArticleByUid(userId);
            Message message = new Message();
            message.setArticles(articles);
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 获取所有文章
     */
    @RequestMapping(value = "showAllArticle", method = {RequestMethod.POST})
    public void showAllArticle(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        try {
            List<Article> articles = articleService.listAllArticle();
            Message message = new Message();
            message.setArticles(articles);
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }


    }

    /**
     * 删除文章
     */
    @RequestMapping(value = "deleteArticle", method = {RequestMethod.POST})
    public void deleteArticle(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        try {
            String id = request.getParameter("id");
            Message message = new Message();
            if (articleService.removeById(id) != 1) {
                message.setStatus(false);
                message.setInfo("删除失败");
            } else {
                message.setStatus(true);
                message.setInfo("删除成功");
            }
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }


    }

    /**
     * 删除用户
     */
    @RequestMapping(value = "deleteUser", method = {RequestMethod.POST})
    public void deleteUser(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        String tel = request.getParameter("tel");
        Login login = loginService.getByTel(tel);
        Message message = new Message();
        if (login == null) {
            message.setStatus(false);
            message.setInfo("用户不存在");
        } else {
            //login表和user表中删除此用户
            loginService.removeByTel(tel);
            userService.removeByTel(tel);
            //删除此用户的文件
            try {
                GlobalFunction.delFolder(GlobalConstant.UPLOAD_PATH + "/" + tel);
            } catch (Exception e) {
                e.printStackTrace();
            }
            message.setStatus(true);
            message.setInfo("删除成功");
        }
        try {
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 添加用户
     */
    @RequestMapping(value = "addUser", method = {RequestMethod.POST})
    public void addUser(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        String tel = request.getParameter("tel");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
//        String area = request.getParameter("area");
        String sex = request.getParameter("sex");
        String sign = request.getParameter("sign");

        try {
            Login checkLogin = loginService.getByTel(tel);
            Message message = new Message();
            if (checkLogin != null) {
                message.setStatus(false);
                message.setInfo("用户已存在");
            } else {
                Login login = new Login();
                User user = new User();
                login.setCreateDate(new Date());
                String encryptedPassword = Sha1Utils.entryptPassword(password);
                login.setPassword(encryptedPassword);
                login.setTel(tel);
                loginService.save(login);
//                user.setArea(area);
                user.setCreateDate(new Date());
                user.setEmail(email);
                user.setId(GlobalFunction.getUUID());
                user.setName(name);
                user.setSex(sex);
                user.setSign(sign);
                userService.save(user);
                message.setStatus(true);
                message.setInfo("添加成功");
            }
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 修改用户信息
     * */
    @RequestMapping(value = "updateUser", method = {RequestMethod.POST})
    public void updateUser(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        String tel = request.getParameter("tel");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
//        String area = request.getParameter("area");
        String sex = request.getParameter("sex");
        String sign = request.getParameter("sign");

        try {
            User checkUser = userService.getByTel(tel);
            Message message = new Message();
            if (checkUser == null) {
                message.setStatus(false);
                message.setInfo("用户不存在");
            } else {
                User user = new User();
//                user.setArea(area);
                user.setModifedDate(new Date());
                user.setEmail(email);
                user.setId(GlobalFunction.getUUID());
                user.setName(name);
                user.setSex(sex);
                user.setSign(sign);
                userService.update(user);
                message.setStatus(true);
                message.setInfo("修改成功");
            }
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 修改用户密码
     * */
    @RequestMapping(value = "changeUserPassword", method = {RequestMethod.POST})
    public void changeUserPassword(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        String tel = request.getParameter("tel");
        String password = request.getParameter("password");
        try {
            Login checkLogin = loginService.getByTel(tel);
            Message message = new Message();
            if (checkLogin == null) {
                message.setStatus(false);
                message.setInfo("用户不存在");
            } else {
                Login login = new Login();
                String encryptedPassword = Sha1Utils.entryptPassword(password);
                login.setPassword(encryptedPassword);
                loginService.update(login);
                message.setStatus(true);
                message.setInfo("修改成功");
            }
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 验证密码
     */
    @RequestMapping(value = "verifyPassword", method = {RequestMethod.POST})
    public void resetPassword(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        try {
            String passWord = request.getParameter("password");
            Login login = loginService.getByTel(GlobalFunction.getSelfTel());
            Message msg = new Message();
            if (!Sha1Utils.validatePassword(passWord, login.getPassword())) {
                msg.setStatus(false);
                msg.setInfo("密码错误");
            } else {
                msg.setStatus(true);
                msg.setInfo("验证成功");
            }
            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 重置密码
     */
    @RequestMapping(value = "resetPassword", method = {RequestMethod.POST})
    public String resetPassword(String newPassword) {
        Login login = loginService.getByTel(GlobalFunction.getSelfTel());
        String encryptedPassword = Sha1Utils.entryptPassword(newPassword);
        login.setPassword(encryptedPassword);
        login.setModifiedDate(new Date());
        loginService.update(login);
        return "redirect:/logout";
    }
    /*---------   用户管理区域（END）   ----------*/





}
