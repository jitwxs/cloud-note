package cn.edu.jit.mapper;

import cn.edu.jit.entry.FileConvert;
import cn.edu.jit.entry.FileConvertExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface FileConvertMapper {
    int countByExample(FileConvertExample example);

    int deleteByExample(FileConvertExample example);

    int deleteByPrimaryKey(String affixId);

    int insert(FileConvert record);

    int insertSelective(FileConvert record);

    List<FileConvert> selectByExample(FileConvertExample example);

    FileConvert selectByPrimaryKey(String affixId);

    int updateByExampleSelective(@Param("record") FileConvert record, @Param("example") FileConvertExample example);

    int updateByExample(@Param("record") FileConvert record, @Param("example") FileConvertExample example);

    int updateByPrimaryKeySelective(FileConvert record);

    int updateByPrimaryKey(FileConvert record);
}