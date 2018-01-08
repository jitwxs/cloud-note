package cn.edu.jit.dto;

import cn.edu.jit.entry.User;

/**
 * @author jitwxs
 * @date 2018/1/8 22:23
 */
public class UserDto extends User {
    private String AreaName;

    public String getAreaName() {
        return AreaName;
    }

    public void setAreaName(String areaName) {
        AreaName = areaName;
    }
}
