package cn.edu.jit.service.impl;

import cn.edu.jit.entry.FileConvert;
import cn.edu.jit.mapper.FileConvertMapper;
import cn.edu.jit.service.FileConvertService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author jitwxs
 * @date 2018/1/10 17:18
 */
@Service
public class FileConvertServiceImpl implements FileConvertService {
    @Autowired
    FileConvertMapper fileConvertMapper;

    @Override
    public FileConvert getById(String affixId) {
        return fileConvertMapper.selectByPrimaryKey(affixId);
    }

    @Override
    public int save(FileConvert fileConvert) {
        return fileConvertMapper.insert(fileConvert);
    }
}
