<<<<<<< HEAD
package cn.edu.jit.global;

import cn.edu.jit.entry.Login;
import cn.edu.jit.entry.User;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.io.IOUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.UUID;

/**
 * 全局方法
 * @author jitwxs
 * @date 2018/1/2 22:33
 */
public class GlobalFunction {

    /**
     * 获取UUID
     * @return 返回UUID
     */
    public static String getUUID() {
        String uuid = UUID.randomUUID().toString();
        return uuid.replaceAll("-", "");
    }

    public static User login2User(Login login) {
        User user = new User();
        user.setTel(login.getTel());
        user.setId(GlobalFunction.getUUID());
        user.setCreateDate(login.getCreateDate());
        return user;
    }

    /**
     * 获取登陆用户手机号码
     * @return
     */
    public static String getSelfTel() {
        Subject subject = SecurityUtils.getSubject();
        return (String) subject.getPrincipal();
    }

    /**
     * 上传文件
     * @param item FileItem对象
     * @param targetFilePath 要存放的文件路径
     * @throws IOException 流异常
     */
    public static void uploadFile(FileItem item, String targetFilePath) throws IOException{
        // 如果目录不存在，先创建目录，mkdirs支持多级目录创建
        File file = new File(targetFilePath);
        if (!file.getParentFile().exists()) {
            file.getParentFile().mkdirs();
        }

        // 拷贝数据
        InputStream in = item.getInputStream();
        OutputStream out = new FileOutputStream(targetFilePath);
        IOUtils.copy(in, out);
        in.close();
        out.close();

        // 删除临时文件
        item.delete();
    }
}
=======
package cn.edu.jit.global;

import cn.edu.jit.entry.Login;
import cn.edu.jit.entry.User;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.io.IOUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;
import java.util.UUID;

/**
 * 全局方法
 * @author jitwxs
 * @date 2018/1/2 22:33
 */
public class GlobalFunction {

    public static String getUUID() {
        String uuid = UUID.randomUUID().toString();
        return uuid.replaceAll("-", "");
    }

    public static String getDate() {
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd#HH:mm:ss");
        return sdf.format(date);
    }

    public static User login2User(Login login) {
        User user = new User();
        user.setTel(login.getTel());
        user.setId(GlobalFunction.getUUID());
        user.setCreateDate(login.getCreateDate());
        return user;
    }

    /**
     * 获取登陆用户手机号码
     * @return
     */
    public static String getSelfTel() {
        Subject subject = SecurityUtils.getSubject();
        return (String) subject.getPrincipal();
    }

    /**
     * 上传文件
     * @param item FileItem对象
     * @param targetFilePath 要存放的文件路径
     * @throws IOException 流异常
     */
    public static void uploadFile(FileItem item, String targetFilePath) throws IOException{
        // 如果目录不存在，先创建目录，mkdirs支持多级目录创建
        File file = new File(targetFilePath);
        if (!file.getParentFile().exists()) {
            file.getParentFile().mkdirs();
        }

        // 拷贝数据
        InputStream in = item.getInputStream();
        OutputStream out = new FileOutputStream(targetFilePath);
        IOUtils.copy(in, out);
        in.close();
        out.close();

        // 删除临时文件
        item.delete();
    }
}
>>>>>>> origin/master
