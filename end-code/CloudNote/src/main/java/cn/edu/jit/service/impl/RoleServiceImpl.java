package cn.edu.jit.service.impl;

import cn.edu.jit.entry.Role;
import cn.edu.jit.entry.RoleExample;
import cn.edu.jit.mapper.RoleMapper;
import cn.edu.jit.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/2 20:43
 */
@Service
public class RoleServiceImpl implements RoleService {

    @Autowired
    private RoleMapper roleMapper;

    @Override
    public Role getById(Integer roleId) {
        RoleExample roleExample = new RoleExample();

        RoleExample.Criteria criteria = roleExample.createCriteria();
        criteria.andIdEqualTo(roleId);

        List<Role> list = roleMapper.selectByExample(roleExample);

        if (list.size() > 0) {
            return list.get(0);
        } else {
            return null;
        }
    }
}
