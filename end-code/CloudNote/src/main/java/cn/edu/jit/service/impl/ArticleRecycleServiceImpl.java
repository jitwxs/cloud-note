package cn.edu.jit.service.impl;

import cn.edu.jit.entry.ArticleRecycle;
import cn.edu.jit.mapper.ArticleRecycleMapper;
import cn.edu.jit.service.ArticleRecycleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
}
