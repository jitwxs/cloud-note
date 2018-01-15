package cn.edu.jit.mapper;

import cn.edu.jit.entry.PanDir;
import cn.edu.jit.entry.PanDirExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface PanDirMapper {
    int countByExample(PanDirExample example);

    int deleteByExample(PanDirExample example);

    int deleteByPrimaryKey(String id);

    int insert(PanDir record);

    int insertSelective(PanDir record);

    List<PanDir> selectByExample(PanDirExample example);

    PanDir selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") PanDir record, @Param("example") PanDirExample example);

    int updateByExample(@Param("record") PanDir record, @Param("example") PanDirExample example);

    int updateByPrimaryKeySelective(PanDir record);

    int updateByPrimaryKey(PanDir record);
}