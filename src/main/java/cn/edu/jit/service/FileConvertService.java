package cn.edu.jit.service;

import cn.edu.jit.entry.FileConvert;

/**
 * @author jitwxs
 * @date 2018/1/10 17:16
 */
public interface FileConvertService {
    FileConvert getById(String affixId);

    int save(FileConvert fileConvert);
}
