package cn.edu.jit.web;

import cn.edu.jit.entry.User;
import cn.edu.jit.global.GlobalFunction;
import cn.edu.jit.service.ArticleService;
import cn.edu.jit.service.UserService;
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

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.Date;
import java.util.List;

/**
 * 用户控制
 *
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
     *
     * @return
     */
    public String getSelfId() {
        User user = userService.getByTel(GlobalFunction.getSelfTel());
        return user.getId();
    }

    public void parserUser(User user, String key, String value) {
        switch (key) {
            case "id":
                BeanUtils.copyProperties(userService.getById(value),user);
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

    /*---------   普通方法区域（END）   ----------*/

    @RequestMapping(value = "index")
    public String indexUI(HttpServletRequest request) {
        request.setAttribute("uid", getSelfId());
        return "user/index";
    }

    /*---------   用户管理区域（START）   ----------*/

    @RequestMapping(value = "showUserInfo", method = {RequestMethod.POST})
    public void showUserInfo(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=utf-8");
        String id = request.getParameter("id");
        User user = userService.getById(id);

        String data = JSON.toJSONString(user, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
        response.getWriter().write(data);
    }

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
                            if(StringUtils.isEmpty(fileName)) {
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
                        if(StringUtils.isEmpty(fileName)) {
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

    /*---------   用户管理区域（END）   ----------*/

    /*---------   文章管理区域（START）   ----------*/

    /**
     * 保存笔记
     * @param request
     * @param response
     */
    @RequestMapping(value = "/saveArticle", method = {RequestMethod.POST})
    public void saveArticle(HttpServletRequest request, HttpServletResponse response) {
        String upload_path = request.getSession().getServletContext().getRealPath("upload"); // 获取upload文件夹路径
        response.setContentType("text/html;charset=utf-8");
        try {
//        String articleId = request.getParameter("id");
            String content = request.getParameter("data");
            String targetFilePath = upload_path + "/" + GlobalFunction.getSelfTel() + "/" + "111.txt";

            File file = new File(targetFilePath);
            if (!file.getParentFile().exists()) {
                file.getParentFile().mkdirs();
            }

            OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream(targetFilePath),"UTF-8");
            System.out.println(content);
            writer.write(content);
            writer.flush();
            writer.close();
            response.getWriter().write("{\"res\":" + true + "}");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "/removeArticle", method = {RequestMethod.GET})
    public void removeArticle(String id) {
        articleService.removeById(id);
    }

    /**
     * 恢复笔记
     * @param request
     * @param response
     */
    @RequestMapping(value = "/showUserNote", method = {RequestMethod.POST})
    public void showUserNote(HttpServletRequest request, HttpServletResponse response) {
      try {
          char[] buf = new char[1024];
          int len;
          response.setContentType("text/html;charset=utf-8");
          String upload_path = request.getSession().getServletContext().getRealPath("upload");
          String targetFilePath = upload_path+"/"+GlobalFunction.getSelfTel()+"/111.txt";

          InputStreamReader reader = new InputStreamReader(new FileInputStream(targetFilePath),"UTF-8");

          while ((len = reader.read(buf, 0, 1024)) > 0) {
              response.getWriter().write(buf,0,len);
          }
          reader.close();
      } catch (IOException e) {
         e.printStackTrace();
      }
    }

    /**
     * 下载笔记
     * @param request
     * @param response
     */
    @RequestMapping(value = "/downloadNote", method = {RequestMethod.POST})
    public void downloadNote(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        String upload_path = request.getSession().getServletContext().getRealPath("upload");
        String targetFilePath = upload_path+"/"+GlobalFunction.getSelfTel()+"/111.txt";
        try {
            response.getWriter().write(targetFilePath);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    /*---------   文章管理区域（END）   ----------*/
}
