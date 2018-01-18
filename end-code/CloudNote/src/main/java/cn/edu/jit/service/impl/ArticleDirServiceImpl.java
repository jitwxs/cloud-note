package cn.edu.jit.service.impl;

import cn.edu.jit.entry.ArticleDir;
import cn.edu.jit.entry.ArticleDirExample;
import cn.edu.jit.mapper.ArticleDirMapper;
import cn.edu.jit.service.ArticleDirService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/3 14:14
 */

@Service
public class ArticleDirServiceImpl implements ArticleDirService {
    @Autowired
    ArticleDirMapper articleDirMapper;

    @Override
    public int save(ArticleDir articleDir) {
        return articleDirMapper.insertSelective(articleDir);
    }

    @Override
    public int remove(String id) {
        return articleDirMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int update(ArticleDir articleDir) {
        articleDir.setModifedDate(new Date());
        return articleDirMapper.updateByPrimaryKey(articleDir);
    }

    @Override
    public ArticleDir getById(String id) {
        return articleDirMapper.selectByPrimaryKey(id);
    }

    @Override
    public List<ArticleDir> listByParentId(String uid, String parentId) {
        ArticleDirExample articleDirExample = new ArticleDirExample();

        ArticleDirExample.Criteria criteria = articleDirExample.createCriteria();
        criteria.andUidEqualTo(uid);
        criteria.andParentIdEqualTo(parentId);

        return articleDirMapper.selectByExample(articleDirExample);
    }
}
