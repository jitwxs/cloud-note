package cn.edu.jit.web;

import cn.edu.jit.entry.Article;
import cn.edu.jit.entry.ArticleRecycle;
import cn.edu.jit.entry.Login;
import cn.edu.jit.entry.User;
import cn.edu.jit.global.GlobalFunction;
import cn.edu.jit.service.ArticleRecycleService;
import cn.edu.jit.service.ArticleService;
import cn.edu.jit.service.LoginService;
import cn.edu.jit.service.UserService;
import cn.edu.jit.util.Sha1Utils;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import sun.misc.BASE64Encoder;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.util.List;

/**
 * 用户控制层
 *
 * @author jitwxs
 * @date 2018/1/3 13:10
 */

@Controller
@RequestMapping(value = "/user")
public class UserController {

    @Resource(name = "userServiceImpl")
    private UserService userService;

    @Resource(name = "loginServiceImpl")
    private LoginService loginService;

    @Resource(name = "articleServiceImpl")
    private ArticleService articleService;

    @Resource (name = "articleRecycleServiceImpl")
    private ArticleRecycleService articleRecycleService;


    /*---------   普通方法区域（START）   ----------*/

    /**
     * 获取登陆用户id
     */
    private String getSelfId() {
        User user = userService.getByTel(GlobalFunction.getSelfTel());
        return user.getId();
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
                user.setArea(value);
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
     * 对文件名发送到客户端时进行编码
     */
    private String solveFileNameEncode(String agent, String fileName) {
        String res = "";
        try {
            if (agent.contains("MSIE")) {
                // IE浏览器
                res = URLEncoder.encode(fileName, "utf-8");
                res = res.replace("+", " ");
            } else if (agent.contains("Firefox")) {
                // 火狐浏览器
                BASE64Encoder base64Encoder = new BASE64Encoder();
                res = "=?utf-8?B?"
                        + base64Encoder.encode(fileName.getBytes("utf-8")) + "?=";
            } else {
                // 其它浏览器
                res = URLEncoder.encode(fileName, "utf-8");
            }
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return res;
    }
    /*---------   普通方法区域（END）   ----------*/

    @RequestMapping(value = "index")
    public String indexUI(HttpServletRequest request) {
        request.setAttribute("uid", getSelfId());
        return "user/index";
    }

    /*---------   用户管理区域（START）   ----------*/

    /**
     * 显示用户信息
     */
    @RequestMapping(value = "showUserInfo", method = {RequestMethod.POST})
    public void showUserInfo(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        String id = request.getParameter("id");
        try {
            User user = userService.getById(id);
            String data = JSON.toJSONString(user, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 保存用户信息
     */
    @RequestMapping(value = "saveUserInfo", method = {RequestMethod.POST})
    public String saveUserInfo(HttpServletRequest request, HttpServletResponse response) {
        User user = new User();
        String temp_path = request.getSession().getServletContext().getRealPath("temp"); // 获取temp文件夹路径
        String upload_path = request.getSession().getServletContext().getRealPath("upload"); // 获取upload文件夹路径
        try {
            // 1.创建磁盘文件项工厂 sizeThreshold：每次缓存大小，单位为字节  File：临时文件路径
            DiskFileItemFactory factory = new DiskFileItemFactory(1024 * 1024, new File(temp_path));

            // 2.创建文件上传核心类
            ServletFileUpload upload = new ServletFileUpload(factory);
            // 设置上传文件的编码
            upload.setHeaderEncoding("UTF-8");

            // 3.判断是否为上传文件的表单
            if (upload.isMultipartContent(request)) {
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
                            if (StringUtils.isEmpty(fileName)) {
                                continue;
                            }
                            // 重命名：规定未手机号+后缀作为头像名
                            fileName = GlobalFunction.getSelfTel() + "." + fileName.split("\\.")[1];

                            // 拼装路径
                            String icon_path = GlobalFunction.getSelfTel() + "/" + fileName;
                            String targetFilePath = upload_path + "/" + icon_path;
                            // 上传文件
                            GlobalFunction.uploadFile(item, targetFilePath);

                            // 设置数据库中头像url
                            user.setIcon(icon_path);
                        }
                    }
                }
            }
            userService.update(user);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:index";
    }
    /*---------   用户管理区域（END）   ----------*/

    /*---------   文章管理区域（START）   ----------*/
    @RequestMapping(value = "/removeArticle", method = {RequestMethod.GET})
    public void removeArticle(String id) {
        articleService.removeById(id);
    }

    /**
     * 导入笔记
     */
    @RequestMapping(value = "importNote", method = {RequestMethod.POST})
    public String importNote(HttpServletRequest request, HttpServletResponse response) {
        User user = new User();
        String temp_path = request.getSession().getServletContext().getRealPath("temp"); // 获取temp文件夹路径
        String upload_path = request.getSession().getServletContext().getRealPath("upload"); // 获取upload文件夹路径
        try {
            // 1.创建磁盘文件项工厂 sizeThreshold：每次缓存大小，单位为字节  File：临时文件路径
            DiskFileItemFactory factory = new DiskFileItemFactory(1024 * 1024, new File(temp_path));

            // 2.创建文件上传核心类
            ServletFileUpload upload = new ServletFileUpload(factory);
            // 设置上传文件的编码
            upload.setHeaderEncoding("UTF-8");

            // 3.判断是否为上传文件的表单
            if (upload.isMultipartContent(request)) {
                // 4.解析request获得文件项集合
                List<FileItem> fileItems = upload.parseRequest(request);
                if (fileItems.size() != 0) {
                    for (FileItem item : fileItems) {
                        // 获取上传头像的文件名
                        String fileName = item.getName();
                        // 如果文件名为空，就跳过
                        if (StringUtils.isEmpty(fileName)) {
                            continue;
                        }
                        // 重命名：规定未手机号+后缀作为头像名
                        fileName = GlobalFunction.getSelfTel() + "_note." + fileName.split("\\.")[1];

                        // 拼装路径
                        String icon_path = GlobalFunction.getSelfTel() + "/" + fileName;
                        String targetFilePath = upload_path + "/" + icon_path;
                        // 上传文件
                        GlobalFunction.uploadFile(item, targetFilePath);
                    }
                }
            }
            userService.update(user);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:index";
    }

    /**
     * 保存笔记
     */
    @RequestMapping(value = "/saveArticle", method = {RequestMethod.POST})
    public void saveArticle(HttpServletRequest request, HttpServletResponse response) {
        String upload_path = request.getSession().getServletContext().getRealPath("upload"); // 获取upload文件夹路径
        //String noteName = request.getParameter("noteId");
        String noteName = "111.txt";
        response.setContentType("text/html;charset=utf-8");
        try {
//        String articleId = request.getParameter("id");
            String content = request.getParameter("data");
            String targetFilePath = upload_path + "/" + GlobalFunction.getSelfTel() + "/" + noteName;

            File file = new File(targetFilePath);
            if (!file.getParentFile().exists()) {
                file.getParentFile().mkdirs();
            }

            OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream(targetFilePath), "UTF-8");
            System.out.println(content);
            writer.write(content);
            writer.flush();
            writer.close();
            response.getWriter().write("{\"status\":" + true + "}");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    /**
     * 删除文章
     * @param request
     * @param response
     */
    @RequestMapping(value = "/removeArticle", method = {RequestMethod.POST})
    public void removeArticle(HttpServletRequest request, HttpServletResponse response){
        try {
            String id = request.getParameter("id");
            ArticleRecycle articleRecycle = new ArticleRecycle();
            Article article = articleService.getById("1");
            if (article == null) {
                response.getWriter().write("inexistence");
            } else {
                BeanUtils.copyProperties(article, articleRecycle);
                if(articleService.removeById("1") == 1 && articleRecycleService.save(articleRecycle) == 1) {
                    response.getWriter().write("true");
                } else {
                    response.getWriter().write("false");
                }
            }
        }catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 恢复笔记
     */
    @RequestMapping(value = "/recoverNote", method = {RequestMethod.POST})
    public void showUserNote(HttpServletRequest request, HttpServletResponse response) {
        char[] buf = new char[1024];
        int len;
        response.setContentType("text/html;charset=utf-8");
        try {
            //String noteName = request.getParameter("noteId");
            String noteName = "111.txt";
            String upload_path = request.getSession().getServletContext().getRealPath("upload");
            String targetFilePath = upload_path + "/" + GlobalFunction.getSelfTel() + "/" + noteName;

            InputStreamReader reader = new InputStreamReader(new FileInputStream(targetFilePath), "UTF-8");

            while ((len = reader.read(buf, 0, 1024)) > 0) {
                response.getWriter().write(buf, 0, len);
            }
            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 导出笔记/文件下载
     */
    @RequestMapping(value = "/downloadFile", method = {RequestMethod.GET})
    public void downloadFile(HttpServletRequest request, HttpServletResponse response) {
        try {
            String upload_path = request.getSession().getServletContext().getRealPath("upload");
            String fileName = request.getParameter("fileId");
            // 设置编码（如果文件名乱码，尝试打开） fileName = new String(fileName.getBytes("ISO8859-1"),"UTF-8");
            // 得到用于返回给客户端的编码后的文件名
            String agent = request.getHeader("User-Agent");
            String fileNameEncode = solveFileNameEncode(agent, fileName);
            // 客户端判断下载文件类型
            response.setContentType(request.getSession().getServletContext().getMimeType(fileName));
            // 关闭客户端的默认解析
            response.setHeader("Content-Disposition", "attachment;filename=" + fileNameEncode);
            // 获得文件真实下载路径
            String path = upload_path + "/" + GlobalFunction.getSelfTel() + "/" + fileName;
            InputStream in = new FileInputStream(path);
            ServletOutputStream out = response.getOutputStream();
            int len = 0;
            byte[] buf = new byte[1024];
            while ((len = in.read(buf)) > 0) {
                out.write(buf, 0, len);
            }
            in.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    /*---------   文章管理区域（END）   ----------*/
}
