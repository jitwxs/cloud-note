package cn.edu.jit.service.impl;

import cn.edu.jit.entry.Article;
import cn.edu.jit.entry.ArticleExample;
import cn.edu.jit.global.GlobalConstant;
import cn.edu.jit.mapper.ArticleMapper;
import cn.edu.jit.mapper.TagMapper;
import cn.edu.jit.service.ArticleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/3 13:19
 */
@Service
public class ArticleServiceImpl implements ArticleService {
    @Autowired
    ArticleMapper articleMapper;

    @Autowired
    TagMapper tagMapper;

    @Override
    public int save(Article article) {
        return articleMapper.insertSelective(article);
    }

    @Override
    public int removeById(String id) {
        return articleMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int update(Article article) {
        article.setModifedDate(new Date());
        return articleMapper.updateByPrimaryKey(article);
    }

    @Override
    public Article getById(String id) {
        return articleMapper.selectByPrimaryKey(id);
    }

    @Override
    public List<Article> listAllArticle() {
        ArticleExample articleExample = new ArticleExample();
        return articleMapper.selectByExample(articleExample);
    }

    @Override
    public List<Article> listArticleByTitle(String uid, String title) {
        ArticleExample articleExample = new ArticleExample();

        ArticleExample.Criteria criteria = articleExample.createCriteria();
        criteria.andUserIdEqualTo(uid);
        // 加上通配符
        title = "%" + title + "%";
        criteria.andTitleLike(title);

        return articleMapper.selectByExample(articleExample);
    }

    @Override
    public List<Article> listArticleByUid(String uid) {
        ArticleExample articleExample = new ArticleExample();

        ArticleExample.Criteria criteria = articleExample.createCriteria();
        criteria.andUserIdEqualTo(uid);

        return articleMapper.selectByExample(articleExample);
    }

    @Override
    public List<Article> listArticleByTagName(String uid, String tagName) {
        return  articleMapper.listArticleByTagName(uid, tagName);
    }

    @Override
    public List<Article> listArticleByDir(String uid, String dirId) {
        ArticleExample articleExample = new ArticleExample();

        ArticleExample.Criteria criteria = articleExample.createCriteria();
        criteria.andUserIdEqualTo(uid);
        criteria.andDirIdEqualTo(dirId);

        return articleMapper.selectByExample(articleExample);
    }

    @Override
    public List<Article> listArticleByShare(String uid) {
        ArticleExample articleExample = new ArticleExample();

        ArticleExample.Criteria criteria = articleExample.createCriteria();
        criteria.andUserIdEqualTo(uid);
        criteria.andIsOpenEqualTo(GlobalConstant.ARTICLE_STATUS.SHARE.getIndex());

        return articleMapper.selectByExample(articleExample);
    }

    @Override
    public List<Article> listAnotherShareArticle(String uid) {
        ArticleExample articleExample = new ArticleExample();

        ArticleExample.Criteria criteria = articleExample.createCriteria();
        criteria.andUserIdNotEqualTo(uid);
        criteria.andIsOpenEqualTo(GlobalConstant.ARTICLE_STATUS.SHARE.getIndex());

        return articleMapper.selectByExample(articleExample);
    }

    @Override
    public int countArticle(String uid) {
        ArticleExample articleExample = new ArticleExample();

        ArticleExample.Criteria criteria = articleExample.createCriteria();
        criteria.andUserIdEqualTo(uid);

        return articleMapper.countByExample(articleExample);
    }


}
