package cn.edu.jit.mapper;

import cn.edu.jit.entry.Role;
import cn.edu.jit.entry.RoleExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

/**
 * @author jitwxs
 * @date 2018/1/2 19:24
 */
public interface RoleMapper {
    int countByExample(RoleExample example);

    int deleteByExample(RoleExample example);

    int deleteByPrimaryKey(Integer role);

    int insert(Role record);

    int insertSelective(Role record);

    List<Role> selectByExample(RoleExample example);

    Role selectByPrimaryKey(Integer role);

    int updateByExampleSelective(@Param("record") Role record, @Param("example") RoleExample example);

    int updateByExample(@Param("record") Role record, @Param("example") RoleExample example);

    int updateByPrimaryKeySelective(Role record);

    int updateByPrimaryKey(Role record);
}