package cn.edu.jit.mapper;

import cn.edu.jit.entry.Login;
import cn.edu.jit.entry.LoginExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

/**
 * @author jitwxs
 * @date 2018/1/2 19:24
 */
public interface LoginMapper {
    int countByExample(LoginExample example);

    int deleteByExample(LoginExample example);

    int deleteByPrimaryKey(String tel);

    int insert(Login record);

    int insertSelective(Login record);

    List<Login> selectByExample(LoginExample example);

    Login selectByPrimaryKey(String tel);

    int updateByExampleSelective(@Param("record") Login record, @Param("example") LoginExample example);

    int updateByExample(@Param("record") Login record, @Param("example") LoginExample example);

    int updateByPrimaryKeySelective(Login record);

    int updateByPrimaryKey(Login record);
}