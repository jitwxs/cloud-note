package cn.edu.jit.service.impl;

import cn.edu.jit.entry.Tag;
import cn.edu.jit.entry.TagExample;
import cn.edu.jit.mapper.TagMapper;
import cn.edu.jit.service.TagService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/3 13:38
 */
@Service
public class TagServiceImpl implements TagService {

    @Autowired
    TagMapper tagMapper;

    @Override
    public int save(Tag tag) {
        return tagMapper.insertSelective(tag);
    }

    @Override
    public int update(Tag tag) {
        return tagMapper.updateByPrimaryKey(tag);
    }

    @Override
    public int remove(String id) {
        return tagMapper.deleteByPrimaryKey(id);
    }

    @Override
    public Tag getById(String id) {
        return tagMapper.selectByPrimaryKey(id);
    }

    @Override
    public Tag getByName(String name) {
        TagExample tagExample = new TagExample();

        TagExample.Criteria criteria = tagExample.createCriteria();
        criteria.andNameEqualTo(name);

        List<Tag> lists = tagMapper.selectByExample(tagExample);
        if(lists.size() ==0) {
            return null;
        } else {
            return lists.get(0);
        }

    }
}
