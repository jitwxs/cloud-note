package cn.edu.jit.web;

import cn.edu.jit.entry.*;
import cn.edu.jit.dto.UserDto;
import cn.edu.jit.global.GlobalConstant;
import cn.edu.jit.global.GlobalFunction;
import cn.edu.jit.service.*;
import cn.edu.jit.util.HttpUtils;
import cn.edu.jit.util.Sha1Utils;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.TypeReference;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.aliyuncs.dysmsapi.model.v20170525.SendSmsResponse;
import com.aliyuncs.exceptions.ClientException;
import com.qq.connect.api.OpenID;
import com.qq.connect.api.qzone.UserInfo;
import com.qq.connect.javabeans.AccessToken;
import com.qq.connect.javabeans.qzone.UserInfoBean;
import com.qq.connect.oauth.Oauth;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.*;

/**
 * 系统管理
 * @author jitwxs
 * @date 2018/1/2 19:24
 */
@Controller
public class SystemController {

    @Resource(name = "logServiceImpl")
    private LogService logService;

    @Resource(name = "loginServiceImpl")
    private LoginService loginService;

    @Resource(name = "userServiceImpl")
    private UserService userService;

    @Resource(name = "areaServiceImpl")
    private AreaService areaService;

    @Resource(name = "articleServiceImpl")
    private ArticleService articleService;

    @Resource(name = "supportAreaServiceImpl")
    private SupportAreaService supportAreaService;

    @Resource(name = "userBlacklistServiceImpl")
    private UserBlacklistService userBlacklistService;

    @Resource(name = "notifyServiceImpl")
    private NotifyService notifyService;

    private String getSelfId() {
        User user = userService.getByTel(GlobalFunction.getSelfTel());
        return user.getId();
    }

    private void initPath(HttpServletRequest request) {
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        GlobalConstant.SHARE_TEMPLATE  = loader.getResource("shareTemplate.html").getPath();
        GlobalConstant.TEMP_PATH = request.getSession().getServletContext().getRealPath("temp");
        GlobalConstant.UPLOAD_PATH  = request.getSession().getServletContext().getRealPath("upload");
        GlobalConstant.USER_HOME_PATH = GlobalConstant.UPLOAD_PATH  + "/"  + GlobalFunction.getSelfTel();
        GlobalConstant.USER_ARTICLE_PATH  = GlobalConstant.USER_HOME_PATH  + "/" + "article";
        GlobalConstant.USER_ARTICLE_INDEX_PATH  = GlobalConstant.USER_HOME_PATH  + "/" + "article_index";
        GlobalConstant.USER_SHARE_PATH = GlobalConstant.USER_ARTICLE_PATH + "/" + "share";
        GlobalConstant.USER_IMG_PATH = GlobalConstant.USER_HOME_PATH  + "/" + "images";
        GlobalConstant.USER_PAN_PATH = GlobalConstant.USER_HOME_PATH  + "/"  + "pan" ;

        GlobalFunction.createDir(GlobalConstant.TEMP_PATH);
        GlobalFunction.createDir(GlobalConstant.USER_ARTICLE_PATH);
        GlobalFunction.createDir(GlobalConstant.USER_SHARE_PATH);
        GlobalFunction.createDir(GlobalConstant.USER_IMG_PATH);
        GlobalFunction.createDir(GlobalConstant.USER_PAN_PATH);
    }

    private void parserUser(User user, String key, String value) {
        switch (key) {
            case "id":
                BeanUtils.copyProperties(userService.getById(value), user);
                break;
            case "name":
                user.setName(value);
                break;
            case "email":
                user.setEmail(value);
                break;
            case "area":
                int v = Integer.parseInt(value);
                if(v != -1) {
                    user.setArea(v);
                }
                break;
            case "icon":
                user.setIcon(value);
                break;
            case "sex":
                user.setSex(value);
                break;
            case "sign":
                user.setSign(value);
                break;
            default:
                break;
        }
    }

    /**
     * GitHub用户转普通用户
     * @return
     */
    private User gitHub2User(GitHubUser gitHubUser) {
        User user = new User();
        user.setId(GlobalFunction.getUUID());
        user.setName(gitHubUser.getLogin());
        user.setEmail(gitHubUser.getEmail());

        return user;
    }

    /**
     * 拷贝头像
     */
    private void copyIcon(User user, String imagesPath) {
        try {
            if (user.getSex().equals("男")) {
                FileInputStream fis = new FileInputStream(imagesPath + "/default_man.png");
                FileOutputStream fos = new FileOutputStream(GlobalConstant.UPLOAD_PATH + "/" + user.getTel() + "/images/icon.png");
                byte[] buff = new byte[1024];
                int readed = -1;
                while ((readed = fis.read(buff)) > 0) {
                    fos.write(buff, 0, readed);
                }
                fis.close();
                fos.close();
            } else {
                FileInputStream fis = new FileInputStream(imagesPath + "/default_woman.png");
                FileOutputStream fos = new FileOutputStream(GlobalConstant.UPLOAD_PATH + "/" + user.getTel() + "/images/icon.png");
                byte[] buff = new byte[1024];
                int len;
                while ((len = fis.read(buff)) > 0) {
                    fos.write(buff, 0, len);
                }
                fis.close();
                fos.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "qqLogin", method = {RequestMethod.GET})
    public void qqLogin(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        try {
            response.sendRedirect(new Oauth().getAuthorizeURL(request));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "afterQQLogin", method = {RequestMethod.GET})
    public void afterQQLoginGet(HttpServletRequest request, HttpServletResponse response) {
        afterQQLoginPost(request,response);
    }

    @RequestMapping(value = "afterQQLogin", method = {RequestMethod.POST})
    public void afterQQLoginPost(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html; charset=utf-8");
        try {
            PrintWriter out = response.getWriter();
            AccessToken accessTokenObj = (new Oauth()).getAccessTokenByRequest(request);
            String accessToken = null, openID = null;
            long tokenExpireIn = 0L;
            if ("".equals(accessTokenObj.getAccessToken())) {
                System.out.print("没有获取到响应参数");
            } else {
                accessToken = accessTokenObj.getAccessToken();
                tokenExpireIn = accessTokenObj.getExpireIn();
                request.getSession().setAttribute("demo_access_token", accessToken);
                request.getSession().setAttribute("demo_token_expirein", String.valueOf(tokenExpireIn));
                // 利用获取到的accessToken 去获取当前用的openid
                OpenID openIDObj = new OpenID(accessToken);
                openID = openIDObj.getUserOpenID();
                request.getSession().setAttribute("demo_openid", openID);
                UserInfo qzoneUserInfo = new UserInfo(accessToken, openID);
                UserInfoBean userInfoBean = qzoneUserInfo.getUserInfo();
                out.println("<br/>");
                if (userInfoBean.getRet() == 0) {
                    out.println(userInfoBean.getNickname() + "<br/>");
                    out.println(userInfoBean.getGender() + "<br/>");
                } else {
                    out.println("很抱歉，我们没能正确获取到您的信息，原因是： " + userInfoBean.getMsg());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "githubLogin", method = {RequestMethod.GET})
    public void githubLogin(HttpServletResponse response) {
        try {
            response.setContentType("text/html;charset=utf-8");
            String url = "https://github.com/login/oauth/authorize";
            String param = "client_id=" + GlobalConstant.GITHUB_CLIENT_ID + "&state=" + GlobalFunction.getUUID()
                    + "&redirect_uri=" + GlobalConstant.GITHUB_REDIRECT_URL;
            System.out.println(url + "?" + param);
            response.sendRedirect(url + "?" + param);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "githubCallback", method = {RequestMethod.GET})
    public void githubCallback(HttpServletRequest request, HttpServletResponse response) {
        try {
            response.setContentType("text/html;charset=utf-8");
            String url = "https://github.com/login/oauth/access_token";
            String code = request.getParameter("code");
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("client_id", GlobalConstant.GITHUB_CLIENT_ID);
            jsonObject.put("client_secret", GlobalConstant.GITHUB_CLIENT_SECRET);
            jsonObject.put("code", code);

            String token = GlobalFunction.getGitHubToken(url, jsonObject);
            JSONObject resultObj = HttpUtils.httpGet("https://api.github.com/user?access_token=" + token);

            GitHubUser github = JSON.parseObject(resultObj.toJSONString(), new TypeReference<GitHubUser>() {});
            User user = gitHub2User(github);

            // 保存数据库

        } catch (Exception e) {
            e.printStackTrace();
        }
    }



    @RequestMapping(value = "login", method = {RequestMethod.GET})
    public String loginUI() {
        return "login";
    }

    @RequestMapping(value = "loginCheck", method = {RequestMethod.POST})
    public void loginCheck(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        Boolean status = true;
        String info = "";
        String tel = request.getParameter("tel");
        String password = request.getParameter("password");

        try {
            Login login = loginService.getByTel(tel);

            // 账户不存在或密码错误
            if (login == null) {
                status = false;
                info = "账户不存在";
            } else if(!Sha1Utils.validatePassword(password, login.getPassword())) {
                status = false;
                info = "密码错误";
            }

            // 判断账户是否被封禁
            if(status) {
                User user = userService.getByTel(tel);
                List<UserBlacklist> list = userBlacklistService.listValid(user.getId());
                if(list.size() > 0) {
                    Date maxDate = new Date();
                    for(UserBlacklist userBlacklist : list) {
                        Date tempDate = userBlacklist.getEndDate();
                        if(tempDate.compareTo(maxDate) >= 0) {
                            maxDate = tempDate;
                        }
                    }
                    status = false;
                    info = "账户被封禁，解封时间为：" + GlobalFunction.getDate2Second(maxDate);
                }
            }

            Message message = new Message();
            message.setStatus(status);
            message.setInfo(info);
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        }catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "login", method = {RequestMethod.POST})
    public String login(Login login, HttpServletRequest request) {
        // Shiro验证
        UsernamePasswordToken token = new UsernamePasswordToken(login.getTel(), login.getPassword());
        Subject subject = SecurityUtils.getSubject();

        // 如果获取不到用户名就是登录失败，登录失败会直接抛出异常
        subject.login(token);

        // 初始化项目路径
        initPath(request);

        // 初始化用户头像
        User user = userService.getByTel(login.getTel());
        if (user.getIcon() == null) {
            String imagesPath = request.getSession().getServletContext().getRealPath("images");
            user.setIcon(GlobalConstant.UPLOAD_PATH + "/" + user.getTel() + "/images/icon.png");
            copyIcon(user,imagesPath);
            userService.update(user);
        }

        // 保存日志
        logService.saveLog(request, GlobalConstant.LOG_USER.type, GlobalConstant.LOG_USER.USER_LOGIN.getName(), getSelfId());

        // 所有用户均重定向对应首页
        if (subject.hasRole(GlobalConstant.ROLE.ADMIN.getName())) {
            GlobalConstant.HAS_SHOW_LOGIN_INFO = true;
            return "redirect:/admin/index";
        } else if (subject.hasRole(GlobalConstant.ROLE.USER.getName())) {
            GlobalConstant.HAS_SHOW_LOGIN_INFO = true;
            return "redirect:/user/index";
        } else {
            return "/login";
        }
    }

    @RequestMapping(value = "logout")
    public String logout(){
        return "redirect:/logout";
    }

    @RequestMapping(value = "register", method = {RequestMethod.GET})
    public String registerUI() {
        return "register";
    }

    @RequestMapping(value = "checkTelRegistered", method = {RequestMethod.POST})
    public void checkTelRegistered (HttpServletRequest request, HttpServletResponse response) {
        try {
            String tel = request.getParameter("tel");
            Message message = new Message();
            Login login = loginService.getByTel(tel);
            if(login != null) {
                message.setStatus(false);
            } else {
                message.setStatus(true);
            }
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "registerCheck", method = {RequestMethod.POST})
    public void registerCheck(HttpServletRequest request, HttpServletResponse response){
        Boolean status = true;
        String info = null;
        Message message = new Message();
        response.setContentType("text/html;charset=utf-8");
        String tel = request.getParameter("tel");
        String verityCode = request.getParameter("code");
        // 手机号已经被注册

        HttpSession session = request.getSession();
        String sendTel = (String)session.getAttribute("tel");
        String sendCode = (String)session.getAttribute("code");

        try {
            if (tel == null) {
                status = false;
                info = "请输入手机号";
            } else {
                if (loginService.getByTel(tel) != null) {
                    status = false;
                    info = "手机号已被注册";
                } else {
                    if (sendTel == null) {
                        status = false;
                        info = "请发送验证码";
                    } else {
                        if (!tel.equals(sendTel)) {
                            status = false;
                            info = "注册号码与验证号码不一致";
                        } else {
                            if (!verityCode.equals(sendCode)){
                                status = false;
                                info = "验证码输入错误";
                            }
                        }
                    }
                }
            }
            message.setStatus(status);
            message.setInfo(info);
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    @RequestMapping(value = "register", method = {RequestMethod.POST})
    public String register(Register register, HttpServletRequest request) {
        User user = new User();

        String inputArea = register.getArea();
        if(!StringUtils.isBlank(inputArea)) {
            Area area = areaService.getByName(register.getArea());
            if (area != null) {
                user.setArea(area.getId());
            }
        }
        if(!StringUtils.isBlank(register.getEmail())) {
            user.setEmail(register.getEmail());
        }

        // 性别默认为男
        if(!StringUtils.isBlank(register.getSex())) {
            user.setSex(register.getSex());
        } else {
            user.setSex("男");
        }

        String userId = GlobalFunction.getUUID();
        user.setId(userId);
        user.setTel(register.getTel());
        user.setName(register.getName());
        user.setCreateDate(new Date());

        Login login = new Login();
        login.setTel(user.getTel());
        login.setRoleId(GlobalConstant.ROLE.USER.getIndex());
        login.setCreateDate(new Date());
        login.setPassword(Sha1Utils.entryptPassword(register.getPassword()));

        // 必须先保存Login表，外键约束
        loginService.save(login);
        userService.save(user);

        // 保存日志
        logService.saveLog(request, GlobalConstant.LOG_USER.type, GlobalConstant.LOG_USER.USER_REG.getName(), userId);

        return "redirect:login";
    }

    /**
     * 发送短信验证
     */
    @RequestMapping(value = "smsVerification", method = {RequestMethod.POST})
    public void smsVerification(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        boolean status = true;
        String tel = request.getParameter("tel");
        // 生成6位验证码
        String verifyCode = (int)((Math.random()*9+1)*100000) + "";
        System.out.println(verifyCode);
        HttpSession session = request.getSession();
        session.setAttribute("code",verifyCode);
        session.setAttribute("tel",tel);

        String sessionId = session.getId();

        Cookie cookie = new Cookie("JSESSIONID", sessionId);
        cookie.setMaxAge(60 * 5);
        response.addCookie(cookie);

        try {
            SendSmsResponse res = GlobalFunction.sendSms(tel, verifyCode);
            if (!"OK".equals(res.getCode())) {
                status = false;
            }
        } catch (ClientException e) {
            status = false;
            e.printStackTrace();
        }
        try {
            response.getWriter().write("{\"status\": " + status + "}");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "codeCheck", method = {RequestMethod.POST})
    public void codeCheck(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        Boolean status = false;
        String info = null;
        try {
            String tel = request.getParameter("tel");
            String verityCode = request.getParameter("verityCode");

            HttpSession session = request.getSession();
            String sendTel = (String)session.getAttribute("tel");
            String sendCode = (String)session.getAttribute("code");

            if(StringUtils.isBlank(tel)) {
                info = "手机号为空";
            } else {
                if(loginService.getByTel(tel) == null) {
                    info = "手机号未注册";
                } else {
                    if (StringUtils.isBlank(sendTel) && !StringUtils.equals(tel, sendTel)) {
                        info = "验证码未发送";
                    } else {
                        if(StringUtils.equals(sendCode,verityCode)) {
                            info = "验证成功";
                            status = true;
                        } else {
                            info = "验证码错误";
                        }
                    }
                }
            }
            Message msg = new Message();
            msg.setStatus(status);
            msg.setInfo(info);
            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "foundPassword", method = {RequestMethod.GET})
    public String resetPasswordUI() {
        return "foundPassword";
    }

    @RequestMapping(value = "foundPassword", method = {RequestMethod.POST})
    public void resetPassword(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        Boolean status = true;
        String info = null;
        try {
            String newPassword = request.getParameter("newPassword");
            String tel = request.getParameter("tel");

            Login login = loginService.getByTel(tel);
            if(login != null) {
                String encryptedPassword = Sha1Utils.entryptPassword(newPassword);
                login.setPassword(encryptedPassword);
                if (loginService.update(login) != 1) {
                    status = false;
                    info = "修改密码失败";
                }
            }

            // 保存日志
            logService.saveLog(request, GlobalConstant.LOG_USER.type, GlobalConstant.LOG_USER.FIND_PASSWORD.getName(), getSelfId());

            // status：是否成功；info：成功返回null，失败返回错误原因
            Message msg = new Message();
            msg.setStatus(status);
            msg.setInfo(info);
            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            // 保存日志
            logService.saveLog(request, e, GlobalConstant.LOG_USER.type, GlobalConstant.LOG_USER.FIND_PASSWORD.getName(), getSelfId());
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "showUserCity", method = {RequestMethod.GET})
    public void showUserCity(HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        List<User> lists = userService.listAllUser("null");
        Map<String,Integer> map = new HashMap<>(16);
        try {
            if(lists.size() > 0) {
                for(User user : lists) {
                    if(user.getArea() != null) {
                        Area area = areaService.getById(user.getArea());
                        String temp = area.getName();
                        String name = "";
                        if(temp.endsWith("市")) {
                            name = temp.substring(0, temp.length() -1 );
                        } else if(temp.endsWith("区") || temp.endsWith("县")) {
                            Area area1 = areaService.getById(area.getPid());
                            name = area1.getName().substring(0, temp.length() -1 );
                        }

                        if(map.containsKey(name)) {
                            map.put(name, map.get(name) + 1);
                        } else {
                            // 只显示可预览的城市
                            SupportArea supportArea = supportAreaService.getByName(name);
                            if(supportArea != null) {
                                map.put(name, 1);
                            }
                        }
                    }
                }
            }

            List<Data> datas = new ArrayList<>();
            for (Map.Entry<String, Integer> entry : map.entrySet()) {
                Data data = new Data();
                data.setK(entry.getKey());
                data.setV(String.valueOf(entry.getValue()));
                datas.add(data);
            }

            String msg = JSON.toJSONString(datas, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(msg);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 省市二级联动
     */
    @RequestMapping(value = "getSecondArea", method = {RequestMethod.POST})
    public void getSecondArea(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        Message message = new Message();
        try {
            String areaId = request.getParameter("areaId");
            if (areaId != null) {
                List<Area> lists = areaService.listByPid(Integer.parseInt(areaId));
                message.setAreas(lists);
            } else {
                message.setStatus(false);
            }
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "showSelfInfo", method = {RequestMethod.GET})
    public void showUserInfo(HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        Message message = new Message();
        try {
            String id = getSelfId();
            UserDto userDto = new UserDto();
            User user = userService.getById(id);
            BeanUtils.copyProperties(user, userDto);

            // 设置所在地区
            Integer areaId = user.getArea();
            if(areaId != null) {
                Area area = areaService.getById(user.getArea());
                userDto.setAreaName(area.getName());
            }
            // 设置头像真实路径
            String iconUrl = user.getIcon();
            if(!StringUtils.isBlank(iconUrl)) {
                String iconRealUrl = GlobalFunction.getRealUrl(iconUrl);
                userDto.setIcon(iconRealUrl);
            }

            // 获取未读消息数目
            int count = notifyService.countUnRead(getSelfId());

            List<Area> areas = areaService.listByPid(0);
            message.setUserDto(userDto);
            message.setAreas(areas);
            message.setInfo(String.valueOf(count));
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "saveSelfInfo", method = {RequestMethod.POST})
    public String saveUserInfo(HttpServletRequest request) {
        User user = new User();
        try {
            // 1.创建磁盘文件项工厂 sizeThreshold：每次缓存大小，单位为字节  File：临时文件路径
            DiskFileItemFactory factory = new DiskFileItemFactory(1024 * 1024, new File(GlobalConstant.TEMP_PATH));

            // 2.创建文件上传核心类
            ServletFileUpload upload = new ServletFileUpload(factory);
            // 设置上传文件的编码
            upload.setHeaderEncoding("UTF-8");

            // 3.判断是否为上传文件的表单
            if (ServletFileUpload.isMultipartContent(request)) {
                // 4.解析request获得文件项集合
                List<FileItem> fileItems = upload.parseRequest(request);
                if (fileItems.size() != 0) {
                    for (FileItem item : fileItems) {
                        // 5,判断是不是一个普通的表单项
                        if (item.isFormField()) {
                            String fieldName = item.getFieldName();
                            String fieldValue = item.getString("UTF-8");
                            parserUser(user, fieldName, fieldValue);
                        } else {
                            // 获取上传头像的文件名
                            String fileName = item.getName();
                            // 如果文件名为空，就跳过
                            if (StringUtils.isBlank(fileName)) {
                                continue;
                            }
                            // 重命名：规定icon+小写后缀作为头像名
                            fileName = "icon." + fileName.split("\\.")[1].toLowerCase();

                            // 拼装路径
                            String targetFilePath = GlobalConstant.USER_IMG_PATH + "/" + fileName;
                            // 上传文件
                            GlobalFunction.uploadFile(item, targetFilePath);

                            // 设置数据库中头像url
                            user.setIcon(targetFilePath);
                        }
                    }
                }
            }
            userService.update(user);

            // 保存日志
            logService.saveLog(request, GlobalConstant.LOG_USER.type, GlobalConstant.LOG_USER.MODIFY_INFO.getName(), getSelfId());
        } catch (Exception e) {
            // 保存日志
            logService.saveLog(request, e, GlobalConstant.LOG_USER.type, GlobalConstant.LOG_USER.MODIFY_INFO.getName(), getSelfId());
            e.printStackTrace();
        }

        Subject subject = SecurityUtils.getSubject();
        if (subject.hasRole(GlobalConstant.ROLE.ADMIN.getName())) {
            return "redirect:/admin/index";
        } else if (subject.hasRole(GlobalConstant.ROLE.USER.getName())) {
            return "redirect:/user/index";
        } else {
            return "/login";
        }
    }

    @RequestMapping(value = "getStar", method = {RequestMethod.GET})
    public void getStar(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        Message message = new Message();
        Boolean status = false;
        String noteId = request.getParameter("noteId").trim();
        try {
            if(!StringUtils.isBlank(noteId)) {
                Article article = articleService.getById(noteId);
                if(article != null) {
                    String star = String.valueOf(article.getStar());
                    status = true;
                    message.setInfo(star);
                }
            }
            message.setStatus(status);
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 更新star数目
     */
    @RequestMapping(value = "star", method = {RequestMethod.POST})
    public void star(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        Boolean status = false;
        Message message = new Message();
        String star = request.getParameter("like_num");
        String noteId = request.getParameter("noteId").trim();
        try {
            if(!StringUtils.isBlank(noteId)) {
                if(!StringUtils.isBlank(star)) {
                    Integer starNum = Integer.parseInt(star);

                    Article article = articleService.getById(noteId);

                    int tempStar = article.getStar() + starNum;
                    article.setStar(tempStar < 0 ? 0 : tempStar);
                    articleService.update(article);
                    status = true;

                    // 发送消息
                    String sendId = getSelfId();
                    User user = userService.getById(sendId);
                    String userName = user.getName();

                    Notify notify = new Notify();
                    notify.setId(GlobalFunction.getUUID());
                    notify.setType(GlobalConstant.NOTIFY.NOTIFY_NOTE.getName());
                    notify.setSendId(sendId);
                    notify.setRecvId(article.getUserId());
                    notify.setStatus(GlobalConstant.NOTIFY_STATUS.UNREAD.getIndex());
                    notify.setTitle("分享笔记收到一个赞");
                    notify.setContent("用户：“" + userName + "”刚刚给您的分享笔记《" + article.getTitle() +"》点了一个赞");
                    notify.setCreateDate(new Date());
                    notifyService.save(notify);

                    // 保存日志
                    logService.saveLog(request, GlobalConstant.NOTIFY.type, GlobalConstant.NOTIFY.NOTIFY_NOTE.getName(), sendId);
                }
            }
            message.setStatus(status);
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
