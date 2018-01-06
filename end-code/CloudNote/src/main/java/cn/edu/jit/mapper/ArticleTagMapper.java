<<<<<<< HEAD
package cn.edu.jit.mapper;

import cn.edu.jit.entry.Article;
import cn.edu.jit.entry.ArticleTagExample;
import cn.edu.jit.entry.ArticleTagKey;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface ArticleTagMapper {
    int countByExample(ArticleTagExample example);

    int deleteByExample(ArticleTagExample example);

    int deleteByPrimaryKey(ArticleTagKey key);

    int insert(ArticleTagKey record);

    int insertSelective(ArticleTagKey record);

    List<ArticleTagKey> selectByExample(ArticleTagExample example);

    int updateByExampleSelective(@Param("record") ArticleTagKey record, @Param("example") ArticleTagExample example);

    int updateByExample(@Param("record") ArticleTagKey record, @Param("example") ArticleTagExample example);
=======
package cn.edu.jit.mapper;

import cn.edu.jit.entry.Article;
import cn.edu.jit.entry.ArticleTagExample;
import cn.edu.jit.entry.ArticleTagKey;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface ArticleTagMapper {
    int countByExample(ArticleTagExample example);

    int deleteByExample(ArticleTagExample example);

    int deleteByPrimaryKey(ArticleTagKey key);

    int insert(ArticleTagKey record);

    int insertSelective(ArticleTagKey record);

    List<ArticleTagKey> selectByExample(ArticleTagExample example);

    int updateByExampleSelective(@Param("record") ArticleTagKey record, @Param("example") ArticleTagExample example);

    int updateByExample(@Param("record") ArticleTagKey record, @Param("example") ArticleTagExample example);
>>>>>>> origin/master
}