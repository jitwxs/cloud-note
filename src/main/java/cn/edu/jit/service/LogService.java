package cn.edu.jit.service;

import cn.edu.jit.entry.Data;
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

    Log getById(String id);

    List<Log> listByType(Integer type, String orderBy);

    int removeById(String id);

    /**
     * 根据类型统计每日用户数
     * @param title 类型名
     * @return
     */
    List<Data> countUserByTitle(String title);
}
