package cn.edu.jit.mapper;

import cn.edu.jit.entry.UserBlacklist;
import cn.edu.jit.entry.UserBlacklistExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface UserBlacklistMapper {
    int countByExample(UserBlacklistExample example);

    int deleteByExample(UserBlacklistExample example);

    int deleteByPrimaryKey(String id);

    int insert(UserBlacklist record);

    int insertSelective(UserBlacklist record);

    List<UserBlacklist> selectByExample(UserBlacklistExample example);

    UserBlacklist selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") UserBlacklist record, @Param("example") UserBlacklistExample example);

    int updateByExample(@Param("record") UserBlacklist record, @Param("example") UserBlacklistExample example);

    int updateByPrimaryKeySelective(UserBlacklist record);

    int updateByPrimaryKey(UserBlacklist record);
}