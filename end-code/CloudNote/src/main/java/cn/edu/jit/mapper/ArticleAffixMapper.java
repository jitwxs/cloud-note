package cn.edu.jit.mapper;

import cn.edu.jit.entry.ArticleAffix;
import cn.edu.jit.entry.ArticleAffixExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface ArticleAffixMapper {
    int countByExample(ArticleAffixExample example);

    int deleteByExample(ArticleAffixExample example);

    int deleteByPrimaryKey(String id);

    int insert(ArticleAffix record);

    int insertSelective(ArticleAffix record);

    List<ArticleAffix> selectByExample(ArticleAffixExample example);

    ArticleAffix selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") ArticleAffix record, @Param("example") ArticleAffixExample example);

    int updateByExample(@Param("record") ArticleAffix record, @Param("example") ArticleAffixExample example);

    int updateByPrimaryKeySelective(ArticleAffix record);

    int updateByPrimaryKey(ArticleAffix record);
}