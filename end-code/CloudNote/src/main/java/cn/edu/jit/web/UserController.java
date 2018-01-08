package cn.edu.jit.web;

import cn.edu.jit.dto.ArticleDto;
import cn.edu.jit.entry.*;
import cn.edu.jit.global.GlobalConstant;
import cn.edu.jit.global.GlobalFunction;
import cn.edu.jit.service.*;
import cn.edu.jit.util.ExcelToPdf;
import cn.edu.jit.util.PptToPdf;
import cn.edu.jit.util.Sha1Utils;
import cn.edu.jit.util.WordToPdf;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import sun.misc.BASE64Encoder;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.util.ArrayList;
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

    @Resource(name = "tagServiceImpl")
    private TagService tagService;

    @Resource(name = "articleServiceImpl")
    private ArticleService articleService;

    @Resource(name = "articleTagServiceImpl")
    private ArticleTagService articleTagService;

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
     * @param directoryTree 树根
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
            DirectoryTree dt = new DirectoryTree(article.getId(),article.getTitle());
            dt.setData(null);
            directoryTree.addData(dt);
        }
        for (Directory childDir: childDirs) {
            DirectoryTree dt = new DirectoryTree(childDir.getId(), childDir.getName());
            initDirectoryTree(dt);
            directoryTree.addData(dt);
        }
    }

    /**
     * 将directory及其子目录下所有笔记的目录修改为parentDir目录
     */
    private void changeAllNoteDir(Directory directory, String parentDir) {
        List<Article> articles = articleService.listArticleByDir(getSelfId(), directory.getId());
        for (Article article : articles) {
            article.setDirId(parentDir);
            articleService.update(article);
        }
        List<Directory> directories = directoryService.listByParentId(getSelfId(), directory.getId());
        for (Directory dir : directories) {
            changeAllNoteDir(dir, parentDir);
        }
    }

    private List<Tag> getNoteTag(String noteId) {
        List<Tag> result = new ArrayList<>();
        List<ArticleTagKey> lists = articleTagService.listByArticleId(noteId);
        for (ArticleTagKey articleTag : lists) {
                result.add(tagService.getById(articleTag.getTagId()));
        }
        return result;
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

        return "user/index";
    }

    /*---------   用户管理区域（START）   ----------*/
    /**
     * 验证密码
     */
    @RequestMapping(value = "verifyPassword", method = {RequestMethod.POST})
    public void resetPassword(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        Boolean status = true;
        try {
            String passWord = request.getParameter("password");
            Login login = loginService.getByTel(GlobalFunction.getSelfTel());
            if (!Sha1Utils.validatePassword(passWord, login.getPassword())) {
                status = false;
            }

            Message msg = new Message();
            msg.setStatus(status);
            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 重置密码
     */
    @RequestMapping(value = "resetPassword", method = {RequestMethod.GET})
    public String resetPasswordUI() {
        return "/user/resetPassword";
    }

    @RequestMapping(value = "resetPassword", method = {RequestMethod.POST})
    public String resetPassword(String newPassword) {
        Login login = loginService.getByTel(GlobalFunction.getSelfTel());
        String encryptedPassword = Sha1Utils.entryptPassword(newPassword);
        login.setPassword(encryptedPassword);
        loginService.update(login);

        return "redirect:/logout";
    }


    /*---------   用户管理区域（END）   ----------*/

    /*---------   笔记管理区域（START）   ----------*/

    /**
     * 初始化用户笔记目录树
     */
    @RequestMapping(value = "initDirectory", method = {RequestMethod.GET})
    public void initArticle(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        String uid = getSelfId();
        try {
            // 顶层目录 id:root name:我的文件夹
            DirectoryTree directoryTree = new DirectoryTree("root","我的文件夹");
            initDirectoryTree(directoryTree);
            String data = JSON.toJSONString(directoryTree, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        }catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 创建笔记
     */
    @RequestMapping(value = "createNote", method = {RequestMethod.POST})
    public void createNote(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        Boolean status = true;
        try {
            // 所属目录id
            String dirId = request.getParameter("parentId");
            String noteName = request.getParameter("noteName");
            String id = GlobalFunction.getUUID();
            String articlePath = GlobalConstant.USER_ARTICLE_PATH + "/" + id + "/" + noteName + ".note";

            // 存入数据库
            Article article = new Article();
            article.setTitle(noteName);
            article.setId(id);
            article.setUserId(getSelfId());
            article.setDirId(dirId);
            article.setCreateDate(new Date());
            int i = articleService.save(article);
            if(i != 1) {
                status = false;
            }

            // 创建笔记目录
            GlobalFunction.createPath(articlePath);
            // 初始化笔记内容
            OutputStreamWriter bw = new OutputStreamWriter(new FileOutputStream(articlePath), "UTF-8");
            bw.write(GlobalConstant.ARTICLE_DEFAULT_CONTENT);
            bw.close();

            Message msg = new Message();
            msg.setStatus(status);
            msg.setNoteId(id);
            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        }catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 获取笔记信息
     */
    @RequestMapping(value = "getNoteInfo", method = {RequestMethod.POST})
    public void getNoteInfo(HttpServletRequest request, HttpServletResponse response) {
        try {
            String noteId = request.getParameter("noteId");
            Article article = articleService.getById(noteId);
            ArticleDto articleDto = new ArticleDto();
            if(article != null) {
                BeanUtils.copyProperties(article, articleDto);
                articleDto.setAuthorName(userService.getById(article.getUserId()).getTel());
            }
            String data = JSON.toJSONString(articleDto, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        }catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 重命名笔记
     */
    @RequestMapping(value = "renameNote", method = {RequestMethod.POST})
    public void renameNote(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        Boolean status = true;
        try {
            String noteId = request.getParameter("noteId");
            String noteName = request.getParameter("noteName");
            Article article = articleService.getById(noteId);
            boolean flag = GlobalFunction.renameFile(GlobalConstant.USER_ARTICLE_PATH + "/" + noteId,
                    article.getTitle() + GlobalConstant.NOTE_SUFFIX, noteName + GlobalConstant.NOTE_SUFFIX);
            if (flag) {
                article.setTitle(noteName);
                if (articleService.update(article) != 1) {
                    status = false;
                }
            } else {
                status = false;
            }

            Message msg = new Message();
            msg.setStatus(status);
            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 导入笔记
     */
    @RequestMapping(value = "importNote", method = {RequestMethod.POST})
    public String importNote(HttpServletRequest request, HttpServletResponse response) {
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
                        // 获取上传头像的文件名
                        String fileName = item.getName();
                        // 如果文件名为空，就跳过
                        if (StringUtils.isEmpty(fileName)) {
                            continue;
                        }
                        // 重命名：规定未手机号+后缀作为头像名
                        fileName = GlobalFunction.getSelfTel() + "_note." + fileName.split("\\.")[1];

                        String targetFilePath = GlobalConstant.USER_IMG_PATH + fileName;
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
     * 下载笔记
     */
    @RequestMapping(value = "downloadNote", method = {RequestMethod.GET})
    public void downloadFile(HttpServletRequest request, HttpServletResponse response) {
        String noteId = request.getParameter("noteId");
        // 设置编码（如果文件名乱码，尝试打开解决问题）
        // fileName = new String(fileName.getBytes("ISO8859-1"),"UTF-8");
        String fileName = request.getParameter("noteName");
        fileName = fileName + GlobalConstant.NOTE_SUFFIX;
        try {
            // 得到用于返回给客户端的编码后的文件名
            String agent = request.getHeader("User-Agent");
            String fileNameEncode = solveFileNameEncode(agent, fileName);
            // 客户端判断下载文件类型
            response.setContentType(request.getSession().getServletContext().getMimeType(fileName));
            // 关闭客户端的默认解析
            response.setHeader("Content-Disposition", "attachment;filename=" + fileNameEncode);
            // 获得文件真实下载路径
            String path = GlobalConstant.USER_ARTICLE_PATH + "/" + noteId + "/" + fileName;
            // 下载文件
            GlobalFunction.downloadFile(path, response.getOutputStream());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 保存笔记
     */
    @RequestMapping(value = "saveNote", method = {RequestMethod.POST})
    public void saveNote(HttpServletRequest request, HttpServletResponse response) {
        String noteId = request.getParameter("noteId");
        String noteName = request.getParameter("noteName");
        response.setContentType("text/html;charset=utf-8");
        try {
            // 将数据写入文件
            String content = request.getParameter("data");
            String targetFilePath = GlobalConstant.USER_ARTICLE_PATH + "/" + noteId + "/" + noteName + GlobalConstant.NOTE_SUFFIX;

            OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream(targetFilePath), "UTF-8");
            writer.write(content);
            writer.flush();
            writer.close();

            // 更新数据库
            Article article = articleService.getById(noteId);
           if(article != null) {
               articleService.update(article);
           }

            Message msg = new Message();
            msg.setStatus(true);
            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 删除笔记
     */
    @RequestMapping(value = "removeNote", method = {RequestMethod.POST})
    public void removeNote(HttpServletRequest request, HttpServletResponse response){
        try {
            Boolean status = false;
            String noteId = request.getParameter("noteId");
            ArticleRecycle articleRecycle = new ArticleRecycle();
            Article article = articleService.getById(noteId);
            BeanUtils.copyProperties(article, articleRecycle);
            articleRecycle.setCreateDate(new Date());
            if(articleService.removeById(noteId) == 1 && articleRecycleService.save(articleRecycle) == 1) {
                status = true;
            }

            // 删除文章目录
            String path = GlobalConstant.USER_ARTICLE_PATH  + "/" + noteId;

            FileUtils.deleteQuietly(new File(path));

            Message msg = new Message();
            msg.setStatus(status);
            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        }catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 恢复笔记内容
     */
    @RequestMapping(value = "recoverNote", method = {RequestMethod.POST})
    public void showUserNote(HttpServletRequest request, HttpServletResponse response) {
        char[] buf = new char[1024];
        int len;
        response.setContentType("text/html;charset=utf-8");
        try {
            String noteName = request.getParameter("noteName");
            String noteId = request.getParameter("noteId");
            String targetFilePath = GlobalConstant.USER_ARTICLE_PATH + "/" + noteId + "/" + noteName + GlobalConstant.NOTE_SUFFIX;

            InputStreamReader in = new InputStreamReader(new FileInputStream(targetFilePath), "UTF-8");
            StringBuilder sb = new StringBuilder();

            while ((len = in.read(buf, 0, buf.length)) > 0) {
                sb.append(buf,0,len);
            }
            in.close();

            Message message = new Message();
            message.setInfo(sb.toString());
            message.setName(noteName);
            message.setNoteTag(getNoteTag(noteId));
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 文件转换
     * 支持doc/docx/xls/xlsx/ppt/pptx --> pdf
     */
    @RequestMapping(value = "convertFile", method = {RequestMethod.POST})
    public void convertFile(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        Boolean status;
        String info = null;
        try {
            String[] tmp = request.getParameter("fileName").split("\\.");
            String fileName = tmp[0];
            String suffix = tmp[1];
            String inputPath = GlobalConstant.USER_PAN_PATH + "/" + request.getParameter("fileName");
            String outputPath = GlobalConstant.USER_PAN_PATH + "/" + fileName + ".pdf";
            int i;
            switch (suffix) {
                case "doc":
                case "docx":
                    i = WordToPdf.run(inputPath, outputPath);
                    break;
                case "xls":
                case"xlsx":
                    i = ExcelToPdf.run(inputPath, outputPath);
                    break;
                case "ppt":
                case "pptx":
                    i = PptToPdf.run(inputPath, outputPath);
                    break;
                default:
                    i = -2;
                    break;
            }

            switch (i) {
                case -1:
                    info = "转换失败";
                    status = false;
                    break;
                case -2:
                    info = "格式不支持";
                    status = false;
                    break;
                default:
                    info = String.valueOf(i);
                    status = true;
                    break;
            }
            // status：是否成功；info：成功返回执行秒数，失败返回错误原因
            Message msg = new Message();
            msg.setStatus(status);
            msg.setInfo(info);
            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        }catch (Exception e) {
            e.printStackTrace();
        }
    }
    /*---------   笔记管理区域（END）   ----------*/

    /*---------   目录管理区域（START）   ----------*/

    /**
     * 新建目录
     */
    @RequestMapping(value = "createDir", method = {RequestMethod.POST})
    public void createDir(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        Boolean status = true;
        try {
            String parentId = request.getParameter("parentId");
            String dirName = request.getParameter("dirName");

            Directory directory = new Directory();
            String dirId = GlobalFunction.getUUID();
            directory.setId(dirId);
            directory.setName(dirName);
            directory.setUid(getSelfId());
            directory.setParentId(parentId);
            directory.setCreateDate(new Date());
            int i = directoryService.save(directory);
            if(i != 1) {
                status = false;
            }

            Message msg = new Message();
            msg.setStatus(status);
            msg.setDirId(dirId);
            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        }catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 删除目录
     */
    @RequestMapping(value = "removeDir", method = {RequestMethod.POST})
    public void removeDir(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        Boolean status = true;
        String dirId = request.getParameter("dirId");

        try {
            // 1.将目录及其子目录下所有笔记迁移到父目录中
            Directory directory = directoryService.getById(dirId);
            String parentDir = directory.getParentId();
            changeAllNoteDir(directory, parentDir);

            // 2.删除目录及其子目录
            int i = directoryService.remove(dirId);
            if(i != 1) {
                status = false;
            }

            Message msg = new Message();
            msg.setStatus(status);
            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 重命名目录
     */
    @RequestMapping(value = "renameDir", method = {RequestMethod.POST})
    public void renameDir(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        Boolean status = true;
        try {
            String dirId = request.getParameter("dirId");
            String dirName = request.getParameter("dirName");
            Directory directory = directoryService.getById(dirId);
            directory.setName(dirName);
            int i = directoryService.update(directory);
            if(i != 1) {
                status = false;
            }

            Message msg = new Message();
            msg.setStatus(status);
            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /*---------   目录管理区域（END）   ----------*/
}