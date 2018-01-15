package cn.edu.jit.service.impl;

import cn.edu.jit.entry.ArticleExample;
import cn.edu.jit.entry.ArticleRecycle;
import cn.edu.jit.entry.ArticleRecycleExample;
import cn.edu.jit.mapper.ArticleRecycleMapper;
import cn.edu.jit.service.ArticleRecycleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/3 13:19
 */
@Service
public class ArticleRecycleServiceImpl implements ArticleRecycleService {
    @Autowired
    ArticleRecycleMapper articleRecycleMapper;

    @Override
    public int save(ArticleRecycle articleRecycle) {
        return articleRecycleMapper.insertSelective(articleRecycle);
    }

    @Override
    public ArticleRecycle getById(String id) {
        return articleRecycleMapper.selectByPrimaryKey(id);
    }

    @Override
    public int removeById(String id) {
        return articleRecycleMapper.deleteByPrimaryKey(id);
    }

    @Override
    public List<ArticleRecycle> listSelfRecycle(String uid) {
        ArticleRecycleExample articleRecycleExample = new ArticleRecycleExample();

        ArticleRecycleExample.Criteria criteria = articleRecycleExample.createCriteria();
        criteria.andUserIdEqualTo(uid);

        return articleRecycleMapper.selectByExample(articleRecycleExample);
    }

    @Override
    public List<ArticleRecycle> listAllRecycle() {
        ArticleRecycleExample articleRecycleExample = new ArticleRecycleExample();
        return articleRecycleMapper.selectByExample(articleRecycleExample);
    }
}
