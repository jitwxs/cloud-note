package cn.edu.jit.global;

/**
 * 全局常量
 * @author jitwxs
 * @date 2018/1/2 20:32
 */
public class GlobalConstant {
    /**
     * 是否显示登陆信息
     */
    public static boolean HAS_SHOW_LOGIN_INFO = false;

    /**
     * 分享模板路径
     */
    public static String SHARE_TEMPLATE = null;

    /**
     * 临时文件夹路径
     */
    public static String TEMP_PATH = null;

    /**
     * 上传目录文件夹
     */
    public static String UPLOAD_PATH = null;

    /**
     * 用户家文件夹
     */
    public static String USER_HOME_PATH = null;

    /**
     * 用户图片文件夹
     */
    public static String USER_IMG_PATH = null;

    /**
     * 用户笔记文件夹
     */
    public static String USER_ARTICLE_PATH = null;

    /**
     * 用户网盘文件夹
     */
    public static String USER_PAN_PATH = null;

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
     * 短信签名
     */
    public static String LABEL_NAME = "无道云笔记";

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
     * 权限枚举
     */
    public static enum ROLE {
        /**
         * 管理员
         */
        ADMIN("admin",1),
        /**
         * 普通用户
         */
        USER("user",2);

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
     * 文章状态枚举
     */
    public static enum ARTICLE_STATUS {
        /**
         * 非分享
         */
        NOT_SHARE("not_share",0),
        /**
         * 分享
         */
        SHARE("share",1);

        private String name;
        private int index;

        private ARTICLE_STATUS(String name, int index) {
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
}
