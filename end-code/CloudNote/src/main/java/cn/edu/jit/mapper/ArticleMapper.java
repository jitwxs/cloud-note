package cn.edu.jit.mapper;

import cn.edu.jit.entry.Article;
import cn.edu.jit.entry.ArticleExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

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
     * 根据用户id和标签id查询所有文章
     * @param uid
     * @param tagId
     * @return
     */
    List<Article> listArticleByTag(@Param("uid") String uid, @Param("tagId") String tagId);
}