package cn.edu.jit.mapper;

import cn.edu.jit.entry.LoginByThird;
import cn.edu.jit.entry.LoginByThirdExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface LoginByThirdMapper {
    int countByExample(LoginByThirdExample example);

    int deleteByExample(LoginByThirdExample example);

    int deleteByPrimaryKey(String id);

    int insert(LoginByThird record);

    int insertSelective(LoginByThird record);

    List<LoginByThird> selectByExample(LoginByThirdExample example);

    LoginByThird selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") LoginByThird record, @Param("example") LoginByThirdExample example);

    int updateByExample(@Param("record") LoginByThird record, @Param("example") LoginByThirdExample example);

    int updateByPrimaryKeySelective(LoginByThird record);

    int updateByPrimaryKey(LoginByThird record);
}