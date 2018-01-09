package cn.edu.jit.service.impl;

import cn.edu.jit.entry.ArticleAffix;
import cn.edu.jit.entry.ArticleAffixExample;
import cn.edu.jit.mapper.ArticleAffixMapper;
import cn.edu.jit.service.ArticleAffixService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/9 16:09
 */
@Service
public class ArticleAffixServiceImpl implements ArticleAffixService {
    @Autowired
    ArticleAffixMapper articleAffixMapper;

    @Override
    public ArticleAffix getById(String affixId) {
        return articleAffixMapper.selectByPrimaryKey(affixId);
    }

    @Override
    public List<ArticleAffix> listByArticleId(String articleId) {
        ArticleAffixExample articleAffixExample = new ArticleAffixExample();

        ArticleAffixExample.Criteria criteria = articleAffixExample.createCriteria();
        criteria.andArticleidEqualTo(articleId);

        return articleAffixMapper.selectByExample(articleAffixExample);
    }

    @Override
    public int removeById(String id) {
        return articleAffixMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int removeAllByArticleId(String articleId) {
        ArticleAffixExample articleAffixExample = new ArticleAffixExample();

        ArticleAffixExample.Criteria criteria = articleAffixExample.createCriteria();
        criteria.andArticleidEqualTo(articleId);

        return articleAffixMapper.deleteByExample(articleAffixExample);
    }

    @Override
    public int save(ArticleAffix articleAffix) {
        return articleAffixMapper.insertSelective(articleAffix);
    }
}
