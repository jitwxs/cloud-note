<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<jsp:include page="left.jsp"/>

<body class="admin_body">
<!--主体-->
<div class="admin_container">
    <h2 class="admin_table_title">文章分享量统计</h2>
    <div id="shared_num" class="diy_container"></div>
    <div class="diy_table">
        <table class="table table-responsive table-bordered table-hover" id="shared_table">
        </table>
    </div>
</div>

<script>
    var shared_echarts = echarts.init(document.getElementById("shared_num"));
    shared_echarts.setOption(
        {
            tooltip: {
                trigger: 'axis',
                axisPointer: {
                    type: 'shadow'
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
            legend: {
                data: ['总分享量', '每日分享量']
            },
            title: {
                text: '文章分享量统计'
            },
            xAxis: {
                data: []

            },
            yAxis: {
                splitLine: {show: false},

            },
            series: [
//                折线上的点
                {
                    name: '总分享量',
                    type: 'line',
                    smooth: true,
                    showAllSymbol: true,
                    symbol: 'emptyCircle',
                    symbolSize: 15,
                    data: []
                },
//              每日分享量
                {
                    name: '每日分享量',
                    type: 'bar',
                    barWidth: 10,
                    itemStyle: {
                        normal: {
                            barBorderRadius: 5,
                            color: new echarts.graphic.LinearGradient(
                                0, 0, 0, 1,
                                [
                                    {offset: 0, color: '#14c8d4'},
                                    {offset: 1, color: '#43eec6'}
                                ]
                            )
                        }
                    },
                    data: []
                }]
        }
    );

    //ajax
    sendGet('${ctx}/admin/preparerShareInfo', {}, true, function (res) {
        var date = [];
        var num = [];
        var totalnum = [];
        var count = 0;
        // 只显示最近十日记录
        for (var i = 0; i < res.length && i < 10; i++) {
            date.push(res[i].k);
            num.push(res[i].v);
            count += parseInt(res[i].v);
            totalnum.push(count);
        }

        shared_echarts.setOption({
            xAxis: {
                data: date
            },
            series: [
                {
                    // 根据名字对应到相应的系列
                    name: '总分享量',
                    data: totalnum
                },
                {
                    // 根据名字对应到相应的系列
                    name: '每日分享量',
                    data: num
                }
            ]
        });

        // 表格
        $('#shared_table').bootstrapTable({
            cache: false,
            showExport: true,//显示导出按钮
            striped: true,
            pagination: true,
            pageSize: 10,
            height: 300,
            pageNumber: 1,
            pageList: [10, 20, 50, 100, 200, 500],
            search: true,
            showColumns: true,
            showRefresh: false,
            exportTypes: ['excel', 'json', 'xml', 'txt', 'sql'],
            clickToSelect: true,
            sidePagination: "client",           //分页方式：client客户端分页，server服务端分页（*）
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
                        title: "当日分享量",
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
        shared_echarts.resize();
    });
</script>
</body>