package cn.edu.jit.service;

import cn.edu.jit.entry.Log;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/14 11:30
 */
public interface LogService {

    void saveLog(HttpServletRequest request, Integer type, String title, String uid);

    void saveLog(HttpServletRequest request, Exception ex, Integer type, String title, String uid);

    List<Log> listAll();
}
