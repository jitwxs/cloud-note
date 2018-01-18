package cn.edu.jit.service.impl;

import cn.edu.jit.entry.*;
import cn.edu.jit.mapper.ArticleDirMapper;
import cn.edu.jit.mapper.PanDirMapper;
import cn.edu.jit.service.ArticleDirService;
import cn.edu.jit.service.PanDirService;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/3 14:14
 */

@Service
public class PanDirServiceImpl implements PanDirService {
    @Autowired
    PanDirMapper panDirMapper;

    @Override
    public int save(PanDir panDir) {
        return panDirMapper.insertSelective(panDir);
    }

    @Override
    public int remove(String id) {
        return panDirMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int update(PanDir panDir) {
        panDir.setModifedDate(new Date());
        return panDirMapper.updateByPrimaryKey(panDir);
    }

    @Override
    public PanDir getById(String id) {
        return panDirMapper.selectByPrimaryKey(id);
    }

    @Override
    public List<PanDir> listByParentId(String uid, String parentId) {
        PanDirExample panDirExample = new PanDirExample();

        PanDirExample.Criteria criteria = panDirExample.createCriteria();
        criteria.andUidEqualTo(uid);
        criteria.andParentIdEqualTo(parentId);

        return panDirMapper.selectByExample(panDirExample);
    }

    @Override
    public List<PanDir> listPanDirByTitle(String uid, String title) {
        PanDirExample panDirExample = new PanDirExample();

        PanDirExample.Criteria criteria = panDirExample.createCriteria();
        criteria.andUidEqualTo(uid);
        // 加上通配符
        title = "%" + title + "%";
        criteria.andNameLike(title);

        return panDirMapper.selectByExample(panDirExample);
    }

    @Override
    public List<PanDir> getByName (String uid, String parentDir, String name) {
        PanDirExample panDirExample = new PanDirExample();

        PanDirExample.Criteria criteria = panDirExample.createCriteria();
        criteria.andUidEqualTo(uid);
        criteria.andNameEqualTo(name);
        criteria.andParentIdEqualTo(parentDir);

        return panDirMapper.selectByExample(panDirExample);
    }
}
