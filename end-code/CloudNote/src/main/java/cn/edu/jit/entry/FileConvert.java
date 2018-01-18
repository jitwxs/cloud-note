package cn.edu.jit.entry;

import java.io.Serializable;

/**
 * 文件转换实体类
 * @author jitwxs
 */
public class FileConvert implements Serializable {
    private String affixId;

    private String path;

    public String getAffixId() {
        return affixId;
    }

    public void setAffixId(String affixId) {
        this.affixId = affixId == null ? null : affixId.trim();
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path == null ? null : path.trim();
    }
}