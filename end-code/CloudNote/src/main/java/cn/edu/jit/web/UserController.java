package cn.edu.jit.web;

import cn.edu.jit.dto.ArticleDto;
import cn.edu.jit.entry.*;
import cn.edu.jit.exception.CustomException;
import cn.edu.jit.global.GlobalConstant;
import cn.edu.jit.global.GlobalFunction;
import cn.edu.jit.service.*;
import cn.edu.jit.util.*;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;
import jdk.nashorn.internal.objects.Global;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.aspectj.weaver.ast.Not;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import sun.misc.BASE64Encoder;

import javax.annotation.Resource;
import javax.jws.WebParam;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.text.DecimalFormat;
import java.util.*;

/**
 * 用户控制层
 *
 * @author jitwxs
 * @date 2018/1/3 13:10
 */

@Controller
@RequestMapping(value = "/user")
public class UserController {

    @Resource(name = "logServiceImpl")
    private LogService logService;

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

    @Resource(name = "articleDirServiceImpl")
    private ArticleDirService articleDirService;

    @Resource(name = "articleRecycleServiceImpl")
    private ArticleRecycleService articleRecycleService;

    @Resource(name = "fileConvertServiceImpl")
    private FileConvertService fileConvertService;

    @Resource(name = "loginServiceImpl")
    private LoginService loginService;

    @Resource(name = "userPanServiceImpl")
    private UserPanService userPanService;

    @Resource(name = "panDirServiceImpl")
    private PanDirService panDirService;

    @Resource(name = "notifyServiceImpl")
    private NotifyService notifyService;

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
     * 生成笔记目录树
     *
     * @param directoryTree 树根
     */
    private void initDirectoryTree(DirectoryTree directoryTree) {
        String uid = getSelfId();
        String dirId = directoryTree.getId();

        List<ArticleDir> childDirs = articleDirService.listByParentId(uid, dirId, "create_date desc");
        List<Article> articles = articleService.listArticleByDir(uid, dirId, "create_date desc");
        if (childDirs.size() == 0 && articles.size() == 0) {
            return;
        }
        for (Article article : articles) {
            DirectoryTree dt = new DirectoryTree(article.getId(), article.getTitle());
            dt.setData(null);
            directoryTree.addData(dt);
        }
        for (ArticleDir childDir : childDirs) {
            DirectoryTree dt = new DirectoryTree(childDir.getId(), childDir.getName());
            initDirectoryTree(dt);
            directoryTree.addData(dt);
        }
    }

    /**
     * 生成移动笔记目录树
     *
     * @param directoryTree 树根
     */
    private void moveDirectoryTree(DirectoryTree directoryTree) {
        String uid = getSelfId();
        String dirId = directoryTree.getId();

        List<ArticleDir> childDirs = articleDirService.listByParentId(uid, dirId, "create_date desc");
        for (ArticleDir childDir : childDirs) {
            DirectoryTree dt = new DirectoryTree(childDir.getId(), childDir.getName());
            moveDirectoryTree(dt);
            directoryTree.addData(dt);
        }
    }

    /**
     * 生成云盘目录树
     *
     * @param directoryTree 树根
     */
    private void initPanDirectoryTree(DirectoryTree directoryTree) {
        String uid = getSelfId();
        String dirId = directoryTree.getId();

        List<PanDir> childDirs = panDirService.listByParentId(uid, dirId);
        List<UserPan> userPans = userPanService.listUserPanByDir(uid, dirId);
        if (childDirs.size() == 0 && userPans.size() == 0) {
            return;
        }
        for (UserPan userPan : userPans) {
            DirectoryTree dt = new DirectoryTree(userPan.getId(), userPan.getName());
            dt.setData(null);
            directoryTree.addData(dt);
        }
        for (PanDir childDir : childDirs) {
            DirectoryTree dt = new DirectoryTree(childDir.getId(), childDir.getName());
            initPanDirectoryTree(dt);
            directoryTree.addData(dt);
        }
    }

    /**
     * 递归删除云盘目录
     */
    private boolean deletePanFile(String dirId) {
        List<UserPan> userPans = userPanService.listUserPanByDir(getSelfId(), dirId);
        List<PanDir> panDirs = panDirService.listByParentId(getSelfId(), dirId);
        for (UserPan userPan : userPans) {
            String path = GlobalConstant.USER_PAN_PATH + "/" + userPan.getName();
            if (GlobalFunction.deleteSignalFile(path)) {
                userPanService.removeById(userPan.getId());
            } else {
                return false;
            }
        }
        for (PanDir panDir : panDirs) {
            deletePanFile(panDir.getId());
        }
        panDirService.remove(dirId);
        return true;
    }

    /**
     * 获取笔记摘要（用于分享页面的摘要）
     */
    private String getAbstractText(ArticleDto articleDto) {
        StringBuilder result = new StringBuilder();
        String indexStr = "<!-- content -->";
        try {
            char[] buf = new char[1024];
            boolean flag = true;

            String url = articleDto.getShareUrl();
            InputStreamReader isr = new InputStreamReader(new FileInputStream(url), "UTF-8");

            while (isr.read(buf, 0, buf.length) > 0 && result.length() <= GlobalConstant.NOTE_ABSTRACT_LENGTH) {
                String temp = String.valueOf(buf);
                if (!flag) {
                    result.append(GlobalFunction.getHtmlText(temp));
                } else if (flag && temp.contains(indexStr)) {
                    result.append(GlobalFunction.getHtmlText(temp.substring(temp.indexOf(indexStr))));
                    flag = false;
                }
            }
            isr.close();
            int len = GlobalConstant.NOTE_ABSTRACT_LENGTH >= result.length() ? result.length() : GlobalConstant.NOTE_ABSTRACT_LENGTH;
            return result.substring(0, len);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    /**
     * 获取笔记摘要（用于搜索结果的摘要）
     */
    private String getAbstractText(String noteId) throws IOException {
        String content;
        String filePath = GlobalConstant.USER_ARTICLE_PATH + "/" + noteId;

        InputStreamReader isr = new InputStreamReader(new FileInputStream(filePath), "UTF-8");
        StringBuilder contentBuilder = new StringBuilder();
        char[] buf = new char[1024];
        while (isr.read(buf, 0, buf.length) > 0) {
            String temp = String.valueOf(buf);
            contentBuilder.append(temp);
        }
        isr.close();

        content = GlobalFunction.getHtmlText(contentBuilder.toString());
        content = content.substring(0,Math.min(content.length(), GlobalConstant.NOTE_ABSTRACT_LENGTH));

        return content;
    }

    /**
     * 将directory及其子目录下所有笔记的目录修改为parentDir目录
     */
    private void changeAllNoteDir(ArticleDir directory, String parentDir) {
        List<Article> articles = articleService.listArticleByDir(getSelfId(), directory.getId(), null);
        for (Article article : articles) {
            article.setDirId(parentDir);
            articleService.update(article);
        }
        List<ArticleDir> directories = articleDirService.listByParentId(getSelfId(), directory.getId(), null);
        for (ArticleDir dir : directories) {
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
     *
     * @param noteId     笔记id
     * @param outputPath 输出路径（空代表新建，非空代表更新）
     * @return 输出路径
     */
    private String createSharePage(String noteId, String outputPath) throws IOException {
        int len;
        char[] buf = new char[1024];
        String temp;

        // 获取笔记标题和作者
        Article article = articleService.getById(noteId);
        String title = article.getTitle();
        User user = userService.getById(article.getUserId());
        String author = user.getName();
        String createDate = GlobalFunction.getDate2Day(article.getCreateDate());
        String iconUrl = user.getIcon();
        String iconRealUrl = GlobalFunction.getRealUrl(iconUrl);

        // 获取所有附件
        List<ArticleAffix> affixes = articleAffixService.listByArticleId(noteId);

        String inputPath = GlobalConstant.USER_ARTICLE_PATH + "/" + noteId;

        // 如果输出路径为空，则新建笔记分享页面，否则更新到输出路径中
        if (StringUtils.isBlank(outputPath)) {
            outputPath = GlobalConstant.USER_SHARE_PATH + "/" + noteId + ".html";
        }

        BufferedReader br = new BufferedReader(new FileReader(GlobalConstant.SHARE_TEMPLATE));
        InputStreamReader isr = new InputStreamReader(new FileInputStream(inputPath), "UTF-8");
        OutputStreamWriter osw = new OutputStreamWriter(new FileOutputStream(outputPath), "UTF-8");

        while ((temp = br.readLine()) != null) {
            osw.write(temp);
            switch (temp.trim()) {
                case "<!-- title -->":
                case "<title>":
                    osw.write(title);
                    osw.write("\n<input type=\"hidden\" id=\"ctx\" value=\""+GlobalConstant.SER_URL+"\">");
                    break;
                case "<!-- userIcon -->":
                    if (!StringUtils.isBlank(iconRealUrl)) {
                        osw.write("<img class='user_icon' style='width: 50px;height: 50px;border-radius:50%' src=" + iconRealUrl + ">");
                    }
                    break;
                case "<!-- userName -->":
                    osw.write(author);
                    break;
                case "<!-- create_date -->":
                    osw.write(createDate);
                    break;
                case "<!-- noteId -->":
                    osw.write(noteId);
                    break;
                case "<!-- content -->":
                    while ((len = isr.read(buf)) > 0) {
                        osw.write(buf, 0, len);
                    }
                    osw.write("<hr>");
                    if(affixes.size() != 0) {
                        osw.write("\n<div style=\"margin-top: 50px\">\n");
                        osw.write("<table class=\"table table-responsive\">\n");
                        osw.write("<thead>\n<tr>\n<th colspan=\"2\" style=\"text-align:center\">附件列表</th>\n</tr>\n</thead>");
                        osw.write("<tbody>\n");
                        for(ArticleAffix articleAffix : affixes) {
                            String name = articleAffix.getName();
                            String url = GlobalFunction.getRealUrl(articleAffix.getPath());
                            osw.write("<tr>\n");
                            osw.write("<td>"+name+"</td>\n");
                            osw.write("<td style=\"text-align:right\"><a class=\"btn btn-info btn-sm\" href=\""+url+"\" target=\"_blank\">查看</a></td>\n");
                        }
                        osw.write("</tbody>\n</table>\n</div>\n");
                    }
                    break;
                case "<!-- footer -->":
                    osw.write("\n<div class=\"footer_text\"><a class=\"footer\"  href=\"http://www.miitbeian.gov.cn/\">苏 ICP 备 16061429 号</a></div>\n");
                    osw.write("<div class=\"footer_text\">Designed By <a class=\"footer\" >无道云笔记团队 </a>&copy; 2018</div>\n");
                    osw.write("<div class=\"footer_text\">邮箱：jitwxs@foxmail.com | 地址：南京市江宁区弘景大道99号</div>");
                    break;
                default:
                    break;
            }
            osw.write("\n");
            osw.flush();
        }
        br.close();
        isr.close();
        osw.close();
        return outputPath;
    }

    /**
     * 随机取num个从0到maxVal的整数。包括零，不包括maxValue
     */
    public static List<Integer> random(int num, int maxValue) {
        if (num > maxValue) {
            num = maxValue;
        }
        if (num < 0 || maxValue < 0) {
            throw new RuntimeException("num or maxValue must be greater than zero");
        }
        List<Integer> result = new ArrayList<Integer>(num);

        int[] tmpArray = new int[maxValue];
        for (int i = 0; i < maxValue; i++) {
            tmpArray[i] = i;
        }

        Random random = new Random();
        for (int i = 0; i < num; i++) {
            int index = random.nextInt(maxValue - i);
            int tmpValue = tmpArray[index];
            result.add(tmpValue);
            int lastIndex = maxValue - i - 1;
            if (index == lastIndex) {
                continue;
            } else {
                tmpArray[index] = tmpArray[lastIndex];
            }

        }


        return result;
    }

    /*---------   普通方法区域（END）   ----------*/

    @RequestMapping(value = "index")
    public String index(@ModelAttribute("id") String id, HttpServletRequest request, HttpServletResponse response) {
        String data = GlobalFunction.getDate2Second(null);
        data = data.replace(' ', '#');
        Cookie cookie = new Cookie("lastLoginTime", data);
        // 登录时间保存30天
        cookie.setMaxAge(60 * 60 * 24 * 30);
        response.addCookie(cookie);

        Cookie[] cookies = request.getCookies();
        String result = "";
        if (cookies.length > 0) {
            for (Cookie ck : cookies) {
                if ("lastLoginTime".equals(ck.getName())) {
                    String lastLoginTime = ck.getValue();
                    result = "上次登陆：" + lastLoginTime.replace('#', ' ');
                }
            }
        } else {
            result = "上次登陆：未知";
        }

        // 是否显示登陆信息
        if (GlobalConstant.HAS_SHOW_LOGIN_INFO) {
            request.setAttribute("lastLoginTime", result);
            GlobalConstant.HAS_SHOW_LOGIN_INFO = false;
        }

        // 搜索结果回显
        if(!StringUtils.isEmpty(id)) {
            String name = articleService.getById(id).getTitle();
            request.setAttribute("searchResId", id);
            request.setAttribute("searchResName", name);
        }

        return "user/index";
    }

    /*---------   用户管理区域（START）   ----------*/

    /**
     * 账户信息
     */
    @RequestMapping(value = "accountInfo", method = {RequestMethod.GET})
    public String accountInfoUI() {
        return "/user/accountInfo";
    }

    /**
     * 账户分享
     */
    @RequestMapping(value = "accountShare", method = {RequestMethod.GET})
    public String accountShareUI() {
        return "/user/accountShare";
    }

    /**
     * 个人网盘
     */
    @RequestMapping(value = "disk", method = {RequestMethod.GET})
    public String diskUI() {
        return "/user/accountDisk";
    }

    @RequestMapping(value = "resetPassword", method = {RequestMethod.POST})
    public String resetPassword(String newPassword, HttpServletRequest request) {
        Login login = loginService.getByTel(GlobalFunction.getSelfTel());
        String encryptedPassword = Sha1Utils.entryptPassword(newPassword);
        login.setPassword(encryptedPassword);
        loginService.update(login);

        // 保存日志
        logService.saveLog(request, GlobalConstant.LOG_USER.type, GlobalConstant.LOG_USER.RESET_PASSWORD.getName(), getSelfId());
        return "redirect:/logout";
    }

    /**
     * 验证密码
     */
    @RequestMapping(value = "verifyPassword", method = {RequestMethod.POST})
    public void resetPassword(HttpServletRequest request, HttpServletResponse response) {
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

    /*---------   用户管理区域（END）   ----------*/

    /*---------   笔记管理区域（START）   ----------*/

    /**
     * 初始化笔记目录树
     */
    @RequestMapping(value = "initArticleDir", method = {RequestMethod.GET})
    public void initArticleDir(HttpServletResponse response) {
        try {
            // 顶层目录 id:root name:我的文件夹
            DirectoryTree directoryTree = new DirectoryTree("root", "我的文件夹");
            initDirectoryTree(directoryTree);
            String data = JSON.toJSONString(directoryTree, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 初始化移动笔记目录树
     */
    @RequestMapping(value = "initMoveArticleDir", method = {RequestMethod.GET})
    public void initMoveArticleDir(HttpServletResponse response) {
        try {
            // 顶层目录 id:root name:我的文件夹
            DirectoryTree directoryTree = new DirectoryTree("root", "我的文件夹");
            moveDirectoryTree(directoryTree);
            String data = JSON.toJSONString(directoryTree, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 初始化回收站文件
     */
    @RequestMapping(value = "initRecycleFile", method = {RequestMethod.GET})
    public void initRecycleFile(HttpServletResponse response) {
        try {
            String uid = getSelfId();
            List<ArticleRecycle> lists = articleRecycleService.listSelfRecycle(uid);
            String data = JSON.toJSONString(lists, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 移动文件
     */
    @RequestMapping(value = "moveNoteToDir", method = {RequestMethod.POST})
    public void moveNoteToDir(HttpServletRequest request, HttpServletResponse response) {
        Message message = new Message();
        boolean status = true;
        String info = null;
        String dirId = request.getParameter("dirId");
        String noteId = request.getParameter("noteId");
        Article article = articleService.getById(noteId);
        List<Article> list = articleService.listArticleByName(getSelfId(), dirId, article.getTitle());
        if (dirId == null) {
            status = false;
            info = "未选择目录";
        }

        if (status) {
            if (list.size() != 0) {
                if (!list.get(0).getId().equals(noteId)) {
                    for (int i = 1; ; i++) {
                        List<Article> lists = articleService.listArticleByName(getSelfId(), dirId, article.getTitle() + "(" + i + ")");
                        if (lists.size() == 0) {
                            article.setTitle(article.getTitle() + "(" + i + ")");
                            break;
                        }
                    }
                }
            }
            article.setDirId(dirId);
            articleService.update(article);
        }

        try {
            message.setStatus(status);
            message.setInfo(info);
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 创建笔记
     */
    @RequestMapping(value = "createNote", method = {RequestMethod.POST})
    public void createNote(HttpServletRequest request, HttpServletResponse response) {
        Message msg = new Message();
        Boolean status = true;
        String info = null;
        try {
            // 所属目录id
            String dirId = request.getParameter("parentId");
            String noteName = request.getParameter("noteName");
            String noteId = GlobalFunction.getUUID();
            String articlePath = GlobalConstant.USER_ARTICLE_PATH + "/" + noteId;

            List<Article> articles = articleService.listArticleByName(getSelfId(), dirId, noteName);
            if (articles.size() != 0) {
                status = false;
                info = "笔记重名，请更换笔记名！";
            } else {
                // 存入数据库
                Article article = new Article();
                article.setTitle(noteName);
                article.setId(noteId);
                article.setUserId(getSelfId());
                article.setDirId(dirId);
                article.setCreateDate(new Date());
                int i = articleService.save(article);
                if (i != 1) {
                    status = false;
                    info = "数据库更新失败！";
                }
                // 初始化笔记内容
                OutputStreamWriter bw = new OutputStreamWriter(new FileOutputStream(articlePath), "UTF-8");
                bw.write(GlobalConstant.ARTICLE_DEFAULT_CONTENT);
                bw.close();

                // 保存日志
                logService.saveLog(request, GlobalConstant.LOG_NOTE.type, GlobalConstant.LOG_NOTE.CREATE_NOTE.getName(), getSelfId());
            }
            msg.setStatus(status);
            msg.setNoteId(noteId);
            msg.setInfo(info);
            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            // 保存日志
            logService.saveLog(request, e, GlobalConstant.LOG_NOTE.type, GlobalConstant.LOG_NOTE.CREATE_NOTE.getName(), getSelfId());
            e.printStackTrace();
        }
    }

    /**
     * 获取笔记信息
     */
    @RequestMapping(value = "getNoteInfo", method = {RequestMethod.POST})
    public void getNoteInfo(HttpServletRequest request, HttpServletResponse response) {
        String noteId = request.getParameter("noteId");
        try {
            Article article = articleService.getById(noteId);
            Message message = new Message();
            ArticleDto articleDto = new ArticleDto();
            if (article == null) {
                message.setStatus(false);
            } else {
                message.setStatus(true);
                BeanUtils.copyProperties(article, articleDto);
                articleDto.setAuthorName(userService.getById(article.getUserId()).getName());
                message.setArticleDto(articleDto);
            }
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 重命名笔记
     */
    @RequestMapping(value = "renameNote", method = {RequestMethod.POST})
    public void renameNote(HttpServletRequest request, HttpServletResponse response) {
        Boolean status = true;
        String info = null;
        try {
            String noteId = request.getParameter("noteId");
            String noteName = request.getParameter("noteName");
            Article article = articleService.getById(noteId);
            List<Article> articles = articleService.listArticleByName(getSelfId(), article.getDirId(), noteName);
            if (articles.size() != 0 && !articles.get(0).getId().equals(noteId)) {
                status = false;
                info = "笔记重名，请更换笔记名！";
            } else if (articles.size() == 0 || !articles.get(0).getId().equals(noteId)) {
                article.setTitle(noteName);
                if (articleService.update(article) != 1) {
                    status = false;
                    info = "数据库更新失败！";
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

    /**
     * 上传笔记
     */
    @RequestMapping(value = "uploadNote", method = {RequestMethod.POST})
    public String uploadNote(HttpServletRequest request) {
        try {
            DiskFileItemFactory factory = new DiskFileItemFactory(1024 * 1024, new File(GlobalConstant.TEMP_PATH));
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setHeaderEncoding("UTF-8");

            if (ServletFileUpload.isMultipartContent(request)) {
                List<FileItem> fileItems = upload.parseRequest(request);
                if (fileItems.size() != 0) {
                    for (FileItem item : fileItems) {
                        String fileName = item.getName();
                        if (StringUtils.isBlank(fileName)) {
                            continue;
                        }

                        fileName = fileName.split("\\.")[0];
                        String noteId = GlobalFunction.getUUID();
                        String filePath = GlobalConstant.USER_ARTICLE_PATH + "/" + noteId;

                        // 存入服务器
                        GlobalFunction.uploadFile(item, filePath);

                        // 加入数据库
                        Article article = new Article();
                        article.setId(noteId);
                        article.setUserId(getSelfId());
                        article.setTitle(fileName);
                        article.setDirId(GlobalConstant.ROOT_DIR);
                        article.setCreateDate(new Date());
                        articleService.save(article);

                        // 保存日志
                        logService.saveLog(request, GlobalConstant.LOG_NOTE.type, GlobalConstant.LOG_NOTE.UPLOAD_NOTE.getName(), getSelfId());
                    }
                }
            }
        } catch (Exception e) {
            // 保存日志
            logService.saveLog(request, e, GlobalConstant.LOG_NOTE.type, GlobalConstant.LOG_NOTE.UPLOAD_NOTE.getName(), getSelfId());
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
            String path = GlobalConstant.USER_ARTICLE_PATH + "/" + noteId;
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
        String info = "";
        Article article = null;
        try {
            // 排除笔记信息错误
            if (StringUtils.isBlank(noteId) || StringUtils.isBlank(noteName)) {
                status = false;
                info = "获取笔记信息失败";
            } else {
                // 排除同目录下重名
                article = articleService.getById(noteId);
                List<Article> articles = articleService.listArticleByName(getSelfId(), article.getDirId(), noteName);
                if (articles.size() != 0 && !articles.get(0).getId().equals(noteId)) {
                    status = false;
                    info = "笔记重名";
                }
            }

            if (status) {
                // 1.更新笔记数据库
                String content = request.getParameter("data");
                if (!article.getTitle().equals(noteName)) {
                    article.setTitle(noteName);
                    articleService.update(article);
                }

                //2. 更新笔记文件
                String targetFilePath = GlobalConstant.USER_ARTICLE_PATH + "/" + noteId;
                OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream(targetFilePath), "UTF-8");
                writer.write(content);
                writer.flush();
                writer.close();

                // 3.更新分享页面
                if (article.getIsOpen() == GlobalConstant.NOTE_STATUS.SHARE.getIndex()) {
                    String url = article.getShareUrl();
                    if (url != null) {
                        createSharePage(noteId, url);
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

    /**
     * 删除笔记
     */
    @RequestMapping(value = "removeNote", method = {RequestMethod.POST})
    public void removeNote(HttpServletRequest request, HttpServletResponse response) {
        try {
            Boolean status = false;
            String noteId = request.getParameter("noteId");
            ArticleRecycle articleRecycle = new ArticleRecycle();
            Article article = articleService.getById(noteId);
            BeanUtils.copyProperties(article, articleRecycle);

            // 从笔记表移除并加入笔记回收表
            if (articleService.removeById(noteId) == 1 && articleRecycleService.save(articleRecycle) == 1) {
                status = true;
            }
            Message msg = new Message();
            msg.setStatus(status);
            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 从回收站中删除笔记
     */
    @RequestMapping(value = "foreverRemoveNote", method = {RequestMethod.POST})
    public void foreverRemoveNote(HttpServletRequest request, HttpServletResponse response) {
        try {
            Boolean status = false;
            String noteId = request.getParameter("noteId");

            // 从数据库中移除
            if (!StringUtils.isBlank(noteId)) {
                if (articleRecycleService.removeById(noteId) == 1) {
                    status = true;
                }
                // 清除标签
                articleTagService.removeAllByArticleId(noteId);
            }

            // 保存日志
            logService.saveLog(request, GlobalConstant.LOG_NOTE.type, GlobalConstant.LOG_NOTE.FOREVER_REMOVE_NOTE.getName(), getSelfId());

            // 删除笔记
            String path = GlobalConstant.USER_ARTICLE_PATH + "/" + noteId;
            FileUtils.deleteQuietly(new File(path));

            Message msg = new Message();
            msg.setStatus(status);
            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (Exception e) {
            // 保存日志
            logService.saveLog(request, e, GlobalConstant.LOG_NOTE.type, GlobalConstant.LOG_NOTE.FOREVER_REMOVE_NOTE.getName(), getSelfId());
            e.printStackTrace();
        }
    }

    /**
     * 从回收站中还原笔记
     */
    @RequestMapping(value = "recycleNote", method = {RequestMethod.POST})
    public void recycleNote(HttpServletRequest request, HttpServletResponse response) {
        try {
            Boolean status = false;
            Message msg = new Message();
            String noteId = request.getParameter("noteId");

            if (!StringUtils.isBlank(noteId)) {
                ArticleRecycle articleRecycle = articleRecycleService.getById(noteId);
                Article article = new Article();
                BeanUtils.copyProperties(articleRecycle, article);
                List<Article> list = articleService.listArticleByName(getSelfId(), articleRecycle.getDirId(), articleRecycle.getTitle());
                if (list.size() != 0) {
                    for (int i = 1; ; i++) {
                        List<Article> lists = articleService.listArticleByName(getSelfId(), articleRecycle.getDirId(), articleRecycle.getTitle() + "(" + i + ")");
                        if (lists.size() == 0) {
                            article.setTitle(article.getTitle() + "(" + i + ")");
                            break;
                        }
                    }
                }
                if (articleRecycleService.removeById(noteId) == 1 && articleService.save(article) == 1) {
                    if (article.getDirId() != null) {
                        msg.setInfo(article.getDirId());
                        msg.setName(article.getTitle());
                    }
                    status = true;
                }
                msg.setStatus(status);
                String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
                response.getWriter().write(data);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 清空回收站
     */
    @RequestMapping(value = "clearRubbish", method = {RequestMethod.GET})
    public void clearRubbish(HttpServletResponse response) {
        try {
            String uid = getSelfId();
            Message message = new Message();
            if (!StringUtils.isBlank(uid)) {
                List<ArticleRecycle> list = articleRecycleService.listSelfRecycle(uid);
                for (ArticleRecycle articleRecycle : list) {
                    String articleId = articleRecycle.getId();
                    String path = GlobalConstant.USER_ARTICLE_PATH + "/" + articleId;
                    FileUtils.deleteQuietly(new File(path));
                    articleRecycleService.removeById(articleId);

                    // 清除标签
                    articleTagService.removeAllByArticleId(articleId);
                }

                message.setStatus(true);
            } else {
                message.setStatus(false);
            }
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 恢复笔记
     */
    @RequestMapping(value = "recoverNote", method = {RequestMethod.POST})
    public void recoverNote(HttpServletRequest request, HttpServletResponse response) {
        char[] buf = new char[1024];
        int len;
        try {
            Message message = new Message();
            String noteId = request.getParameter("noteId");
            if(StringUtils.isBlank(noteId)) {
                message.setStatus(false);
            } else {
                String noteName = request.getParameter("noteName");
                if(StringUtils.isBlank(noteName)) {
                    noteName = articleService.getById(noteId).getTitle();
                }
                String targetFilePath = GlobalConstant.USER_ARTICLE_PATH + "/" + noteId;

                // 获取文件内容
                InputStreamReader in = new InputStreamReader(new FileInputStream(targetFilePath), "UTF-8");
                StringBuilder sb = new StringBuilder();

                while ((len = in.read(buf, 0, buf.length)) > 0) {
                    sb.append(buf, 0, len);
                }
                in.close();

                // 获取所有附件
                List<ArticleAffix> affixes = articleAffixService.listByArticleId(noteId);

                message.setInfo(sb.toString());
                message.setStatus(true);
                message.setName(noteName);
                message.setNoteTag(getNoteTag(noteId));
                message.setAffixes(affixes);
            }
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 添加笔记标签
     */
    @RequestMapping(value = "addArticleTag", method = {RequestMethod.POST})
    public void addArticleTag(HttpServletRequest request, HttpServletResponse response) {
        Message message = new Message();
        Boolean status = false;
        String info = "";
        String noteId = request.getParameter("noteId");
        String tagText = request.getParameter("tagText");
        try {
            if(!StringUtils.isBlank(noteId) && !StringUtils.isBlank(tagText)) {
                Tag tag = tagService.getByName(tagText);
                if(tag != null) {
                    String tagId = tag.getId();
                    // 判断该文章是否已经有该标签，如果没有，直接添加
                    if(articleTagService.getByArticleIdAndTagId(noteId, tagId) == null) {
                        ArticleTagKey articleTagKey = new ArticleTagKey();
                        articleTagKey.setArticleId(noteId);
                        articleTagKey.setTagId(tagId);
                        articleTagService.save(articleTagKey);
                        status = true;
                        info = tagId;
                    }
                } else {
                    // 如果Tag表中不存在：1.存入Tag表；2：存入ArticleTag表
                    String tagId = GlobalFunction.getUUID();
                    Tag tag1 = new Tag();
                    tag1.setId(tagId);
                    tag1.setName(tagText);
                    tag1.setCreateDate(new Date());
                    tagService.save(tag1);

                    ArticleTagKey articleTagKey = new ArticleTagKey();
                    articleTagKey.setArticleId(noteId);
                    articleTagKey.setTagId(tagId);
                    articleTagService.save(articleTagKey);
                    status = true;
                    info = tagId;
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

    /**
     * 删除笔记标签
     */
    @RequestMapping(value = "removeArticleTag", method = {RequestMethod.POST})
    public void removeArticleTag(HttpServletRequest request, HttpServletResponse response) {
        Message message = new Message();
        String noteId = request.getParameter("noteId");
        String tagId = request.getParameter("tagId");
        try {
            if(!StringUtils.isBlank(noteId) && !StringUtils.isBlank(tagId)) {
                ArticleTagKey articleTagKey = new ArticleTagKey();
                articleTagKey.setArticleId(noteId);
                articleTagKey.setTagId(tagId);
                articleTagService.remove(articleTagKey);
                message.setStatus(true);
            } else {
                message.setStatus(false);
            }
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
        String noteId = request.getParameter("noteId");
        Message message = new Message();
        Boolean status = false;
        try {
            Article article = articleService.getById(noteId);
            if (article != null) {
                // 如果文章已经分享，无需再次分享
                if (article.getIsOpen() == GlobalConstant.NOTE_STATUS.SHARE.getIndex()) {
                    status = true;
                    String realUrl = GlobalFunction.getRealUrl(article.getShareUrl());
                    message.setInfo(realUrl);
                    message.setName(GlobalConstant.SER_URL + "/images/logo_big.png");
                } else if (article.getIsOpen() == GlobalConstant.NOTE_STATUS.NOT_SHARE.getIndex()) {
                    String url = createSharePage(noteId, null);
                    if (!StringUtils.isBlank(url)) {
                        // 更新数据库
                        article.setIsOpen(GlobalConstant.NOTE_STATUS.SHARE.getIndex());
                        article.setShareUrl(url);
                        articleService.update(article);

                        // 保存日志
                        logService.saveLog(request, GlobalConstant.LOG_NOTE.type, GlobalConstant.LOG_NOTE.SHARE_NOTE.getName(), getSelfId());

                        String realUrl = GlobalFunction.getRealUrl(url);
                        message.setInfo(realUrl);
                        message.setName(GlobalConstant.SER_URL + "/images/logo_big.png");
                        status = true;
                    }
                }
            }
            message.setStatus(status);
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            // 保存日志
            logService.saveLog(request, e, GlobalConstant.LOG_NOTE.type, GlobalConstant.LOG_NOTE.SHARE_NOTE.getName(), getSelfId());
            e.printStackTrace();
        }
    }

    /**
     * 取消分享笔记
     */
    @RequestMapping(value = "cancelShare", method = {RequestMethod.POST})
    public void cancelShare(HttpServletRequest request, HttpServletResponse response) {
        String noteId = request.getParameter("noteId");
        Message message = new Message();
        try {
            // 更新数据库
            Article article = articleService.getById(noteId);
            if (article == null) {
                message.setStatus(false);
            } else {
                article.setIsOpen(GlobalConstant.NOTE_STATUS.NOT_SHARE.getIndex());
                String url = article.getShareUrl();
                if (!StringUtils.isBlank(url)) {
                    GlobalFunction.deleteSignalFile(url);
                    article.setShareUrl("");
                }
                articleService.update(article);
                message.setStatus(true);

                // 保存日志
                logService.saveLog(request, GlobalConstant.LOG_NOTE.type, GlobalConstant.LOG_NOTE.CANCEL_SHARE_NOTE.getName(), getSelfId());
            }
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (Exception e) {
            // 保存日志
            logService.saveLog(request, e, GlobalConstant.LOG_NOTE.type, GlobalConstant.LOG_NOTE.CANCEL_SHARE_NOTE.getName(), getSelfId());
            e.printStackTrace();
        }
    }

    /**
     * 查看个人分享笔记
     */
    @RequestMapping(value = "showShareNote", method = {RequestMethod.GET})
    public void showShareNote(HttpServletResponse response) {
        try {
            String userId = getSelfId();
            List<Article> lists = articleService.listArticleByUid(userId, true);

            // 提取url相对路径
            for (Article article : lists) {
                String url = article.getShareUrl();
                String realUrl = GlobalFunction.getRealUrl(url);
                article.setShareUrl(realUrl);
            }

            Message message = new Message();
            if (lists.size() == 0) {
                message.setStatus(false);
            } else {
                message.setStatus(true);
                message.setArticles(lists);
            }

            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 查看其他人分享的笔记
     */
    @RequestMapping(value = "showOtherShareNote", method = {RequestMethod.GET})
    public void showOtherShareNote(HttpServletResponse response) {
        try {
            String userId = getSelfId();
            List<Article> lists = articleService.listAnotherShareArticle(userId);
            Message message = new Message();
            if (lists.size() == 0) {
                message.setStatus(false);
            } else {
                List<ArticleDto> articleDtos = new ArrayList<>();
                // 随机取SHOW_SHARE_NUM个笔记

                List<Integer> shareNOs = random(GlobalConstant.SHOW_SHARE_NUM, lists.size());
                for (Integer no : shareNOs) {
                    Article article = lists.get(no);
                    ArticleDto articleDto = new ArticleDto();
                    BeanUtils.copyProperties(article, articleDto);
                    articleDto.setAbstractText(getAbstractText(articleDto));
                    String url = articleDto.getShareUrl();
                    String realUrl = GlobalFunction.getRealUrl(url);
                    articleDto.setShareUrl(realUrl);
                    articleDto.setAuthorName(userService.getById(article.getUserId()).getName());

                    User user = userService.getById(articleDto.getUserId());
                    String iconUrl = user.getIcon();
                    if (!StringUtils.isBlank(iconUrl)) {
                        String iconRealUrl = GlobalFunction.getRealUrl(iconUrl);
                        articleDto.setAuthorIcon(iconRealUrl);
                    }
                    articleDtos.add(articleDto);
                }

                message.setStatus(true);
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
        Boolean status = false;
        String affixId = request.getParameter("affixId");
        try {
            if (affixId != null) {
                // 删除转换后文件
                FileConvert fileConvert = fileConvertService.getById(affixId);
                if(fileConvert != null) {
                    FileUtils.deleteQuietly(new File(fileConvert.getPath()));
                }

                ArticleAffix articleAffix = articleAffixService.getById(affixId);
                if (articleAffix != null) {
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
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 上传附件
     */
    @RequestMapping(value = "uploadAffix", method = {RequestMethod.POST})
    public void uploadAffix(HttpServletRequest request, HttpServletResponse response) {
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
                            if (StringUtils.isBlank(fieldName)) {
                                break;
                            } else {
                                noteId = fieldValue;
                            }
                        } else {
                            if (!StringUtils.isBlank(noteId)) {
                                String fileName = item.getName();
                                // 出国文件名长度超长，只取最后位数
                                if (fileName.length() > 64) {
                                    fileName = fileName.substring(fileName.length() - 63);
                                }
                                // 如果文件名为空，就跳过
                                if (StringUtils.isBlank(fileName)) {
                                    continue;
                                }
                                // 上传文件
                                String affixId = GlobalFunction.getUUID();
                                String path = GlobalConstant.USER_AFFIX_PATH + "/" + fileName;
                                GlobalFunction.uploadFile(item, path);

                                //存入数据库
                                ArticleAffix articleAffix = new ArticleAffix();
                                articleAffix.setId(affixId);
                                articleAffix.setArticleid(noteId);
                                articleAffix.setName(fileName);
                                articleAffix.setPath(path);
                                articleAffix.setCreateTime(new Date());
                                articleAffixService.save(articleAffix);
                                // 保存日志
                                logService.saveLog(request, GlobalConstant.LOG_NOTE.type, GlobalConstant.LOG_NOTE.UPLOAD_AFFIX.getName(), getSelfId());
                            }
                        }
                    }
                }
                Message message = new Message();
                message.setStatus(true);
                String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
                response.getWriter().write(data);
            }
        } catch (Exception e) {
            // 保存日志
            logService.saveLog(request, e, GlobalConstant.LOG_NOTE.type, GlobalConstant.LOG_NOTE.UPLOAD_AFFIX.getName(), getSelfId());
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
        try {
            if (affixId == null) {
                message.setStatus(false);
            } else {
                ArticleAffix articleAffix = articleAffixService.getById(affixId);
                // 数据库中文件绝对路径
                String path = articleAffix.getPath();

                // 用来判断文件后缀的临时变量
                String temp = articleAffix.getName().toLowerCase();
                Boolean pdfFlag, previewFlag = false;

                // 判断是否是除pdf外的可转换后缀
                for (String ss : GlobalConstant.PREVIEW_SUFFIX) {
                    if (temp.endsWith(ss)) {
                        previewFlag = true;
                        break;
                    }
                }
                // 判断是否是pdf后缀
                pdfFlag = temp.endsWith(".pdf");
                if (pdfFlag) {
                    int i = path.indexOf("upload");
                    String url = GlobalConstant.SER_URL + "/generic/web/viewer.html?file=" + GlobalConstant.SER_URL + "/" + path.substring(i);
                    message.setInfo(url);
                    message.setStatus(true);
                } else if (previewFlag) {
                    String realUrl = GlobalFunction.getRealUrl(path);
                    message.setInfo(realUrl);
                    message.setStatus(true);
                } else {
                    // 如果不是，判断是否已经被转换了
                    FileConvert fileConvert = fileConvertService.getById(affixId);
                    if (fileConvert == null) {
                        // 如果没有被转换，无法预览
                        message.setStatus(false);
                    } else {
                        // 如果转换了，预览转换后的文件
                        String convertedPath = fileConvert.getPath();
                        int i = convertedPath.indexOf("upload");
                        String url = GlobalConstant.SER_URL + "/generic/web/viewer.html?file="+ GlobalConstant.SER_URL + "/" + convertedPath.substring(i);
                        message.setInfo(url);
                        message.setStatus(true);
                    }
                }
            }
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * PDF转换
     * 支持格式：doc、docx、xls、xlsx、ppt、pptx
     */
    @RequestMapping(value = "convertFile", method = {RequestMethod.POST})
    public void convertFile(HttpServletRequest request, HttpServletResponse response) {
        Message msg = new Message();
        Boolean status;
        String info;
        try {
            // 转换前判断是否已经被转换过了
            String affixId = request.getParameter("affixId");
            FileConvert fileConvert = fileConvertService.getById(affixId);

            // 如果存在，则直接返回即可
            if (fileConvert != null) {
                msg.setStatus(true);
                String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
                response.getWriter().write(data);
            } else {
                // 如果不存在，转换
                ArticleAffix articleAffix = articleAffixService.getById(affixId);
                String fileName = articleAffix.getName();
                String[] tmp = fileName.split("\\.");
                String name = tmp[0];
                String suffix = tmp[1];

                String inputPath = GlobalConstant.USER_AFFIX_PATH + "/" + fileName;
                String outputPath = GlobalConstant.USER_AFFIX_PATH + "/" + name + ".pdf";
                int i;
                switch (suffix) {
                    case "doc":
                    case "docx":
                        i = WordToPdf.run(inputPath, outputPath);
                        break;
                    case "xls":
                    case "xlsx":
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
                if (status) {
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
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 模糊匹配笔记名、标签名、笔记内容
     */
    @RequestMapping(value = "nbSearch", method = {RequestMethod.POST})
    public String nbSearch(String keywords, Model model) {
        List<Map<String, String>> result = new ArrayList<>();
        try {
            if (!StringUtils.isBlank(keywords)) {
                // 查询笔记名和内容
                LuceneUtils.prepareIndex(GlobalConstant.USER_ARTICLE_INDEX_PATH);
                List<Article> articles = articleService.listArticleByUid(getSelfId(), null);
                LuceneUtils.createIndex(GlobalConstant.USER_ARTICLE_PATH, GlobalConstant.USER_ARTICLE_INDEX_PATH, articles);
                List<Map<String, String>> listByNameAndContent = LuceneUtils.searchIndex(keywords, GlobalConstant.USER_ARTICLE_INDEX_PATH);

                // 查询笔记标签
                List<Article> listByTag = articleService.listArticleByTagName(getSelfId(), keywords);
                List<String> listIdByTag = new ArrayList<>();
                for(Article article : listByTag) {
                    listIdByTag.add(article.getId());
                }

                List<String> luceneIds = new ArrayList<>();
                for(Map<String, String> map : listByNameAndContent) {
                    Map<String, String> tmpMap = new HashMap<>(16);
                    String noteId = map.get("noteId");
                    String noteName = map.get("noteName");
                    String content = map.get("content");

                    tmpMap.put("noteId", noteId);
                    tmpMap.put("noteName", noteName);
                    // 如果内容为空，则说明内容中不包含关键字，则直接获取文件内容即可
                    if(StringUtils.isEmpty(content)) {
                        content = getAbstractText(noteId);
                    }
                    tmpMap.put("content", content);

                    // 如果Lucene搜索结果也在标签搜索结果中，则对于指定标签也加上高亮显示
                    StringBuilder tagBuilder = new StringBuilder();

                    List<ArticleTagKey> articleTagKeys = articleTagService.listByArticleId(noteId);
                    for(ArticleTagKey tag : articleTagKeys) {
                        String tagName = tagService.getById(tag.getTagId()).getName();
                        if(tagName.contains(keywords)) {
                            tagBuilder.append("<span style=\"color:red\">").append(tagName).append("</span>");
                        } else {
                            tagBuilder.append(tagName);
                        }
                        tagBuilder.append("\t");
                    }
                    tmpMap.put("tag", tagBuilder.toString());

                    // 将所有由Lucene搜到的笔记加入集合，用于后面判断
                    luceneIds.add(noteId);
                    // 将结果放入result
                    result.add(tmpMap);
                }

                // 将仅标签匹配的笔记加入集合
                for(String id : listIdByTag) {
                    // 如果不包含，则说明只有标签匹配，因此直接
                    if(!luceneIds.contains(id)) {
                        Map<String, String> tmpMap = new HashMap<>(16);
                        tmpMap.put("noteId", id);
                        tmpMap.put("noteName", articleService.getById(id).getTitle());
                        tmpMap.put("content", getAbstractText(id));

                        StringBuilder tagBuilder = new StringBuilder();
                        List<ArticleTagKey> articleTagKeys = articleTagService.listByArticleId(id);
                        for(ArticleTagKey tag : articleTagKeys) {
                            String tagName = tagService.getById(tag.getTagId()).getName();
                            if(tagName.contains(keywords)) {
                                tagBuilder.append("<span style=\"color:red\">").append(tagName).append("</span>");
                            } else {
                                tagBuilder.append(tagName);
                            }
                            tagBuilder.append("\t");
                        }
                        tmpMap.put("tag", tagBuilder.toString());
                        // 将结果放入result
                        result.add(tmpMap);
                    }
                }

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        model.addAttribute("result",result);
        return "/user/searchResult";
    }

    @RequestMapping(value = "searchResult", method = {RequestMethod.GET})
    public String searchResult(String id, RedirectAttributes model) {
        model.addFlashAttribute("id", id);
        return "redirect:/user/index";
    }
    /*---------   笔记管理区域（END）   ----------*/

    /*---------   目录管理区域（START）   ----------*/
    /**
     * 新建目录
     */
    @RequestMapping(value = "createDir", method = {RequestMethod.POST})
    public void createDir(HttpServletRequest request, HttpServletResponse response) {
        Message msg = new Message();
        Boolean status = true;
        String info = null;
        try {
            String parentId = request.getParameter("parentId");
            String dirName = request.getParameter("dirName");

            ArticleDir directory = new ArticleDir();
            List<ArticleDir> articleDir = articleDirService.getByName(getSelfId(), parentId, dirName);
            if (articleDir.size() != 0) {
                status = false;
                info = "目录名重复，请更换目录名！";
            } else {
                String dirId = GlobalFunction.getUUID();
                directory.setId(dirId);
                directory.setName(dirName);
                directory.setUid(getSelfId());
                directory.setParentId(parentId);
                directory.setCreateDate(new Date());
                int i = articleDirService.save(directory);
                if (i != 1) {
                    status = false;
                    info = "数据库更新失败";
                }
                msg.setDirId(dirId);
            }
            msg.setStatus(status);
            msg.setInfo(info);
            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 删除目录
     */
    @RequestMapping(value = "removeDir", method = {RequestMethod.POST})
    public void removeDir(HttpServletRequest request, HttpServletResponse response) {
        Boolean status = true;
        String dirId = request.getParameter("dirId");

        try {
            // 1.将目录及其子目录下所有笔记迁移到父目录中
            ArticleDir directory = articleDirService.getById(dirId);
            String parentDir = directory.getParentId();
            changeAllNoteDir(directory, parentDir);

            // 2.删除目录及其子目录
            int i = articleDirService.remove(dirId);
            if (i != 1) {
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
        Message msg = new Message();
        Boolean status = true;
        String info = null;
        try {
            String dirId = request.getParameter("dirId");
            String dirName = request.getParameter("dirName");
            ArticleDir directory = articleDirService.getById(dirId);
            List<ArticleDir> articleDirs = articleDirService.getByName(getSelfId(), directory.getParentId(), dirName);
            if (articleDirs.size() != 0 && !articleDirs.get(0).getId().equals(dirId)) {
                status = false;
                info = "目录重名，请更换目录名！";
            } else {
                directory.setName(dirName);
                int i = articleDirService.update(directory);
                if (i != 1) {
                    status = false;
                    info = "数据库更新失败！";
                }
            }
            msg.setStatus(status);
            msg.setInfo(info);
            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /*---------   目录管理区域（END）   ----------*/

    /*---------   网盘管理区域（Start）   ----------*/

    /**
     * 初始化云盘目录树
     */
    @RequestMapping(value = "initUserPanDir", method = {RequestMethod.GET})
    public void initUserPanDir(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("dirId");
        try {
            // 顶层目录 id:root name:我的网盘
            DirectoryTree directoryTree = new DirectoryTree(id, "我的网盘");
            initPanDirectoryTree(directoryTree);
            String data = JSON.toJSONString(directoryTree, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 初始化用户网盘空间
     */
    @RequestMapping(value = "initUserPanSize", method = {RequestMethod.GET})
    public void initUserPanSize(HttpServletResponse response) {
        try {
            String uid = getSelfId();
            String perfect;
            Integer size = userPanService.countUsedSize(uid);
            if (size == null) {
                perfect = "0";
            } else {
                DecimalFormat df = new DecimalFormat("0.00");
                perfect = df.format((float) size / GlobalConstant.DEFAULT_PAN_SIZE * 100);
            }

            Map<String, Object> map = new HashMap<>(16);
            map.put("size", GlobalConstant.DEFAULT_PAN_SIZE);
            map.put("usedPerfect", perfect);

            String data = JSON.toJSONString(map, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 预览网盘
     */
    @RequestMapping(value = "previewDisk", method = {RequestMethod.POST})
    public void previewDisk(HttpServletRequest request, HttpServletResponse response) {
        String panId = request.getParameter("panId");
        Message message = new Message();
        try {
            if (panId == null) {
                message.setStatus(false);
            } else {
                UserPan userPan = userPanService.getById(panId);
                String fileName = userPan.getName();
                String[] tmp = fileName.split("\\.");
                String name = tmp[0];

                // 数据库中文件绝对路径
                String path = GlobalConstant.USER_PAN_PATH + "/" + fileName;

                // 用来判断文件后缀的临时变量
                String temp = userPan.getName().toLowerCase();
                Boolean pdfFlag, previewFlag = false;

                // 判断是否是除pdf外的可转换后缀
                for (String ss : GlobalConstant.PREVIEW_SUFFIX) {
                    if (temp.endsWith(ss)) {
                        previewFlag = true;
                        break;
                    }
                }
                // 判断是否是pdf后缀
                pdfFlag = temp.endsWith(".pdf");

                if (pdfFlag) {
                    int i = path.indexOf("upload");
                    String url = GlobalConstant.SER_URL + "/generic/web/viewer.html?file=" + GlobalConstant.SER_URL + "/" + path.substring(i);
                    message.setInfo(url);
                    message.setStatus(true);
                } else if (previewFlag) {
                    String realUrl = GlobalFunction.getRealUrl(path);
                    message.setInfo(realUrl);
                    message.setStatus(true);
                } else {
                    // 如果不是，判断是否已经被转换了
                    String tempPath = GlobalConstant.TEMP_PATH + "/" + name + ".pdf";
                    File file = new File(path);
                    if (!file.exists()) {
                        // 如果没有被转换，无法预览
                        message.setStatus(false);
                    } else {
                        // 如果转换了，预览转换后的文件
                        int i = tempPath.indexOf("temp");
                        String url = GlobalConstant.SER_URL + "/generic/web/viewer.html?file="+ GlobalConstant.SER_URL + "/" + tempPath.substring(i);
                        message.setInfo(url);
                        message.setStatus(true);
                    }
                }
            }
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * PDF转换
     * 支持格式：doc、docx、xls、xlsx、ppt、pptx
     */
    @RequestMapping(value = "convertDiskFile", method = {RequestMethod.POST})
    public void convertDiskFile(HttpServletRequest request, HttpServletResponse response) {
        Message msg = new Message();
        Boolean status;
        String info;
        try {
            // 转换前判断是否已经被转换过了
            String panId = request.getParameter("panId");
            UserPan userPan = userPanService.getById(panId);
            String fileName = userPan.getName();
            String[] tmp = fileName.split("\\.");
            String name = tmp[0];
            String suffix = tmp[1];

            String path = GlobalConstant.TEMP_PATH + "/" + name + ".pdf";
            File file = new File(path);
            // 如果存在，则直接返回即可
            if (file.exists()) {
                msg.setStatus(true);
                String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
                response.getWriter().write(data);
            } else {
                // 如果不存在，转换
                String inputPath = GlobalConstant.USER_PAN_PATH + "/" + fileName;
                String outputPath = GlobalConstant.TEMP_PATH + "/" + tmp[0] + ".pdf";
                int i;
                switch (suffix) {
                    case "doc":
                    case "docx":
                        i = WordToPdf.run(inputPath, outputPath);
                        break;
                    case "xls":
                    case "xlsx":
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
                msg.setStatus(status);
                msg.setInfo(info);
                String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
                response.getWriter().write(data);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 上传云盘文件
     */
    @RequestMapping(value = "uploadPan", method = {RequestMethod.POST})
    public void uploadPan(HttpServletRequest request, HttpServletResponse response) {
        try {
            DiskFileItemFactory factory = new DiskFileItemFactory(1024 * 1024, new File(GlobalConstant.TEMP_PATH));
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setHeaderEncoding("UTF-8");
            Message message = new Message();
            boolean status = true;

            if (ServletFileUpload.isMultipartContent(request)) {
                List<FileItem> fileItems = upload.parseRequest(request);
                if (fileItems.size() != 0) {
                    String dirId = null;
                    String fileName;
                    for (FileItem item : fileItems) {
                        if (item.isFormField()) {
                            dirId = item.getString("UTF-8");
                        } else {
                            fileName = item.getName();
                            if (StringUtils.isBlank(fileName)) {
                                continue;
                            }
                            //处理重名
                            List<UserPan> list = userPanService.getByName(dirId, fileName, getSelfId());
                            String name = fileName.substring(0, fileName.lastIndexOf("."));
                            String prefix = fileName.substring(fileName.lastIndexOf("."));
                            if (!list.isEmpty()) {
                                for (int i = 1; ; i++) {
                                    String tempName = name + "(" + Integer.toString(i) + ")" + prefix;
                                    List<UserPan> list1 = userPanService.getByName(dirId, tempName, getSelfId());
                                    if (list1.isEmpty()) {
                                        fileName = name + "(" + Integer.toString(i) + ")" + prefix;
                                        break;
                                    }
                                }
                            }
                            String userPanId = GlobalFunction.getUUID();
                            String filePath = GlobalConstant.USER_PAN_PATH + "/" +fileName;

                            // 存入服务器
                            GlobalFunction.uploadFile(item, filePath);

                            // 加入数据库
                            UserPan userPan = new UserPan();
                            userPan.setId(userPanId);
                            userPan.setUserid(getSelfId());
                            userPan.setName(fileName);
                            userPan.setDirId(dirId);
                            userPan.setSize(Long.toString(FileUtils.sizeOf(new File(filePath))));
                            userPan.setCreateTime(new Date());
                            if (userPanService.save(userPan) != 1) {
                                status = false;
                            }

                            message.setInfo(userPan.getId());
                            message.setStatus(status);
                            message.setName(userPan.getName());
                            // 保存日志
                            logService.saveLog(request, GlobalConstant.LOG_PAN.type, GlobalConstant.LOG_PAN.FILE_UPLOAD.getName(), getSelfId());
                        }
                    }
                    String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
                    response.getWriter().write(data);
                }
            }
        } catch (Exception e) {
            // 保存日志
            logService.saveLog(request, e, GlobalConstant.LOG_PAN.type, GlobalConstant.LOG_PAN.FILE_UPLOAD.getName(), getSelfId());
            e.printStackTrace();
        }
    }

    /**
     * 下载云盘文件
     */
    @RequestMapping(value = "downloadUserPan", method = {RequestMethod.GET})
    public void downloadUserPan(HttpServletRequest request, HttpServletResponse response) {
        String fileName = request.getParameter("panName");
        String userPanId = request.getParameter("panId");
        try {
            // 得到用于返回给客户端的编码后的文件名
            String agent = request.getHeader("User-Agent");
            String fileNameEncode = solveFileNameEncode(agent, fileName);
            // 客户端判断下载文件类型
            response.setContentType(request.getSession().getServletContext().getMimeType(fileName));
            // 关闭客户端的默认解析
            response.setHeader("Content-Disposition", "attachment;filename=" + fileNameEncode);
            // 获得文件真实下载路径
            String name = userPanService.getById(userPanId).getName();
            String path = GlobalConstant.USER_PAN_PATH + "/" + name;
            // 下载文件
            GlobalFunction.downloadFile(path, response.getOutputStream());

            // 保存日志
            logService.saveLog(request, GlobalConstant.LOG_PAN.type, GlobalConstant.LOG_PAN.FILE_DOWNLOAD.getName(), getSelfId());
        } catch (IOException e) {
            // 保存日志
            logService.saveLog(request, e, GlobalConstant.LOG_PAN.type, GlobalConstant.LOG_PAN.FILE_DOWNLOAD.getName(), getSelfId());
            e.printStackTrace();
        }
    }

    /**
     * 模糊匹配查找云盘文件名
     */
    @RequestMapping(value = "panSearch", method = {RequestMethod.POST})
    public void panSearch(HttpServletRequest request, HttpServletResponse response) {
        String searchKey = request.getParameter("searchKey");
        try {
            Message message = new Message();
            if (StringUtils.isBlank(searchKey)) {
                message.setStatus(false);
            } else {
                // 查询文件
                List<UserPan> userPans = userPanService.listUserPanByTitle(getSelfId(), searchKey);
                // 查询文件夹
                ArrayList<DirectoryTree> list = new ArrayList<>();
                List<PanDir> panDirs = panDirService.listPanDirByTitle(getSelfId(), searchKey);
                for (PanDir panDir : panDirs) {
                    DirectoryTree directoryTree = new DirectoryTree(panDir.getId(), panDir.getName());
                    list.add(directoryTree);
                }

                if (userPans.size() == 0 && panDirs.size() == 0) {
                    message.setStatus(false);
                } else {
                    message.setStatus(true);
                    message.setDirectoryTrees(list);
                    message.setUserFiles(userPans);
                }
            }
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 新建云盘目录
     */
    @RequestMapping(value = "createPanDir", method = {RequestMethod.POST})
    public void createPanDir(HttpServletRequest request, HttpServletResponse response) {
        Boolean status = true;
        String info = null;
        try {
            String parentId = request.getParameter("parentId");
            String dirName = request.getParameter("dirName");
            Message msg = new Message();
            List<PanDir> list = panDirService.getByName(getSelfId(), parentId, dirName);
            if (list.size() != 0) {
                status = false;
                info = "文件夹重名!请更换文件夹名";
            } else {
                PanDir directory = new PanDir();
                String dirId = GlobalFunction.getUUID();
                directory.setId(dirId);
                directory.setName(dirName);
                directory.setUid(getSelfId());
                directory.setParentId(parentId);
                directory.setCreateDate(new Date());
                int i = panDirService.save(directory);
                if (i != 1) {
                    status = false;
                    info = "保存数据库失败!";
                }
                msg.setDirId(dirId);
                msg.setInfo(dirId);
            }
            msg.setInfo(info);
            msg.setStatus(status);

            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 重命名云盘文件
     */
    @RequestMapping(value = "renamePan", method = {RequestMethod.POST})
    public void renamePan(HttpServletRequest request, HttpServletResponse response) {
        Boolean status = true;
        String info = null;
        try {
            String panId = request.getParameter("panId");
            String panName = request.getParameter("panName");
            UserPan userPan = userPanService.getById(panId);
            List<UserPan> list = userPanService.getByName(userPan.getDirId(), panName, getSelfId());
            if (list.size() > 0 && !list.get(0).getId().equals(panId)) {
                status = false;
                info = "文件重名!请更换文件名";
            } else {
                GlobalFunction.renameFile(GlobalConstant.USER_PAN_PATH, userPan.getName(), panName);
                userPan.setName(panName);
                userPanService.updateById(userPan);
            }
            Message msg = new Message();
            msg.setStatus(status);
            msg.setName(panName);
            msg.setInfo(info);
            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 重命名云盘目录
     */
    @RequestMapping(value = "renamePanDir", method = {RequestMethod.POST})
    public void renamePanDir(HttpServletRequest request, HttpServletResponse response) {
        Boolean status = true;
        String info = null;
        try {
            String dirId = request.getParameter("dirId");
            String dirName = request.getParameter("dirName");
            PanDir directory = panDirService.getById(dirId);
            List<PanDir> list = panDirService.getByName(getSelfId(), directory.getParentId(), dirName);
            if (list.size() > 0 && !list.get(0).getId().equals(dirId)) {
                status = false;
                info = "文件夹重名!请更换文件夹名";
            } else {
                directory.setName(dirName);
                int i = panDirService.update(directory);
                if (i != 1) {
                    status = false;
                    info = "更新数据库失败";
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

    /**
     * 删除云盘文件或目录
     */
    @RequestMapping(value = "removePan", method = {RequestMethod.POST})
    public void removePan(HttpServletRequest request, HttpServletResponse response) {
        Boolean status = true;
        String deleteId = request.getParameter("deleteId");
        //判断删除文件还是目录
        if (panDirService.getById(deleteId) != null) {
            //删除目录
            if (!deletePanFile(deleteId)) {
                status = false;
            }
        } else {
            //删除文件
            String fileName = userPanService.getById(deleteId).getName();
            String filePath = GlobalConstant.USER_PAN_PATH + "/" + fileName;
            if (!GlobalFunction.deleteSignalFile(filePath)) {
                status = false;
            }
            userPanService.removeById(deleteId);
        }
        try {
            // 保存日志
            logService.saveLog(request, GlobalConstant.LOG_PAN.type, GlobalConstant.LOG_PAN.FILE_DEL.getName(), getSelfId());
            Message msg = new Message();
            msg.setStatus(status);
            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            // 保存日志
            logService.saveLog(request, e, GlobalConstant.LOG_PAN.type, GlobalConstant.LOG_PAN.FILE_DEL.getName(), getSelfId());
            e.printStackTrace();
        }
    }
    /*---------   网盘管理区域（END）   ----------*/

    /*---------   消息管理区域（Start）   ----------*/

    /**
     * 通知UI
     */
    @RequestMapping(value = "notify", method = {RequestMethod.GET})
    public String toastUI() {
        return "user/accountNotify";
    }

    /**
     * 准备消息数据
     */
    @RequestMapping(value = "prepareNotify", method = {RequestMethod.GET})
    public void prepareNotify(HttpServletRequest request, HttpServletResponse response) {
        try {
            String type = request.getParameter("type");
            String pageStr = request.getParameter("pageNo");

            Page page = new Page();
            page.setTotalCount(notifyService.countByRecvId(getSelfId(),type));
            if(StringUtils.isBlank(pageStr)) {
                page.setCurrentPageNo(1);
            } else {
                page.setCurrentPageNo(Integer.parseInt(pageStr));
            }
            if(StringUtils.isBlank(type) || "全部".equals(type)) {
                type = null;
            }

            List<Notify> list = notifyService.listByRecvId(getSelfId(), type, null, page);
            Message message = new Message();
            message.setNotifies(list);
            message.setPage(page);
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 获得消息内容
     */
    @RequestMapping(value = "getNotifyContent", method = {RequestMethod.POST})
    public void getNotifyContent(HttpServletRequest request, HttpServletResponse response) {
        Message message = new Message();
        try {
            String id = request.getParameter("id");
            if (!StringUtils.isBlank(id)) {
                Notify notify = notifyService.getById(id);
                notify.setStatus(1);
                notifyService.update(notify);
                message.setStatus(true);
                message.setInfo(notify.getContent());
            } else {
                message.setStatus(false);
            }
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 标记单条消息为已读
     */
    @RequestMapping(value = "readNotify", method = {RequestMethod.POST})
    public void readNotify(HttpServletRequest request, HttpServletResponse response) {
        try {
            Message message = new Message();
            String id = request.getParameter("id");
            if (!StringUtils.isBlank(id)) {
                Notify notify = notifyService.getById(id);
                notify.setStatus(GlobalConstant.NOTIFY_STATUS.READ.getIndex());
                notifyService.update(notify);
                message.setStatus(true);
            } else {
                message.setStatus(false);
            }

            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 将指定类型消息全部标记为已读
     */
    @RequestMapping(value = "readNotifyByType", method = {RequestMethod.POST})
    public void readNotifyByType(HttpServletRequest request, HttpServletResponse response) {
        try {
            String type = request.getParameter("type");
            if("全部".equals(type)) {
                type = null;
            }
            Message message = new Message();
            List<Notify> list = notifyService.listByRecvId(getSelfId(), type, GlobalConstant.NOTIFY_STATUS.UNREAD.getIndex(), "");
            if (list != null) {
                for (Notify notify : list) {
                    notify.setStatus(GlobalConstant.NOTIFY_STATUS.READ.getIndex());
                    notifyService.update(notify);
                }
                message.setStatus(true);
            } else {
                message.setStatus(false);
            }
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    /**
     * 删除消息
     */
    @RequestMapping(value = "removeNotify", method = {RequestMethod.POST})
    public void removeNotify(HttpServletRequest request, HttpServletResponse response) {
        try {
            Message message = new Message();
            String id = request.getParameter("id");
            if (!StringUtils.isBlank(id)) {
                notifyService.removeById(id);
                message.setStatus(true);
            } else {
                message.setStatus(false);
            }

            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 删除选中消息
     */
    @RequestMapping(value = "removeChoose", method = {RequestMethod.GET})
    public String removeChoose(String[] ids) {
        for(String id : ids) {
            notifyService.removeById(id);
        }
        return "redirect:/user/notify";
    }

    /*---------   消息管理区域（END）   ----------*/
}