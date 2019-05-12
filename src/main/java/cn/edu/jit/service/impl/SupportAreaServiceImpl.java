package cn.edu.jit.service.impl;

import cn.edu.jit.entry.SupportArea;
import cn.edu.jit.entry.SupportAreaExample;
import cn.edu.jit.mapper.SupportAreaMapper;
import cn.edu.jit.service.SupportAreaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/12 14:50
 */
@Service
public class SupportAreaServiceImpl implements SupportAreaService {
    @Autowired
    SupportAreaMapper supportAreaMapper;

    @Override
    public SupportArea getByName(String name) {
        SupportAreaExample supportAreaExample = new SupportAreaExample();

        SupportAreaExample.Criteria criteria = supportAreaExample.createCriteria();
        criteria.andNameEqualTo(name);

        List<SupportArea> supportAreas = supportAreaMapper.selectByExample(supportAreaExample);

        if(supportAreas.size() > 0) {
            return supportAreas.get(0);
        } else {
            return null;
        }
    }
}
