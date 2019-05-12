package cn.edu.jit.mapper;

import cn.edu.jit.entry.ArticleRecycle;
import cn.edu.jit.entry.ArticleRecycleExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface ArticleRecycleMapper {
    int countByExample(ArticleRecycleExample example);

    int deleteByExample(ArticleRecycleExample example);

    int deleteByPrimaryKey(String id);

    int insert(ArticleRecycle record);

    int insertSelective(ArticleRecycle record);

    List<ArticleRecycle> selectByExample(ArticleRecycleExample example);

    ArticleRecycle selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") ArticleRecycle record, @Param("example") ArticleRecycleExample example);

    int updateByExample(@Param("record") ArticleRecycle record, @Param("example") ArticleRecycleExample example);

    int updateByPrimaryKeySelective(ArticleRecycle record);

    int updateByPrimaryKey(ArticleRecycle record);
}