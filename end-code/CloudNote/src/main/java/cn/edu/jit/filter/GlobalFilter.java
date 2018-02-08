package cn.edu.jit.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 全局过滤器
 * @author jitwxs
 * @date 2018/2/8 15:54
 */
public class GlobalFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException { }

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
