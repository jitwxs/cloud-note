package cn.edu.jit.web;

import cn.edu.jit.entry.Login;
import cn.edu.jit.entry.User;
import cn.edu.jit.global.GlobalConstant;
import cn.edu.jit.global.GlobalFunction;
import cn.edu.jit.util.Sha1Utils;
import cn.edu.jit.service.LoginService;
import cn.edu.jit.service.UserService;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.List;

/**
 * 系统管理
 * @author jitwxs
 * @date 2018/1/2 19:24
 */
@Controller
public class SystemController {

    @Resource(name = "loginServiceImpl")
    private LoginService loginService;

    @Resource(name = "userServiceImpl")
    private UserService userService;

    @RequestMapping(value = "/login", method = {RequestMethod.GET})
    public String loginUI() {
        return "login";
    }

    @RequestMapping(value = "/loginCheck", method = {RequestMethod.POST})
    public void loginCheck(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=utf-8");
        Boolean res = true;

        String tel = request.getParameter("tel");
        String password = request.getParameter("password");

        Login login = null;
        login = loginService.getByTel(tel);

        // 账户不存在或密码错误
        if (login == null) {
            res = false;
        } else if(!Sha1Utils.validatePassword(password, login.getPassword())) {
            res = false;
        }
        response.getWriter().write("{\"res\":" + res + "}");
    }

    @RequestMapping(value = "/login", method = {RequestMethod.POST})
    public String login(Login login) {
        // Shiro验证
        UsernamePasswordToken token = new UsernamePasswordToken(login.getTel(), login.getPassword());
        Subject subject = SecurityUtils.getSubject();

        // 如果获取不到用户名就是登录失败，登录失败会直接抛出异常
        subject.login(token);

        // 所有用户均重定向对应的展示配送页面
        if (subject.hasRole(GlobalConstant.ROLE.ADMIN.getName())) {
            return "redirect:/admin/index";
        } else if (subject.hasRole(GlobalConstant.ROLE.USER.getName())) {
            return "redirect:/user/index";
        } else {
            return "/login";
        }
    }

    @RequestMapping(value = "/register", method = {RequestMethod.GET})
    public String registerUI() {
        return "register";
    }

    @RequestMapping(value = "/registerCheck", method = {RequestMethod.POST})
    public void registerCheck(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Boolean res = true;
        response.setContentType("text/html;charset=utf-8");
        String tel = request.getParameter("tel");

        // 手机号已经被注册
        if (loginService.getByTel(tel) != null) {
            res = false;
        }
        response.getWriter().write("{\"res\":" + res + "}");
    }

    @RequestMapping(value = "/register", method = {RequestMethod.POST})
    public String register(Login login) {
        loginService.save(login);

        User user = GlobalFunction.login2User(login);
        userService.save(user);

        return "redirect:/login";
    }

    @RequestMapping(value = "resetPassword", method = {RequestMethod.GET})
    public String resetPassword() {
        return "resetPassword";
    }

    /**
     * 忘记密码
     */
    @RequestMapping(value = "resetPassword", method = {RequestMethod.POST})
    public void resetPassword(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        Boolean status = true;
        try {
            String newPassword = request.getParameter("newPassword");
//        String id = request.getParameter("id");
            String encryptedPassword = Sha1Utils.entryptPassword(newPassword);
            Login login = loginService.getByTel("13260908721");
            login.setPassword(encryptedPassword);
            login.setModifiedDate(new Date());
            if (loginService.update(login) != 1) {
                status = false;
            }
            response.getWriter().write("{\"status\":" + status + "}");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
