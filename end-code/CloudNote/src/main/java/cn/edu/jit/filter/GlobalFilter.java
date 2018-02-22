package cn.edu.jit.filter;

import cn.edu.jit.global.GlobalConstant;

import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Properties;

/**
 * 全局过滤器
 * @author jitwxs
 * @date 2018/2/8 15:54
 */
public class GlobalFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        Properties properties = new Properties();
        // 使用ClassLoader加载properties配置文件生成对应的输入流
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        String path = loader.getResource("system.properties").getPath();
        try {
            InputStreamReader in = new InputStreamReader(new FileInputStream(path), "UTF-8");
            // 使用properties对象加载输入流
            properties.load(in);
            // 初始化全局变量
            String serUrl = properties.getProperty("SER_URL");
            String defaultPanSize = properties.getProperty("DEFAULT_PAN_SIZE");
            String pageSize = properties.getProperty("PAGE_SIZE");
            String noteSuffix = properties.getProperty("NOTE_SUFFIX");
            String articleDefaultContent = properties.getProperty("ARTICLE_DEFAULT_CONTENT");
            String showShareNum = properties.getProperty("SHOW_SHARE_NUM");
            String noteAbstractLength = properties.getProperty("NOTE_ABSTRACT_LENGTH");
            String githubClientId = properties.getProperty("GITHUB_CLIENT_ID");
            String githubClientSecret = properties.getProperty("GITHUB_CLIENT_SECRET");
            String githubRedirectUrl = properties.getProperty("GITHUB_REDIRECT_URL");
            String labelName = properties.getProperty("LABEL_NAME");
            String mouldId = properties.getProperty("MOULD_ID");
            String accessKeyId = properties.getProperty("ACCESS_KEY_ID");
            String accessKeySecret = properties.getProperty("ACCESS_KEY_SECRET");
            String product = properties.getProperty("PRODUCT");
            String domain = properties.getProperty("DOMAIN");

            GlobalConstant.SER_URL = serUrl;
            GlobalConstant.DEFAULT_PAN_SIZE = Integer.parseInt(defaultPanSize) * 1024 * 1024;
            GlobalConstant.PAGE_SIZE = Integer.parseInt(pageSize);
            GlobalConstant.NOTE_SUFFIX = noteSuffix;
            GlobalConstant.ARTICLE_DEFAULT_CONTENT = articleDefaultContent;
            GlobalConstant.SHOW_SHARE_NUM = Integer.parseInt(showShareNum);
            GlobalConstant.NOTE_ABSTRACT_LENGTH = Integer.parseInt(noteAbstractLength);
            GlobalConstant.GITHUB_CLIENT_ID = githubClientId;
            GlobalConstant.GITHUB_CLIENT_SECRET = githubClientSecret;
            GlobalConstant.GITHUB_REDIRECT_URL = githubRedirectUrl;
            GlobalConstant.LABEL_NAME = labelName;
            GlobalConstant.MOULD_ID = mouldId;
            GlobalConstant.ACCESS_KEY_ID = accessKeyId;
            GlobalConstant.ACCESS_KEY_SECRET = accessKeySecret;
            GlobalConstant.PRODUCT = product;
            GlobalConstant.DOMAIN = domain;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletResponse resp = (HttpServletResponse)response;
        // 设置response编码
        resp.setContentType("text/html;charset=utf-8");

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() { }
}
