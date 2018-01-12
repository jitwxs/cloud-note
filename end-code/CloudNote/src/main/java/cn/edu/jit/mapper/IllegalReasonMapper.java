package cn.edu.jit.mapper;

import cn.edu.jit.entry.IllegalReasonExample;
import cn.edu.jit.entry.IllegalReasonKey;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface IllegalReasonMapper {
    int countByExample(IllegalReasonExample example);

    int deleteByExample(IllegalReasonExample example);

    int deleteByPrimaryKey(IllegalReasonKey key);

    int insert(IllegalReasonKey record);

    int insertSelective(IllegalReasonKey record);

    List<IllegalReasonKey> selectByExample(IllegalReasonExample example);

    int updateByExampleSelective(@Param("record") IllegalReasonKey record, @Param("example") IllegalReasonExample example);

    int updateByExample(@Param("record") IllegalReasonKey record, @Param("example") IllegalReasonExample example);
}