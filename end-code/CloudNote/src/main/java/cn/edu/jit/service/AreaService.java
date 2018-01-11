package cn.edu.jit.service;

import cn.edu.jit.entry.Area;

import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/8 21:56
 */
public interface AreaService {
    List<Area> listByPid(int pid);

    Area getById(int id);

    Area getByName(String name);
}
