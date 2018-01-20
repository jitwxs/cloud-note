package cn.edu.jit.mapper;

import cn.edu.jit.entry.UserPan;
import cn.edu.jit.entry.UserPanExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface UserPanMapper {
    int countByExample(UserPanExample example);

    int deleteByExample(UserPanExample example);

    int deleteByPrimaryKey(String id);

    int insert(UserPan record);

    int insertSelective(UserPan record);

    List<UserPan> selectByExample(UserPanExample example);

    UserPan selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") UserPan record, @Param("example") UserPanExample example);

    int updateByExample(@Param("record") UserPan record, @Param("example") UserPanExample example);

    int updateByPrimaryKeySelective(UserPan record);

    int updateByPrimaryKey(UserPan record);

    Integer countUsedSize(String uid);

    Integer countTotalUsedSize();
}