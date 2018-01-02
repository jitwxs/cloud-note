package cn.edu.jit.web;

import cn.edu.jit.entry.Login;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * 系统管理
 * @author jitwxs
 * @date 2018/1/2 19:24
 */
@Controller
public class SystemController {

    @RequestMapping(value="/login", method = {RequestMethod.GET})
    public String loginUI() {
        return "login";
    }

    @RequestMapping(value="/login", method = {RequestMethod.POST})
    public void login(Login login) {

    }

}
