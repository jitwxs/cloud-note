package cn.edu.jit.mapper;

import cn.edu.jit.entry.Notify;
import cn.edu.jit.entry.NotifyExample;
import java.util.List;

import cn.edu.jit.entry.Page;
import org.apache.ibatis.annotations.Param;

public interface NotifyMapper {
    int countByExample(NotifyExample example);

    int deleteByExample(NotifyExample example);

    int deleteByPrimaryKey(String id);

    int insert(Notify record);

    int insertSelective(Notify record);

    List<Notify> selectByExample(NotifyExample example);

    Notify selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") Notify record, @Param("example") NotifyExample example);

    int updateByExample(@Param("record") Notify record, @Param("example") NotifyExample example);

    int updateByPrimaryKeySelective(Notify record);

    int updateByPrimaryKey(Notify record);

    List<Notify> listByRecvId(@Param("recvId")String recvId,@Param("type")String type,
                              @Param("status")Integer status,@Param("orderBy")String orderBy,@Param("page")Page page);
}