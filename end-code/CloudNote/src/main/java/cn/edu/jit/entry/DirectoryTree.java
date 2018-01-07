package cn.edu.jit.entry;

import java.lang.reflect.Array;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

/**
 * @author jitwxs
 * @date 2018/1/6 11:25
 */
public class DirectoryTree {
    private String id;
    private String name;
    private List<DirectoryTree> data;

    public DirectoryTree(String id, String name) {
        this.id = id;
        this.name = name;
        data = new LinkedList<>();
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<DirectoryTree> getData() {
        return data;
    }

    public void setData(List<DirectoryTree> data) {
        this.data = data;
    }

    public void addData(DirectoryTree dt) {
        data.add(dt);
    }
}
