package cn.edu.jit.entry;

import java.io.Serializable;

/**
 * @author jitwxs
 * @date 2018/1/12 10:26
 */
public class Data implements Serializable {
    private String k;

    private Object v;

    public String getK() {
        return k;
    }

    public void setK(String k) {
        this.k = k;
    }

    public Object getV() {
        return v;
    }

    public void setV(Object v) {
        this.v = v;
    }
}
