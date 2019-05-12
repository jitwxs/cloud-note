package cn.edu.jit.mapper;

import cn.edu.jit.entry.ArticleDir;
import cn.edu.jit.entry.ArticleDirExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface ArticleDirMapper {
    int countByExample(ArticleDirExample example);

    int deleteByExample(ArticleDirExample example);

    int deleteByPrimaryKey(String id);

    int insert(ArticleDir record);

    int insertSelective(ArticleDir record);

    List<ArticleDir> selectByExample(ArticleDirExample example);

    ArticleDir selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") ArticleDir record, @Param("example") ArticleDirExample example);

    int updateByExample(@Param("record") ArticleDir record, @Param("example") ArticleDirExample example);

    int updateByPrimaryKeySelective(ArticleDir record);

    int updateByPrimaryKey(ArticleDir record);
}