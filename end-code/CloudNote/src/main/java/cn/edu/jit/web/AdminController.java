package cn.edu.jit.web;

import cn.edu.jit.entry.User;
import cn.edu.jit.global.GlobalFunction;
import cn.edu.jit.service.UserService;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

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

    /*---------   普通方法区域（START）   ----------*/

    /**
     * 获取登陆用户id
     */
    private String getSelfId() {
        User user = userService.getByTel(GlobalFunction.getSelfTel());
        return user.getId();
    }

    /*---------   普通方法区域（END）   ----------*/

    @RequestMapping(value = "index")
    public String index() {
        return "admin/index";
    }


    /*---------   用户管理区域（Start）   ----------*/


    /*---------   用户管理区域（END）   ----------*/





}
