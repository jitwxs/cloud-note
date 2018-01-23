package cn.edu.jit.web;

import cn.edu.jit.dto.ArticleDto;
import cn.edu.jit.entry.*;
import cn.edu.jit.global.GlobalConstant;
import cn.edu.jit.global.GlobalFunction;
import cn.edu.jit.service.*;
import cn.edu.jit.util.*;
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
import java.text.DecimalFormat;
import java.util.*;

/**
 * 用户控制层
 * @author jitwxs
 * @date 2018/1/3 13:10
 */

@Controller
@RequestMapping(value = "/user")
public class  UserController {

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

    @Resource (name = "articleRecycleServiceImpl")
    private ArticleRecycleService articleRecycleService;

    @Resource (name = "fileConvertServiceImpl")
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
     * @param directoryTree 树根
     */
    private void initDirectoryTree(DirectoryTree directoryTree) {
        String uid = getSelfId();
        String dirId = directoryTree.getId();

        List<ArticleDir> childDirs = articleDirService.listByParentId(uid, dirId, "create_date desc");
        List<Article> articles = articleService.listArticleByDir(uid, dirId, "create_date desc");
        if(childDirs.size() ==0 && articles.size() == 0) {
            return;
        }
        for (Article article: articles) {
            DirectoryTree dt = new DirectoryTree(article.getId(),article.getTitle());
            dt.setData(null);
            directoryTree.addData(dt);
        }
        for (ArticleDir childDir: childDirs) {
            DirectoryTree dt = new DirectoryTree(childDir.getId(), childDir.getName());
            initDirectoryTree(dt);
            directoryTree.addData(dt);
        }
    }

    /**
     * 生成移动笔记目录树
     * @param directoryTree 树根
     */
    private void moveDirectoryTree(DirectoryTree directoryTree) {
        String uid = getSelfId();
        String dirId = directoryTree.getId();

        List<ArticleDir> childDirs = articleDirService.listByParentId(uid, dirId, "create_date desc");
        for (ArticleDir childDir: childDirs) {
            DirectoryTree dt = new DirectoryTree(childDir.getId(), childDir.getName());
            moveDirectoryTree(dt);
            directoryTree.addData(dt);
        }
    }

    /**
     * 生成云盘目录树
     * @param directoryTree 树根
     */
    private void initPanDirectoryTree(DirectoryTree directoryTree) {
        String uid = getSelfId();
        String dirId = directoryTree.getId();

        List<PanDir> childDirs = panDirService.listByParentId(uid, dirId);
        List<UserPan> userPans = userPanService.listUserPanByDir(uid, dirId);
        if(childDirs.size() == 0 && userPans.size() == 0) {
            return;
        }
        for (UserPan userPan: userPans) {
            DirectoryTree dt = new DirectoryTree(userPan.getId(),userPan.getName());
            dt.setData(null);
            directoryTree.addData(dt);
        }
        for (PanDir childDir: childDirs) {
            DirectoryTree dt = new DirectoryTree(childDir.getId(), childDir.getName());
            initPanDirectoryTree(dt);
            directoryTree.addData(dt);
        }
    }

    /**
     * 递归删除云盘目录
     */
    private boolean deletePanFile(String dirId){
        List<UserPan> userPans = userPanService.listUserPanByDir(getSelfId(),dirId);
        List<PanDir> panDirs = panDirService.listByParentId(getSelfId(),dirId);
        for (UserPan userPan: userPans) {
            String path = GlobalConstant.USER_PAN_PATH + "/" +userPan.getId();
            if (GlobalFunction.deleteSignalFile(path)) {
                userPanService.removeById(userPan.getId());
            } else {
                return false;
            }
        }
        for (PanDir panDir: panDirs) {
            deletePanFile(panDir.getId());
        }
        panDirService.remove(dirId);
        return true;
    }

    /**
     * 初始化笔记摘要
     */
    private String getAbstractText(ArticleDto articleDto) {
        StringBuilder result = new StringBuilder();
        try{
            char[] buf = new char[1024];
            boolean flag = true;

            String url = articleDto.getShareUrl();
            InputStreamReader isr = new InputStreamReader(new FileInputStream(url), "UTF-8");

            while(isr.read(buf,0,buf.length) > 0 && result.length() <= GlobalConstant.NOTE_ABSTARCT_LENGTH) {
                String temp = String.valueOf(buf);
                if(!flag) {
                    result.append(GlobalFunction.getChineseFromHtml(temp));
                } else if(flag && temp.contains("</title>")) {
                    result.append(GlobalFunction.getChineseFromHtml(temp.substring(temp.indexOf("</title>"))));
                    flag = false;
                }
            }
            isr.close();
            int len = GlobalConstant.NOTE_ABSTARCT_LENGTH >= result.length() ? result.length() : GlobalConstant.NOTE_ABSTARCT_LENGTH;
            return result.substring(0, len);
        } catch (Exception e) {
            return GlobalFunction.getStackTraceAsString(e);
        }
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
     * @param noteId 笔记id
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
        String iconRealUrl = "";
        if(!StringUtils.isBlank(iconUrl)){
            iconRealUrl = GlobalFunction.getRealUrl(iconUrl);
        }

        String inputPath = GlobalConstant.USER_ARTICLE_PATH + "/" + noteId + "/" + title + GlobalConstant.NOTE_SUFFIX;

        // 如果输出路径为空，则新建笔记分享页面，否则更新到输出路径中
        if(StringUtils.isBlank(outputPath)) {
            outputPath = GlobalConstant.USER_SHARE_PATH + "/" + GlobalFunction.getUUID() + ".html";
        }

        BufferedReader br = new BufferedReader(new FileReader(GlobalConstant.SHARE_TEMPLATE));
        InputStreamReader isr = new InputStreamReader(new FileInputStream(inputPath), "UTF-8");
        OutputStreamWriter osw = new OutputStreamWriter(new FileOutputStream(outputPath),"UTF-8");

        while((temp = br.readLine()) != null) {
            osw.write(temp);
            switch (temp) {
                case "<!-- title -->":
                case "<title>":
                        osw.write(title);
                        break;
                case "<!-- userIcon -->":
                        if(!StringUtils.isBlank(iconRealUrl)) {
                            osw.write("<img class='user_icon' style='width: 50px;height: 50px;border-radius:50%' src="+iconRealUrl+">");
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
                        while((len = isr.read(buf)) > 0) {
                            osw.write(buf, 0, len);
                        }
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

    private List<Article> getArticleList(List<String> ids) {
        List<Article> list = new ArrayList<>();
        for(String id : ids) {
            Article article = articleService.getById(id);
            if(article != null) {
                list.add(article);
            }
        }
        return list;
    }

    /**
     * 多个笔记list集合转一个set（去重）
     */
    private List<Article> lists2Set(List<Article> list1, List<Article> list2) {
        Set<Article> set = new HashSet<>();
        set.addAll(list1);
        set.addAll(list2);
        System.out.println(set.size());

        return new ArrayList<>(set);
    }

    /**
     * 随机取num个从0到maxVal的整数。包括零，不包括maxValue
     */
    public static List<Integer> random(int num,int maxValue){
        if(num>maxValue ){
            num=maxValue;
        }
        if(num<0 || maxValue<0){
            throw new RuntimeException("num or maxValue must be greater than zero");
        }
        List<Integer> result = new ArrayList<Integer>(num);

        int[] tmpArray = new int[maxValue];
        for(int i=0;i<maxValue;i++){
            tmpArray[i]=i;
        }

        Random random = new Random();
        for(int i=0;i<num;i++){
            int index =  random.nextInt(maxValue-i);
            int tmpValue = tmpArray[index];
            result.add(tmpValue);
            int lastIndex = maxValue-i-1;
            if(index==lastIndex){
                continue;
            }else{
                tmpArray[index]=tmpArray[lastIndex];
            }

        }


        return result;
    }

    /*---------   普通方法区域（END）   ----------*/

    @RequestMapping(value = "index")
    public String index(HttpServletRequest request, HttpServletResponse response) {
        String data = GlobalFunction.getDate2Second(null);
        data = data.replace(' ', '#');
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

    /*---------   用户管理区域（END）   ----------*/

    /*---------   笔记管理区域（START）   ----------*/
    /**
     * 初始化笔记目录树
     */
    @RequestMapping(value = "initArticleDir", method = {RequestMethod.GET})
    public void initArticleDir(HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        Message message = new Message();
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
     * 初始化移动笔记目录树
     */
    @RequestMapping(value = "initMoveArticleDir", method = {RequestMethod.GET})
    public void initMoveArticleDir(HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        try {
            // 顶层目录 id:root name:我的文件夹
            DirectoryTree directoryTree = new DirectoryTree("root","我的文件夹");
            moveDirectoryTree(directoryTree);
            String data = JSON.toJSONString(directoryTree, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        }catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 初始化回收站文件
     */
    @RequestMapping(value = "initRecycleFile", method = {RequestMethod.GET})
    public void initRecycleFile(HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        try {
            String uid = getSelfId();
            List<ArticleRecycle> lists = articleRecycleService.listSelfRecycle(uid);
            String data = JSON.toJSONString(lists, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        }catch (IOException e) {
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
        response.setContentType("text/html;charset=utf-8");
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
        response.setContentType("text/html;charset=utf-8");
        Message msg = new Message();
        Boolean status = true;
        String info = null;
        try {
            // 所属目录id
            String dirId = request.getParameter("parentId");
            String noteName = request.getParameter("noteName");
            String id = GlobalFunction.getUUID();
            String articleDir = GlobalConstant.USER_ARTICLE_PATH + "/" + id;
            String articlePath = articleDir + "/" + noteName + ".note";

            List<Article> articles = articleService.listArticleByName(getSelfId(), dirId, noteName);
            if (articles.size() != 0) {
                status = false;
                info = "笔记重名，请更换笔记名！";
            } else {
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
                    info = "数据库更新失败！";
                }
                // 创建笔记目录
                GlobalFunction.createDir(articleDir);
                // 初始化笔记内容
                OutputStreamWriter bw = new OutputStreamWriter(new FileOutputStream(articlePath), "UTF-8");
                bw.write(GlobalConstant.ARTICLE_DEFAULT_CONTENT);
                bw.close();

                // 保存日志
                logService.saveLog(request, GlobalConstant.LOG_NOTE.type, GlobalConstant.LOG_NOTE.CREATE_NOTE.getName(), getSelfId());
            }
            msg.setStatus(status);
            msg.setNoteId(id);
            msg.setInfo(info);
            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        }catch (IOException e) {
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
                articleDto.setAuthorName(userService.getById(article.getUserId()).getName());
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
        String info = null;
        try {
            String noteId = request.getParameter("noteId");
            String noteName = request.getParameter("noteName");
            Article article = articleService.getById(noteId);
            List<Article> articles = articleService.listArticleByName(getSelfId(), article.getDirId(), noteName);
            if (articles.size() != 0 && !articles.get(0).getId().equals(noteId)) {
                status = false;
                info = "笔记重名，请更换笔记名！";
            } else{
                if(articles.size() == 0 || !articles.get(0).getId().equals(noteId)) {
                    boolean flag = GlobalFunction.renameFile(GlobalConstant.USER_ARTICLE_PATH + "/" + noteId,
                            article.getTitle() + GlobalConstant.NOTE_SUFFIX, noteName + GlobalConstant.NOTE_SUFFIX);
                    if (flag) {
                        article.setTitle(noteName);
                        if (articleService.update(article) != 1) {
                            status = false;
                            info = "数据库更新失败！";
                        }
                    } else {
                        status = false;
                        info = "服务器更新失败！";
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
                        if (StringUtils.isBlank(fileName)) {
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
        String info = "";
        Article article = null;
        response.setContentType("text/html;charset=utf-8");
        try {
            // 排除笔记信息错误
            if (StringUtils.isBlank(noteId) || StringUtils.isBlank(noteName)) {
                status = false;
                info = "获取笔记信息失败";
            } else {
                // 排除重名
                article = articleService.getById(noteId);
                List<Article> articles = articleService.listArticleByName(getSelfId(), article.getDirId(), noteName);
                if (articles.size() != 0 && !articles.get(0).getId().equals(noteId)) {
                    status = false;
                    info = "笔记重名";
                }
            }

            if(status) {
                // 1.更新笔记数据库
                String content = request.getParameter("data");
                if(!article.getTitle().equals(noteName)) {
                    String dirPath = GlobalConstant.USER_ARTICLE_PATH + "/" + noteId;
                    String oldName = article.getTitle() + GlobalConstant.NOTE_SUFFIX;
                    String newName = noteName + GlobalConstant.NOTE_SUFFIX;
                    GlobalFunction.renameFile(dirPath, oldName, newName);
                    article.setTitle(noteName);
                }
                articleService.update(article);

                //2. 更新笔记文件
                String targetFilePath = GlobalConstant.USER_ARTICLE_PATH + "/" + noteId + "/" + noteName + GlobalConstant.NOTE_SUFFIX;
                OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream(targetFilePath), "UTF-8");
                writer.write(content);
                writer.flush();
                writer.close();

                // 3.更新分享页面
                if(article.getIsOpen() == GlobalConstant.NOTE_STATUS.SHARE.getIndex()) {
                    String url = article.getShareUrl();
                    if(url != null) {
                        createSharePage(noteId, url);
                    }
                }

                // 4.更新笔记标签
                String editorTags = request.getParameter("tag");
                articleTagService.removeAllByArticleId(noteId);
                if(!StringUtils.isBlank(editorTags)) {
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
            response.setContentType("text/html;charset=utf-8");
            String noteId = request.getParameter("noteId");
            ArticleRecycle articleRecycle = new ArticleRecycle();
            Article article = articleService.getById(noteId);
            BeanUtils.copyProperties(article, articleRecycle);

            // 从笔记表移除并加入笔记回收表
            if(articleService.removeById(noteId) == 1 && articleRecycleService.save(articleRecycle) == 1) {
                status = true;
            }
            Message msg = new Message();
            msg.setStatus(status);
            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        }catch (Exception e) {
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
            response.setContentType("text/html;charset=utf-8");
            String noteId = request.getParameter("noteId");

            // 从数据库中移除
            if(!StringUtils.isBlank(noteId)) {
                if(articleRecycleService.removeById(noteId) == 1) {
                    status = true;
                }
            }

            // 保存日志
            logService.saveLog(request, GlobalConstant.LOG_NOTE.type, GlobalConstant.LOG_NOTE.FOREVER_REMOVE_NOTE.getName(), getSelfId());

            // 删除笔记所在目录
            String path = GlobalConstant.USER_ARTICLE_PATH  + "/" + noteId;
            FileUtils.deleteQuietly(new File(path));

            Message msg = new Message();
            msg.setStatus(status);
            String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        }catch (Exception e) {
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
            response.setContentType("text/html;charset=utf-8");
            String noteId = request.getParameter("noteId");

            if(!StringUtils.isBlank(noteId)) {
                ArticleRecycle articleRecycle = articleRecycleService.getById(noteId);
                Article article = new Article();
                BeanUtils.copyProperties(articleRecycle, article);
                List<Article> list = articleService.listArticleByName(getSelfId(), articleRecycle.getDirId(), articleRecycle.getTitle());
                if (list.size() !=0) {
                    for (int i = 1; ; i++) {
                        List<Article> lists = articleService.listArticleByName(getSelfId(), articleRecycle.getDirId(), articleRecycle.getTitle() + "(" + i + ")");
                        if (lists.size() == 0) {
                            article.setTitle(article.getTitle() + "(" + i + ")");
                            break;
                        }
                    }
                }
                if(articleRecycleService.removeById(noteId) == 1 && articleService.save(article) == 1) {
                    if(article.getDirId() != null) {
                        msg.setInfo(article.getDirId());
                        msg.setName(article.getTitle());
                    }
                    status = true;
                }
                msg.setStatus(status);
                String data = JSON.toJSONString(msg, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
                response.getWriter().write(data);
            }
        }catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 清空回收站
     */
    @RequestMapping(value = "clearRubbish", method = {RequestMethod.GET})
    public void clearRubbish( HttpServletResponse response) {
        try {
            String uid = getSelfId();
            Message message = new Message();
            if(!StringUtils.isBlank(uid)) {
                response.setContentType("text/html;charset=utf-8");

                List<ArticleRecycle> list = articleRecycleService.listSelfRecycle(uid);
                for (ArticleRecycle articleRecycle : list) {
                    String articleId = articleRecycle.getId();
                    String dirPath = GlobalConstant.USER_ARTICLE_PATH + "/" + articleId;
                    FileUtils.deleteQuietly(new File(dirPath));
                    articleRecycleService.removeById(articleId);
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
        Message message = new Message();
        Boolean status = false;
        try {
            Article article = articleService.getById(noteId);
            if(article != null) {
                // 如果文章已经分享，无需再次分享
                if(article.getIsOpen() == GlobalConstant.NOTE_STATUS.SHARE.getIndex()) {
                    status = true;

                    String realUrl = GlobalFunction.getRealUrl(article.getShareUrl());
                    message.setInfo(realUrl);
                } else if(article.getIsOpen() == GlobalConstant.NOTE_STATUS.NOT_SHARE.getIndex()) {
                    String url = createSharePage(noteId, null);
                    if(!StringUtils.isBlank(url)) {
                        // 更新数据库
                        article.setIsOpen(GlobalConstant.NOTE_STATUS.SHARE.getIndex());
                        article.setShareUrl(url);
                        articleService.update(article);

                        // 保存日志
                        logService.saveLog(request, GlobalConstant.LOG_NOTE.type, GlobalConstant.LOG_NOTE.SHARE_NOTE.getName(), getSelfId());

                        String realUrl = GlobalFunction.getRealUrl(url);
                        message.setInfo(realUrl);
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
        response.setContentType("text/html;charset=utf-8");
        String noteId = request.getParameter("noteId");
        Message message = new Message();
        try {
            // 更新数据库
            Article article = articleService.getById(noteId);
            if(article == null) {
                message.setStatus(false);
            } else {
                article.setIsOpen(GlobalConstant.NOTE_STATUS.NOT_SHARE.getIndex());
                String url = article.getShareUrl();
                if(!StringUtils.isBlank(url)) {
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
        response.setContentType("text/html;charset=utf-8");
        try {
            String userId = getSelfId();
            List<Article> lists = articleService.listArticleByShare(userId);

            // 提取url相对路径
            for(Article article : lists) {
                String url = article.getShareUrl();
                String realUrl = GlobalFunction.getRealUrl(url);
                article.setShareUrl(realUrl);
            }

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
    @RequestMapping(value = "showOtherShareNote", method = {RequestMethod.GET})
    public void showOtherShareNote(HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        try {
            String userId = getSelfId();
            List<Article> lists = articleService.listAnotherShareArticle(userId);
            Message message = new Message();
            if(lists.size() == 0) {
                message.setStatus(false);
            } else {
                List<ArticleDto> articleDtos = new ArrayList<>();
                // 随机取SHOW_SHARE_NUM个笔记

                List<Integer> shareNOs = random(GlobalConstant.SHOW_SHARE_NUM, lists.size());
                for(Integer no : shareNOs) {
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
                    if(!StringUtils.isBlank(iconUrl)) {
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
        String path;
        String noteId = null;
        response.setContentType("text/html;charset=utf-8");
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
                            if(StringUtils.isBlank(fieldName)) {
                                break;
                            } else {
                                noteId = fieldValue;
                            }
                        } else {
                            if(!StringUtils.isBlank(noteId)) {
                                String fileName = item.getName();
                                // 出国文件名长度超长，只取最后位数
                                if(fileName.length() > 64) {
                                    fileName = fileName.substring(fileName.length()-63);
                                }
                                // 如果文件名为空，就跳过
                                if (StringUtils.isBlank(fileName)) {
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
        response.setContentType("text/html;charset=utf-8");
       try {
           if(affixId == null) {
               message.setStatus(false);
           } else {
               ArticleAffix articleAffix = articleAffixService.getById(affixId);
               // 数据库中文件绝对路径
               String path = articleAffix.getPath();

               // 用来判断文件后缀的临时变量
               String temp = path.toLowerCase();
               Boolean pdfFlag, previewFlag = false;

               // 判断是否是除pdf外的可转换后缀
               for (String ss : GlobalConstant.PREIVER_SUFFIX) {
                   if(temp.endsWith(ss)) {
                       previewFlag = true;
                       break;
                   }
               }
               // 判断是否是pdf后缀
               pdfFlag = temp.endsWith(".pdf");

               if(pdfFlag) {
                   int i = path.indexOf("upload");
                   String url = GlobalConstant.SER_URL + "/generic/web/viewer.html?file=/" + path.substring(i);
                   message.setInfo(url);
                   message.setStatus(true);
               } else if(previewFlag) {
                   String realUrl = GlobalFunction.getRealUrl(path);
                   message.setInfo(realUrl);
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
                       String url = GlobalConstant.SER_URL + "/generic/web/viewer.html?file=/" + convertedPath.substring(i);
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
            if(StringUtils.isBlank(content)) {
                message.setStatus(false);
            } else {
                // 查询笔记名
                List<Article> listByName = articleService.listArticleByTitle(getSelfId(),content);

                // 查询笔记标签
                List<Article> listByTitle = articleService.listArticleByTagName(getSelfId(),content);

                // 文件内容搜索
                LuceneUtils.prepareIndex(GlobalConstant.USER_ARTICLE_INDEX_PATH);
                LuceneUtils.createIndex(GlobalConstant.USER_ARTICLE_PATH, GlobalConstant.USER_ARTICLE_INDEX_PATH);
                List<String> ids = LuceneUtils.searchIndex(content, GlobalConstant.USER_ARTICLE_INDEX_PATH);
                List<Article> contentList = getArticleList(ids);

                // 求集合的并集
                List<Article> tempList = lists2Set(listByName, listByTitle);
                List<Article> result = lists2Set(tempList, contentList);

                if(result.size() == 0) {
                    message.setStatus(false);
                } else {
                    message.setStatus(true);
                    message.setArticles(result);
                }
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
        Message msg = new Message();
        Boolean status = true;
        String info = null;
        try {
            String parentId = request.getParameter("parentId");
            String dirName = request.getParameter("dirName");

            ArticleDir directory = new ArticleDir();
            List<ArticleDir> articleDir = articleDirService.getByName(getSelfId(),parentId,dirName);
            if ( articleDir.size()!= 0) {
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
                if(i != 1) {
                    status = false;
                    info = "数据库更新失败";
                }
                msg.setDirId(dirId);
            }
            msg.setStatus(status);
            msg.setInfo(info);
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
            ArticleDir directory = articleDirService.getById(dirId);
            String parentDir = directory.getParentId();
            changeAllNoteDir(directory, parentDir);

            // 2.删除目录及其子目录
            int i = articleDirService.remove(dirId);
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
        Message msg = new Message();
        Boolean status = true;
        String info = null;
        try {
            String dirId = request.getParameter("dirId");
            String dirName = request.getParameter("dirName");
            ArticleDir directory = articleDirService.getById(dirId);
            List<ArticleDir> articleDirs = articleDirService.getByName(getSelfId(),directory.getParentId(),dirName);
            if (articleDirs.size() != 0 && !articleDirs.get(0).getId().equals(dirId)) {
                status = false;
                info = "目录重名，请更换目录名！";
            } else {
                directory.setName(dirName);
                int i = articleDirService.update(directory);
                if(i != 1) {
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
        response.setContentType("text/html;charset=utf-8");
        String id = request.getParameter("dirId");
        try {
            // 顶层目录 id:root name:我的网盘
            DirectoryTree directoryTree = new DirectoryTree(id,"我的网盘");
            initPanDirectoryTree(directoryTree);
            String data = JSON.toJSONString(directoryTree, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        }catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 初始化用户网盘空间
     */
    @RequestMapping(value = "initUserPanSize", method = {RequestMethod.GET})
    public void initUserPanSize(HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        try {
            String uid = getSelfId();
            String perfect;
            Integer size = userPanService.countUsedSize(uid);
            if(size == null) {
                perfect = "0";
            } else {
                DecimalFormat df=new DecimalFormat("0.00");
                perfect = df.format((float)size / GlobalConstant.DEFAULT_PAN_SIZE * 100);
            }

            Map<String, Object> map = new HashMap<>(16);
            map.put("size", GlobalConstant.DEFAULT_PAN_SIZE);
            map.put("usedPerfect", perfect);

            String data = JSON.toJSONString(map, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        }catch (IOException e) {
            e.printStackTrace();
        }
    }


    /**
     * 上传云盘文件
     */
    @RequestMapping(value = "uploadPan", method = {RequestMethod.POST})
    public void uploadPan(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
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
                            List<UserPan> list = userPanService.getByName(dirId, fileName,getSelfId());
                            String name = fileName .substring(0,fileName .lastIndexOf("."));
                            String prefix=fileName.substring(fileName.lastIndexOf("."));
                            if (!list.isEmpty()) {
                                for (int i = 1; ; i++) {
                                    String tempName = name + "(" + Integer.toString(i) + ")" + prefix;
                                    List<UserPan> list1 = userPanService.getByName(dirId, tempName,getSelfId());
                                    if (list1.isEmpty()) {
                                        fileName = name + "(" + Integer.toString(i) + ")" + prefix;
                                        break;
                                    }
                                }
                            }
                            String userPanId = GlobalFunction.getUUID();
                            String filePath = GlobalConstant.USER_PAN_PATH + "/" + userPanId;

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
        // 设置编码（如果文件名乱码，尝试打开解决问题）
        // fileName = new String(fileName.getBytes("ISO8859-1"),"UTF-8");
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
            String path = GlobalConstant.USER_PAN_PATH + "/" + userPanId;
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
        response.setContentType("text/html;charset=utf-8");
        String searchKey = request.getParameter("searchKey");
        try {
            Message message = new Message();
            if(StringUtils.isBlank(searchKey)) {
                message.setStatus(false);
            } else {
                // 查询文件
                List<UserPan> userPans = userPanService.listUserPanByTitle(getSelfId(),searchKey);
                // 查询文件夹
                ArrayList<DirectoryTree> list = new  ArrayList<>();
                List<PanDir> panDirs = panDirService.listPanDirByTitle(getSelfId(),searchKey);
                for (PanDir panDir :panDirs) {
                    DirectoryTree directoryTree = new DirectoryTree(panDir.getId(),panDir.getName());
                    list.add(directoryTree);
                }

                if(userPans.size() == 0 && panDirs.size() == 0) {
                    message.setStatus(false);
                } else {
                    message.setStatus(true);
                    message.setDirectoryTrees(list);
                    message.setUserFiles(userPans);
                }
            }
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        }catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 新建云盘目录
     */
    @RequestMapping(value = "createPanDir", method = {RequestMethod.POST})
    public void createPanDir(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
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
            } else{
                PanDir directory = new PanDir();
                String dirId = GlobalFunction.getUUID();
                directory.setId(dirId);
                directory.setName(dirName);
                directory.setUid(getSelfId());
                directory.setParentId(parentId);
                directory.setCreateDate(new Date());
                int i = panDirService.save(directory);
                if(i != 1) {
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
        }catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 重命名云盘文件
     */
    @RequestMapping(value = "renamePan", method = {RequestMethod.POST})
    public void renamePan(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
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
                userPan.setName(panName);
                if (userPanService.updateById(userPan) != 1) {
                    status = false;
                    info = "数据库重命名失败";
                }
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
        response.setContentType("text/html;charset=utf-8");
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
            } else{
                directory.setName(dirName);
                int i = panDirService.update(directory);
                if(i != 1) {
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
        response.setContentType("text/html;charset=utf-8");
        Boolean status = true;
        String deleteId = request.getParameter("deleteId");
        //判断删除文件还是目录
        if (panDirService.getById(deleteId) != null) {
            //删除目录
            if(!deletePanFile(deleteId)) {
                status = false;
            }
        } else {
            //删除文件
            if (!GlobalFunction.deleteSignalFile(GlobalConstant.USER_PAN_PATH + "/" + deleteId)) {
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
    public void prepareNotify(HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        try {
            List<Notify> list = notifyService.listByRecvId(getSelfId(), "create_date desc");
            Message message = new Message();
            message.setNotifies(list);
            String data = JSON.toJSONString(message, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
            response.getWriter().write(data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 准备消息数据
     */
    @RequestMapping(value = "prepareNotifyByType", method = {RequestMethod.GET})
    public void prepareNotifyByType(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        try {
            String type = request.getParameter("dataType");
            List<Notify> list = notifyService.listByRecvIdAndType(getSelfId(), type, "create_date desc");
            String data = JSON.toJSONString(list, SerializerFeature.DisableCircularReferenceDetect, SerializerFeature.WriteDateUseDateFormat);
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
        response.setContentType("text/html;charset=utf-8");
        Message message = new Message();
        try {
            String id = request.getParameter("id");
            if(!StringUtils.isBlank(id)) {
                Notify notify = notifyService.getById(id);
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
     * 标记消息为已读
     */
    @RequestMapping(value = "readNotify", method = {RequestMethod.POST})
    public void readNotify(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        try {
            Message message = new Message();
            String id = request.getParameter("id");
            if(!StringUtils.isBlank(id)) {
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
     * 删除消息
     */
    @RequestMapping(value = "removeNotify", method = {RequestMethod.POST})
    public void removeNotify(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        try {
            Message message = new Message();
            String id = request.getParameter("id");
            if(!StringUtils.isBlank(id)) {
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
    /*---------   消息管理区域（END）   ----------*/
}