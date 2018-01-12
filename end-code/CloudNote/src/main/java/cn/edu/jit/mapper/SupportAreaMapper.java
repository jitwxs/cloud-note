package cn.edu.jit.mapper;

import cn.edu.jit.entry.SupportArea;
import cn.edu.jit.entry.SupportAreaExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface SupportAreaMapper {
    int countByExample(SupportAreaExample example);

    int deleteByExample(SupportAreaExample example);

    int deleteByPrimaryKey(String name);

    int insert(SupportArea record);

    int insertSelective(SupportArea record);

    List<SupportArea> selectByExample(SupportAreaExample example);

    int updateByExampleSelective(@Param("record") SupportArea record, @Param("example") SupportAreaExample example);

    int updateByExample(@Param("record") SupportArea record, @Param("example") SupportAreaExample example);
}