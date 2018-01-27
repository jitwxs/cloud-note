package cn.edu.jit.entry;

import cn.edu.jit.global.GlobalConstant;

/**
 * 分页信息实体类
 *
 * @author : jitwxs
 * @date : 2017-10-22
 */
public class Page {
    /**
     * 当前页码
     */
    private Integer currentPageNo;

    /**
     * 总页数
     */
    private Integer totalCount;

    /**
     * 页面容量
     */
    private Integer pageSize = GlobalConstant.PAGE_SIZE;

    /**
     * 开始行数
     */
    private Integer startRow;

    public Integer getCurrentPageNo() {
        return currentPageNo;
    }

    public void setCurrentPageNo(Integer currentPageNo) {
        this.currentPageNo = currentPageNo;
        this.startRow = (currentPageNo - 1) * this.pageSize;
    }

    public Integer getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(Integer count) {
        this.totalCount = (count / this.pageSize) + 1;
    }

    public Integer getStartRow() {
        return startRow;
    }
}
