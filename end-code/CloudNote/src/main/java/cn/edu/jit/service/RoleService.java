package cn.edu.jit.service;

import cn.edu.jit.entry.Role;

/**
 * 权限Service
 * @author jitwxs
 * @date 2018/1/2 20:43
 */
public interface RoleService {

    /**
     * 根据权限id查询权限
     * @param roleId 权限id
     * @return Role对象
     */
    Role getById(Integer roleId);
}
