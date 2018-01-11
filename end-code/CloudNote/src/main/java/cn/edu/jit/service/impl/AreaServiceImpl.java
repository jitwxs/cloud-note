package cn.edu.jit.service.impl;

import cn.edu.jit.entry.Area;
import cn.edu.jit.entry.AreaExample;
import cn.edu.jit.mapper.AreaMapper;
import cn.edu.jit.service.AreaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/8 21:57
 */
@Service
public class AreaServiceImpl implements AreaService {
    @Autowired
    AreaMapper areaMapper;

    @Override
    public List<Area> listByPid(int pid) {
        AreaExample areaExample = new AreaExample();

        AreaExample.Criteria criteria = areaExample.createCriteria();
        criteria.andPidEqualTo(pid);
        // 去除中国
        criteria.andIdNotEqualTo(pid);

        return areaMapper.selectByExample(areaExample);
    }

    @Override
    public Area getById(int id) {
        return areaMapper.selectByPrimaryKey(id);
    }

    @Override
    public Area getByName(String name) {
        return areaMapper.getByName(name);
    }
}
