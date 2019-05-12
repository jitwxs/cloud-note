<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<jsp:include page="left.jsp"/>

<body class="admin_body">
<!--主体-->
<div class="container" style="height: 1000px;width: 100%; text-align: center;">
    <h2 class="admin_table_title">用户登陆统计</h2>
    <div class="diy_container" id="login_statistics" style="height:400px;"></div>
    <div class="diy_table">
        <table id="DateTable" class="table table-responsive table-bordered tab-content table-hover"></table>
    </div>
</div>

<script>
    //时段登陆量统计
    time_statistics = {
        title: {
            text: '用户登陆统计'
        },
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'cross'
            }
        },
        toolbox: {
            show: true,
            y: 'bottom',
            feature: {
                mark: {show: true},
                dataView: {show: true, readOnly: false},
                magicType: {show: true, type: ['line', 'bar']},
                restore: {show: true},
                saveAsImage: {show: true}
            }
        },
        xAxis: {
            type: 'category',
            boundaryGap: false,
            data: []
        },
        yAxis: {
            type: 'value',
            axisLabel: {
                formatter: '{value}'
            },
            axisPointer: {
                snap: true
            }
        },
        //设置峰值
        visualMap: {
            show: false,
            dimension: 1,
            pieces: [{
                lte: 6,
                color: 'green'
            }, {
                gt: 4,
                lte: 10,
                color: 'red'
            }
            ]
        },
        series: [
            {
                name: '每日登陆量',
                type: 'line',
                smooth: true,
                data: []
            }
        ]
    };
    var time_echarts = echarts.init(document.getElementById("login_statistics"));
    time_echarts.setOption(time_statistics);

    //true 异步
    sendGet('${ctx}/admin/preparerLoginInfo', {}, true, function (res) {
        var date = [];
        var loginNum = [];
        // 只显示最近十日记录
        for (var i = res.length -1 ; i >= 0  && i >= res.length - 10; i--) {
            date.push(res[i].k);
            loginNum.push(res[i].v);
        }
        time_echarts.setOption({
            xAxis: {
                data: date
            },
            series: [
                {
                    name: '登陆量',
                    data: loginNum
                }
            ]
        });

        // 表格
        $('#DateTable').bootstrapTable({
            cache: false,
            showExport: true,//显示导出按钮
            striped: true,
            pagination: true,
            height: 300,
            pageSize: 10,
            pageNumber: 1,
            pageList: [10, 20, 50, 100, 200, 500],
            search: true,
            showColumns: true,
            showRefresh: false,
            exportTypes: ['excel', 'json', 'xml', 'txt', 'sql'],
            clickToSelect: true,
            sidePagination: "client",   //分页方式：client客户端分页，server服务端分页（*）
            columns:
                [
                    {
                        field: "k",
                        title: "日期",
                        align: "center",
                        valign: "middle",
                        sortable: "true"
                    },
                    {
                        field: "v",
                        title: "今日登陆量",
                        align: "center",
                        valign: "middle",
                        sortable: "true"
                    }
                ],
            data: res
        });
    }, function (error) {
        toastr.error("系统错误");
        return false;
    });
    $(window).on('resize', function () {
        time_echarts.resize();
    });

</script>
</body>