package cn.edu.jit.entry;

import java.io.Serializable;

/**
 * @author jitwxs
 * @date 2018/1/12 10:26
 */
public class Data implements Serializable {
    private String k;

    private String v;

    public String getK() {
        return k;
    }

    public void setK(String k) {
        this.k = k;
    }

    public String getV() {
        return v;
    }

    public void setV(String v) {
        this.v = v;
    }
}
