package cn.edu.jit.global;

/**
 * 全局常量
 *
 * @author jitwxs
 * @date 2018/1/2 20:32
 */
public class GlobalConstant {
    /**
     * 服务器路径
     */
    public static String SER_URL = "http://127.0.0.1:8080";

    /**
     * 用户网盘默认大小：100MB
     */
    public static Integer DEFAULT_PAN_SIZE = 100 * 1024 * 1024;

    /**
     * 后台分页的页面容量
     */
    public static Integer PAGE_SIZE = 10;

    /**
     * 是否显示登陆信息
     */
    public static boolean HAS_SHOW_LOGIN_INFO = false;

    /**
     * 分享模板路径
     */
    public static String SHARE_TEMPLATE;

    /**
     * 临时文件夹路径
     */
    public static String TEMP_PATH;

    /**
     * 上传目录文件夹
     */
    public static String UPLOAD_PATH;

    /**
     * 用户家文件夹
     */
    public static String USER_HOME_PATH;

    /**
     * 用户图片文件夹
     */
    public static String USER_IMG_PATH;

    /**
     * 用户笔记文件夹
     */
    public static String USER_ARTICLE_PATH;

    /**
     * 用户笔记索引文件夹
     */
    public static String USER_ARTICLE_INDEX_PATH;

    /**
     * 用户笔记分享文件夹
     */
    public static String USER_SHARE_PATH;

    /**
     * 用户笔记附件文件夹
     */
    public static String USER_AFFIX_PATH;

    /**
     * 用户网盘文件夹
     */
    public static String USER_PAN_PATH;

    /**
     * 笔记后缀
     */
    public static String NOTE_SUFFIX = ".note";

    /**
     * 除pdf外的可转换后缀
     */
    public static String[] PREIVER_SUFFIX = {".bmp", ".png", ".jpg", ".jpeg", ".gif", ".htm", ".html"};

    /**
     * 根目录
     */
    public static String ROOT_DIR = "root";

    /**
     * 笔记默认内容
     */
    public static String ARTICLE_DEFAULT_CONTENT = "<p>欢迎使用 <b>无道云笔记</b></p>";

    /**
     * 每次显示分享的数目
     */
    public static Integer SHOW_SHARE_NUM = 7;

    /**
     * 笔记摘要长度
     */
    public static Integer NOTE_ABSTARCT_LENGTH = 50;

    /**
     * 短信签名
     */
    public static String LABEL_NAME = "无道云笔记";

    public static String GITHUB_CLIENT_ID = "6f66d56a89665725ffef";

    public static String GITHUB_CLIENT_SECRET = "09678e9c634fc777183ab4df930b858f83c0d1f1";

    public static String GITHUB_REDIRECT_URL = "http://127.0.0.1:8080/githubCallback";

    /**
     * 短信模板
     */
    public static String MOULD_ID = "SMS_120411170";

    /**
     * accessKeyId
     */
    public static final String ACCESS_KEY_ID = "LTAIxXurPn7JerWb";

    /**
     * accessKeySecret
     */
    public static final String ACCESS_KEY_SECRET = "faB9H3xj2DV8xbwcfWV76o0KOULmOL";

    /**
     * 产品名称:云通信短信API产品,开发者无需替换（短信服务）
     */
    public static final String PRODUCT = "Dysmsapi";

    /**
     * 产品域名,开发者无需替换（短信服务）
     */
    public static final String DOMAIN = "dysmsapi.aliyuncs.com";

    /**
     * 权限类型
     */
    public enum ROLE {
        /**
         * 管理员
         */
        ADMIN("admin", 1),
        /**
         * 普通用户
         */
        USER("user", 2);

        private String name;
        private int index;

        private ROLE(String name, int index) {
            this.name = name;
            this.index = index;
        }

        public String getName() {
            for (ROLE role : ROLE.values()) {
                if (role.getIndex() == index) {
                    return role.name;
                }
            }
            return null;
        }

        public void setName(String name) {
            this.name = name;
        }

        public int getIndex() {
            return index;
        }

        public void setIndex(int index) {
            this.index = index;
        }
    }

    /**
     * 原因类型
     */
    public enum REASON {
        /**
         * 封禁原因
         */
        ILLEGAL("封禁", 1),
        /**
         * 笔记原因
         */
        SHARE("分享", 2);

        private String name;
        private int index;

        private REASON(String name, int index) {
            this.name = name;
            this.index = index;
        }

        public String getName() {
            for (REASON reason : REASON.values()) {
                if (reason.getIndex() == index) {
                    return reason.name;
                }
            }
            return null;
        }

        public void setName(String name) {
            this.name = name;
        }

        public int getIndex() {
            return index;
        }

        public void setIndex(int index) {
            this.index = index;
        }
    }

    /**
     * 消息类型
     */
    public enum NOTIFY {
        /**
         * 系统消息
         */
        NOTIFY_SYSTEM("系统消息", 1),
        /**
         * 笔记消息
         */
        NOTIFY_NOTE("笔记消息", 2),
        /**
         * 其他消息
         */
        NOTIFY_OTHER("其他消息", 3);

        private String name;
        private int index;
        public static int type = 5;

        private NOTIFY(String name, int index) {
            this.name = name;
            this.index = index;
        }

        public String getName() {
            for (NOTIFY notify : NOTIFY.values()) {
                if (notify.getIndex() == index) {
                    return notify.name;
                }
            }
            return null;
        }

        public void setName(String name) {
            this.name = name;
        }

        public int getIndex() {
            return index;
        }

        public void setIndex(int index) {
            this.index = index;
        }
    }

    /**
     * 消息状态
     */
    public enum NOTIFY_STATUS {
        /**
         * 已读
         */
        READ("已读", 1),
        /**
         * 未读
         */
        UNREAD("未读", 2);

        private String name;
        private int index;

        private NOTIFY_STATUS(String name, int index) {
            this.name = name;
            this.index = index;
        }

        public String getName() {
            for (NOTIFY_STATUS notifyStatus : NOTIFY_STATUS.values()) {
                if (notifyStatus.getIndex() == index) {
                    return notifyStatus.name;
                }
            }
            return null;
        }

        public void setName(String name) {
            this.name = name;
        }

        public int getIndex() {
            return index;
        }

        public void setIndex(int index) {
            this.index = index;
        }
    }

    /**
     * 笔记状态
     */
    public enum NOTE_STATUS {
        /**
         * 非分享
         */
        NOT_SHARE("not_share", 0),
        /**
         * 分享
         */
        SHARE("share", 1);

        private String name;
        private int index;

        private NOTE_STATUS(String name, int index) {
            this.name = name;
            this.index = index;
        }

        public String getName() {
            for (NOTE_STATUS articleStatus : NOTE_STATUS.values()) {
                if (articleStatus.getIndex() == index) {
                    return articleStatus.name;
                }
            }
            return null;
        }

        public void setName(String name) {
            this.name = name;
        }

        public int getIndex() {
            return index;
        }

        public void setIndex(int index) {
            this.index = index;
        }
    }

    /**
     * 系统日志
     */
    public enum LOG_SYSTEM {
        /**
         * 取消分享
         */
        SHARE_CANCEL("取消分享", 1),
        /**
         * 删除分享
         */
        SHARE_DEL("删除分享", 2),
        /**
         * 删除用户
         */
        USER_DEL("删除用户", 3),
        /**
         * 封禁用户
         */
        USER_BLOCK("封禁用户", 4),
        /**
         * 取消封禁
         */
        CANCEL_BLOCK("取消封禁", 5);


        private String name;
        private int index;
        public static int type = 1;

        private LOG_SYSTEM(String name, int index) {
            this.name = name;
            this.index = index;
        }

        public String getName() {
            for (LOG_SYSTEM logSystem : LOG_SYSTEM.values()) {
                if (logSystem.getIndex() == index) {
                    return logSystem.name;
                }
            }
            return null;
        }

        public void setName(String name) {
            this.name = name;
        }

        public int getIndex() {
            return index;
        }

        public void setIndex(int index) {
            this.index = index;
        }
    }

    /**
     * 用户日志
     */
    public enum LOG_USER {
        /**
         * 用户登陆
         */
        USER_LOGIN("用户登陆", 1),
        /**
         * 用户注册
         */
        USER_REG("用户注册", 2),
        /**
         * 找回密码
         */
        FIND_PASSWORD("找回密码", 3),
        /**
         * 重置密码
         */
        RESET_PASSWORD("重置密码", 4),
        /**
         * 修改信息
         */
        MODIFY_INFO("修改信息", 5);

        private String name;
        private int index;
        public static int type = 2;

        private LOG_USER(String name, int index) {
            this.name = name;
            this.index = index;
        }

        public String getName() {
            for (LOG_USER logUser : LOG_USER.values()) {
                if (logUser.getIndex() == index) {
                    return logUser.name;
                }
            }
            return null;
        }

        public void setName(String name) {
            this.name = name;
        }

        public int getIndex() {
            return index;
        }

        public void setIndex(int index) {
            this.index = index;
        }
    }

    /**
     * 笔记日志
     */
    public enum LOG_NOTE {
        /**
         * 创建笔记
         */
        CREATE_NOTE("创建笔记", 1),
        /**
         * 永久删除
         */
        FOREVER_REMOVE_NOTE("永久删除", 2),
        /**
         * 分享笔记
         */
        SHARE_NOTE("分享笔记", 3),
        /**
         * 取消分享
         */
        CANCEL_SHARE_NOTE("取消分享", 4),
        /**
         * 上传笔记
         */
        UPLOAD_NOTE("上传笔记", 5),
        /**
         * 上传附件
         */
        UPLOAD_AFFIX("上传附件", 6);

        private String name;
        private int index;
        public static int type = 3;

        private LOG_NOTE(String name, int index) {
            this.name = name;
            this.index = index;
        }

        public String getName() {
            for (LOG_NOTE logNote : LOG_NOTE.values()) {
                if (logNote.getIndex() == index) {
                    return logNote.name;
                }
            }
            return null;
        }

        public void setName(String name) {
            this.name = name;
        }

        public int getIndex() {
            return index;
        }

        public void setIndex(int index) {
            this.index = index;
        }
    }

    /**
     * 网盘日志
     */
    public enum LOG_PAN {
        /**
         * 上传文件
         */
        FILE_UPLOAD("上传文件", 1),
        /**
         * 下载文件
         */
        FILE_DOWNLOAD("下载文件", 2),
        /**
         * 删除文件
         */
        FILE_DEL("删除文件", 3);

        private String name;
        private int index;
        public static int type = 4;

        private LOG_PAN(String name, int index) {
            this.name = name;
            this.index = index;
        }

        public String getName() {
            for (LOG_PAN logPan : LOG_PAN.values()) {
                if (logPan.getIndex() == index) {
                    return logPan.name;
                }
            }
            return null;
        }

        public void setName(String name) {
            this.name = name;
        }

        public int getIndex() {
            return index;
        }

        public void setIndex(int index) {
            this.index = index;
        }
    }
}
