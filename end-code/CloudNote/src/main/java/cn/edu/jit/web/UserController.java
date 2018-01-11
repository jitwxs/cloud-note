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
import java.util.*;

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

    @Resource(name = "articleAffixServiceImpl")
    private ArticleAffixService articleAffixService;

    @Resource (name = "articleRecycleServiceImpl")
    private ArticleRecycleService articleRecycleService;

    @Resource (name = "fileConvertServiceImpl")
    private FileConvertService fileConvertService;

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

    /**
     * 获取笔记所有标签
     */
    private List<Tag> getNoteTag(String noteId) {
        List<Tag> result = new ArrayList<>();
        List<ArticleTagKey> lists = articleTagService.listByArticleId(noteId);
        for (ArticleTagKey articleTag : lists) {
                result.add(tagService.getById(articleTag.getTagId()));
        }
        return result;
    }

    /**
     * 创建笔记分享页面
     * @param noteId 笔记id
     * @param noteName 笔记名称
     * @return 页面再程序的真实url
     */
    private String createSharePage(String noteId, String noteName) throws IOException{
        int len;
        char[] buf = new char[1024];
        String temp;
        String dirPath = GlobalConstant.USER_ARTICLE_PATH + "/" + noteId;
        String inputPath = dirPath + "/" + noteName + GlobalConstant.NOTE_SUFFIX;
        String outputPath = dirPath + "/" + noteName + ".html";

        BufferedReader br = new BufferedReader(new FileReader(GlobalConstant.SHARE_TEMPLATE));
        InputStreamReader isr = new InputStreamReader(new FileInputStream(inputPath), "UTF-8");
        OutputStreamWriter osw = new OutputStreamWriter(new FileOutputStream(outputPath),"UTF-8");

        while((temp = br.readLine()) != null) {
            osw.write(temp);
            // 加入标题和正文
            if("\t<title>".equals(temp)) {
                osw.write(noteName);
            } else if ("<body>".equals(temp)) {
                while((len = isr.read(buf)) > 0) {
                    osw.write(buf, 0, len);
                }
            }
            osw.flush();
        }
        br.close();
        isr.close();
        osw.close();
        return outputPath;
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
            String articleDir = GlobalConstant.USER_ARTICLE_PATH + "/" + id;
            String articlePath = articleDir + "/" + noteName + ".note";

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
            GlobalFunction.createDir(articleDir);
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
        response.setContentType("text/html;charset=utf-8");
        String noteId = request.getParameter("noteId");
        try {
            Article article = articleService.getById(noteId);
            Message message = new Message();
            ArticleDto articleDto = new ArticleDto();
            if(article == null) {
                message.setStatus(false);
            } else {
                message.setStatus(true);
                BeanUtils.copyProperties(article, articleDto);
                articleDto.setAuthorName(userService.getById(article.getUserId()).getTel());
                message.setArticleDto(articleDto);
            }
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
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
     * 上传笔记
     */
    @RequestMapping(value = "uploadNote", method = {RequestMethod.POST})
    public String uploadNote(HttpServletRequest request, HttpServletResponse response) {
        try {
            DiskFileItemFactory factory = new DiskFileItemFactory(1024 * 1024, new File(GlobalConstant.TEMP_PATH));
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setHeaderEncoding("UTF-8");

            if (ServletFileUpload.isMultipartContent(request)) {
                List<FileItem> fileItems = upload.parseRequest(request);
                if (fileItems.size() != 0) {
                    for (FileItem item : fileItems) {
                        String fileName = item.getName();
                        if (StringUtils.isEmpty(fileName)) {
                            continue;
                        }

                        fileName =fileName.split("\\.")[0];
                        String id = GlobalFunction.getUUID();
                        String dirPath = GlobalConstant.USER_ARTICLE_PATH + "/" + id;
                        String filePath = dirPath + "/" + fileName + GlobalConstant.NOTE_SUFFIX;

                        // 存入服务器
                        GlobalFunction.createDir(dirPath);
                        GlobalFunction.uploadFile(item, filePath);

                        // 加入数据库
                        Article article = new Article();
                        article.setId(id);
                        article.setUserId(getSelfId());
                        article.setTitle(fileName);
                        article.setDirId(GlobalConstant.ROOT_DIR);
                        article.setCreateDate(new Date());
                        articleService.save(article);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:index";
    }

    /**
     * 下载笔记
     */
    @RequestMapping(value = "downloadNote", method = {RequestMethod.GET})
    public void downloadNote(HttpServletRequest request, HttpServletResponse response) {
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
        Message message = new Message();
        Boolean status = true;
        response.setContentType("text/html;charset=utf-8");
        try {
            // 将数据写入文件
            String content = request.getParameter("data");
            String targetFilePath = GlobalConstant.USER_ARTICLE_PATH + "/" + noteId + "/" + noteName + GlobalConstant.NOTE_SUFFIX;

            OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream(targetFilePath), "UTF-8");
            writer.write(content);
            writer.flush();
            writer.close();

            // 更新笔记数据库
            Article article = articleService.getById(noteId);
           if(article == null) {
               status = false;
           } else {
               articleService.update(article);
           }

            String editorTags = request.getParameter("tag");
            if(!StringUtils.isEmpty(editorTags)) {
                // 移除笔记原有标签
                articleTagService.removeAllByArticleId(noteId);
                // 获取笔记新标签
                String[] editorTag = editorTags.trim().split("\\s+");
                for (String tagName : editorTag) {
                    String tagId;

                    Tag tmpTag = tagService.getByName(tagName);
                    //查询是否已存在此标签，不存在则保存新标签
                    if (tmpTag == null) {
                        Tag tag = new Tag();
                        tag.setName(tagName);
                        tagId = GlobalFunction.getUUID();
                        tag.setId(tagId);
                        tag.setCreateDate(new Date());
                        tagService.save(tag);
                    } else {
                        tagId = tmpTag.getId();
                    }

                    ArticleTagKey articleTagKey = new ArticleTagKey();
                    articleTagKey.setArticleId(noteId);
                    articleTagKey.setTagId(tagId);
                    articleTagService.save(articleTagKey);
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
     * 恢复笔记
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

            // 获取文件内容
            InputStreamReader in = new InputStreamReader(new FileInputStream(targetFilePath), "UTF-8");
            StringBuilder sb = new StringBuilder();

            while ((len = in.read(buf, 0, buf.length)) > 0) {
                sb.append(buf,0,len);
            }
            in.close();

            // 获取所有附件
            List<ArticleAffix> affixes = articleAffixService.listByArticleId(noteId);

            Message message = new Message();
            message.setInfo(sb.toString());
            message.setName(noteName);
            message.setNoteTag(getNoteTag(noteId));
            message.setAffixes(affixes);
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 分享笔记
     */
    @RequestMapping(value = "shareNote", method = {RequestMethod.POST})
    public void shareNote(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        String noteId = request.getParameter("noteId");
        String noteName = request.getParameter("noteName");
        Message message = new Message();
        Boolean status = false;
        try {
            Article article = articleService.getById(noteId);
            if(article != null) {
                // 如果文章已经分享，无需再次分享
                if(article.getIsOpen() == GlobalConstant.ARTICLE_STATUS.SHARE.getIndex()) {
                    status = true;
                    message.setInfo(article.getShareUrl());
                } else if(article.getIsOpen() == GlobalConstant.ARTICLE_STATUS.NOT_SHARE.getIndex()) {
                    String url = createSharePage(noteId, noteName);
                    if(!StringUtils.isEmpty(url)) {
                        status = true;
                        message.setInfo(url);

                        // 更新数据库
                        article.setIsOpen(GlobalConstant.ARTICLE_STATUS.SHARE.getIndex());
                        article.setShareUrl(url);
                        articleService.update(article);
                    }
                }
            }
            message.setStatus(status);
            message.setNoteId(noteId);
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 取消分享笔记
     */
    @RequestMapping(value = "cancelShare", method = {RequestMethod.POST})
    public void cancelShare(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        String noteId = request.getParameter("noteId");
        String url = request.getParameter("url");
        Message message = new Message();
        try {
            // 删除分享文件
            GlobalFunction.deleteSignalFile(url);
            // 更新数据库
            Article article = articleService.getById(noteId);
            article.setShareUrl(null);
            article.setIsOpen(GlobalConstant.ARTICLE_STATUS.NOT_SHARE.getIndex());
            articleService.update(article);
            message.setStatus(true);
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 查看个人分享笔记
     */
    @RequestMapping(value = "showSelfShareNote", method = {RequestMethod.GET})
    public void showSelfShareNote(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        try {
            String userId = getSelfId();
            List<Article> lists = articleService.listArticleByShare(userId);
            Message message = new Message();
            if(lists.size() == 0) {
                message.setStatus(false);
            } else {
                message.setStatus(true);
                message.setArticles(lists);
            }

            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        }catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 查看其他人分享的笔记
     */
    public void showOtherShareNote(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset-utf-8");
        try {
            String userId = getSelfId();
            List<Article> lists = articleService.listAnotherShareArticle(userId);
            Message message = new Message();
            if(lists.size() == 0) {
                message.setStatus(false);
            } else {
                message.setStatus(true);
                List<ArticleDto> articleDtos = new ArrayList<>();
                for (Article article : lists) {
                  ArticleDto articleDto = new ArticleDto();
                  BeanUtils.copyProperties(article, articleDto);
                  articleDto.setAuthorName(userService.getById(article.getUserId()).getTel());
                  articleDtos.add(articleDto);
                }
                message.setArticleDtos(articleDtos);
            }

            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 删除附件
     */
    @RequestMapping(value = "removeAffix", method = {RequestMethod.POST})
    public void removeAffix(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        Boolean status = false;
        String affixId = request.getParameter("affixId");
        try {
            if (affixId != null) {
                ArticleAffix articleAffix = articleAffixService.getById(affixId);
                if(articleAffix != null) {
                    // 删除存在服务器上的文件
                    GlobalFunction.deleteSignalFile(articleAffix.getPath());
                    // 删除记录
                    articleAffixService.removeById(affixId);
                    status = true;
                }
            }
            Message message = new Message();
            message.setStatus(status);
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        }catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 上传附件
     */
    @RequestMapping(value = "uploadAffix", method = {RequestMethod.POST})
    public void uploadAffix(HttpServletRequest request, HttpServletResponse response) {
        String path = null;
        String noteId = null;
        try {
            DiskFileItemFactory factory = new DiskFileItemFactory(1024 * 1024, new File(GlobalConstant.TEMP_PATH));

            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setHeaderEncoding("UTF-8");

            if (ServletFileUpload.isMultipartContent(request)) {
                List<FileItem> fileItems = upload.parseRequest(request);
                if (fileItems.size() != 0) {
                    for (FileItem item : fileItems) {
                        if (item.isFormField()) {
                            String fieldName = item.getFieldName();
                            String fieldValue = item.getString("UTF-8");
                            // 此处fieldName即为noteId,如果获取失败，就没有上传附件的意义
                            if(StringUtils.isEmpty(fieldName)) {
                                break;
                            } else {
                                noteId = fieldValue;
                            }
                        } else {
                            if(!StringUtils.isEmpty(noteId)) {
                                String fileName = item.getName();
                                // 如果文件名为空，就跳过
                                if (StringUtils.isEmpty(fileName)) {
                                    continue;
                                }
                                // 上传文件
                                path = GlobalConstant.USER_ARTICLE_PATH + "/" + noteId + "/" + fileName;
                                GlobalFunction.uploadFile(item, path);

                                //存入数据库
                                ArticleAffix articleAffix = new ArticleAffix();
                                articleAffix.setId(GlobalFunction.getUUID());
                                articleAffix.setArticleid(noteId);
                                articleAffix.setName(fileName);
                                articleAffix.setPath(path);
                                articleAffix.setCreateTime(new Date());
                                articleAffixService.save(articleAffix);
                            }
                        }
                    }
                }
                response.sendRedirect("/user/index");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * 预览附件
     */
    @RequestMapping(value = "previewAffix", method = {RequestMethod.POST})
    public void previewAffix(HttpServletRequest request, HttpServletResponse response) {
        String affixId = request.getParameter("affixId");
        Message message = new Message();
        response.setContentType("text/html;charset=utf-8");
       try {
           if(affixId == null) {
               message.setStatus(false);
           } else {
               ArticleAffix articleAffix = articleAffixService.getById(affixId);
               String tmp = articleAffix.getPath();

               // 判断文件名不是以.pdf或.PDF结尾
               boolean flag = tmp.endsWith(".pdf") || tmp.endsWith(".PDF");
               if(flag) {
                   // 如果是，直接预览即可
                   int i = tmp.indexOf("upload");
                   String url = "generic/web/viewer.html?file=/" + tmp.substring(i);
                   message.setInfo(url);
                   message.setStatus(true);
               } else {
                   // 如果不是，判断是否已经被转换了
                   FileConvert fileConvert = fileConvertService.getById(affixId);
                   if(fileConvert == null) {
                       // 如果没有被转换，无法预览
                       message.setStatus(false);
                   } else {
                       // 如果转换了，预览转换后的文件
                       String convertedPath = fileConvert.getPath();
                       int i = convertedPath.indexOf("upload");
                       String url = "generic/web/viewer.html?file=/" + convertedPath.substring(i);
                       message.setInfo(url);
                       message.setStatus(true);
                   }
               }
           }
           String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
           response.getWriter().write(data);
       }catch (IOException e) {
           e.printStackTrace();
       }
    }
    /**
     * PDF转换
     * 支持格式：doc、docx、xls、xlsx、ppt、pptx
     */
    @RequestMapping(value = "convertFile", method = {RequestMethod.POST})
    public void convertFile(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        Message msg = new Message();
        Boolean status;
        String info = null;
        try {
            // 转换前判断是否已经被转换过了
            String affixId = request.getParameter("affixId");
            FileConvert fileConvert = fileConvertService.getById(affixId);

            // 如果存在，则直接返回即可
            if(fileConvert != null) {
                msg.setStatus(true);
                String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
                response.getWriter().write(data);
            } else {
                // 如果不存在，转换
                ArticleAffix articleAffix = articleAffixService.getById(affixId);
                String name = articleAffix.getName();
                String[] tmp = name.split("\\.");
                String fileName = tmp[0];
                String suffix = tmp[1];

               String articleId = articleAffix.getArticleid();

                String inputPath = GlobalConstant.USER_ARTICLE_PATH + "/" + articleId + "/" + name;
                String outputPath = GlobalConstant.USER_ARTICLE_PATH + "/" + articleId + "/" + fileName + ".pdf";
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

                // 如果转换成功，存入FileConvert表
                if(status) {
                    FileConvert fc = new FileConvert();
                    fc.setAffixId(affixId);
                    fc.setPath(outputPath);
                    fileConvertService.save(fc);
                }

                // status：是否成功；info：成功返回执行秒数，失败返回错误原因
                msg.setStatus(status);
                msg.setInfo(info);
                String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
                response.getWriter().write(data);
            }

        }catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 模糊匹配笔记名、标签名、笔记内容
     */
    @RequestMapping(value = "nbSearch", method = {RequestMethod.POST})
    public void nbSearch(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        String content = request.getParameter("content");
        try {
            Message message = new Message();
            if(StringUtils.isEmpty(content)) {
                message.setStatus(false);
            } else {
                // 查询笔记名
                List<Article> listByName = articleService.listArticleByTitle(getSelfId(),content);
                // 查询笔记标签
                List<Article> listByTitle = articleService.listArticleByTagName(getSelfId(),content);
                //TODO 加上文件内容搜索

                message.setStatus(true);
            }
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        }catch (IOException e) {
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