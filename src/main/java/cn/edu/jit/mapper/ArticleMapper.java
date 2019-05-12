package cn.edu.jit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import cn.edu.jit.entry.Article;
import cn.edu.jit.entry.ArticleExample;

public interface ArticleMapper {
    int countByExample(ArticleExample example);

    int deleteByExample(ArticleExample example);

    int deleteByPrimaryKey(String id);

    int insert(Article record);

    int insertSelective(Article record);

    List<Article> selectByExample(ArticleExample example);

    Article selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") Article record, @Param("example") ArticleExample example);

    int updateByExample(@Param("record") Article record, @Param("example") ArticleExample example);

    int updateByPrimaryKeySelective(Article record);

    int updateByPrimaryKey(Article record);

    /**
     * 根据用户id和标签模糊查询
     * @param uid 用户id
     * @param tagName 标签id
     * @return
     */
    List<Article> listArticleByTagName(@Param("uid") String uid, @Param("tagName") String tagName);
}