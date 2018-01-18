package cn.edu.jit.mapper;

import cn.edu.jit.entry.IllegalReason;
import cn.edu.jit.entry.IllegalReasonExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface IllegalReasonMapper {
    int countByExample(IllegalReasonExample example);

    int deleteByExample(IllegalReasonExample example);

    int deleteByPrimaryKey(String id);

    int insert(IllegalReason record);

    int insertSelective(IllegalReason record);

    List<IllegalReason> selectByExample(IllegalReasonExample example);

    IllegalReason selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") IllegalReason record, @Param("example") IllegalReasonExample example);

    int updateByExample(@Param("record") IllegalReason record, @Param("example") IllegalReasonExample example);

    int updateByPrimaryKeySelective(IllegalReason record);

    int updateByPrimaryKey(IllegalReason record);
}