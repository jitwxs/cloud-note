package cn.edu.jit.web;

import cn.edu.jit.entry.*;
import cn.edu.jit.global.GlobalFunction;
import cn.edu.jit.service.*;
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
import java.util.Date;
import java.util.List;

/**
 * 用户控制层
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

    @Resource (name = "articleRecycleServiceImpl")
    private ArticleRecycleService articleRecycleService;

    @Resource (name = "directoryServiceImpl")
    private DirectoryService directoryService;

    @Resource(name = "loginServiceImpl")
    private LoginService loginService;


    /*---------   普通方法区域（START）   ----------*/

    /**
     * 获取登陆用户id
     */
    private String getSelfId() {
        User user = userService.getByTel(GlobalFunction.getSelfTel());
        return user.getId();
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

    /**
     * 生成目录树
     */
    private void initDirectoryTree(DirectoryTree directoryTree) {
        String uid = getSelfId();
        String dirId = directoryTree.getId();

        List<Directory> childDirs = directoryService.listByParentId(uid, dirId);
        List<Article> articles = articleService.listArticleByDir(uid, dirId);
        if(childDirs.size() ==0 && articles.size() == 0) {
            return;
        }
        for (Article article: articles) {
            directoryTree.addData(new DirectoryTree(article.getId(), article.getTitle()));
        }
        for (Directory childDir: childDirs) {
            DirectoryTree dt = new DirectoryTree(childDir.getId(), childDir.getName());
            initDirectoryTree(dt);
            directoryTree.addData(dt);
        }
    }
    /*---------   普通方法区域（END）   ----------*/

    @RequestMapping(value = "index")
    public String indexUI(HttpServletRequest request) {
        request.setAttribute("uid", getSelfId());
        return "user/index";
    }

    /*---------   用户管理区域（START）   ----------*/
    /**
     * 重置密码
     */
    @RequestMapping(value = "resetPassword", method = {RequestMethod.POST})
    public void resetPassword(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        int status = 0;
        try {
//            String tel = request.getParameter("tel");
            String password = request.getParameter("password");
            Login login = loginService.getByTel("13260908721");
            if (!Sha1Utils.validatePassword(password, login.getPassword())) {
                status = 1;
            } else {
                String newPassword = request.getParameter("newPassword");
                String encryptedPassword = Sha1Utils.entryptPassword(newPassword);
                login.setPassword(encryptedPassword);
                login.setModifiedDate(new Date());
                if (loginService.update(login) != 1) {
                    status = 2;
                } else {
                    status = 3;
                }
            }
            response.getWriter().write(status);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /*---------   用户管理区域（END）   ----------*/

    /*---------   笔记管理区域（START）   ----------*/

    /**
     * 初始化目录树
     */
    @RequestMapping(value = "/initDirectory", method = {RequestMethod.GET})
    public void initArticle(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        String uid = getSelfId();
        try {
            // 获取顶层目录
            DirectoryTree directoryTree = new DirectoryTree("","我的文件夹");
            initDirectoryTree(directoryTree);
            String data = JSON.toJSONString(directoryTree, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        }catch (IOException e) {
            e.printStackTrace();
        }
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
     * 删除笔记
     */
    @RequestMapping(value = "/removeArticle", method = {RequestMethod.POST})
    public void removeArticle(HttpServletRequest request, HttpServletResponse response){
        try {
            Boolean status = false;
            String id = request.getParameter("id");
            ArticleRecycle articleRecycle = new ArticleRecycle();
            Article article = articleService.getById("1");
            BeanUtils.copyProperties(article, articleRecycle);
            if(articleService.removeById("1") == 1 && articleRecycleService.save(articleRecycle) == 1) {
                status = true;
            }
            response.getWriter().write("{\"status\":" + status + "}");
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
    /*---------   笔记管理区域（END）   ----------*/
}
