<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<jsp:include page="left.jsp"/>

<body class="admin_body">

<div class="admin_container">
    <h2 class="admin_table_title">用户量统计</h2>
    <div id="usernum" class="diy_container"></div>
    <div id="table" class="diy_table">
        <table class="table table-responsive table-bordered table-hover tab-content " id="user_table">
        </table>
    </div>
</div>

<script>
    //userNum表格
    var userNum = echarts.init(document.getElementById('usernum'));
    var pies = [];
    var x = [];
    var male = [];
    var female = [];
    var sum = [];
    var useroption = {
        title: {
            text: '用户量统计'
        },
        tooltip: {
            trigger: 'axis'
        },
        toolbox: {
            show: true,
            y: 'bottom',
            feature: {
                mark: {show: true},
                dataView: {show: true, readOnly: false},
                magicType: {show: true, type: ['line', 'bar', 'tiled']},
                restore: {show: true},
                saveAsImage: {show: true}
            }
        },
        calculable: true,
        legend: {
            data: ['男性', '女性', '总注册量']
        },
        grid: {
            x: 25,
            y: 45,
            x2: 50,
            y2: 50,
            borderWidth: 1
        },
        xAxis: [
            {
                type: 'category',
                splitLine: {show: false},
                data: []
            }
        ],
        yAxis: [
            {
                type: 'value',
                position: 'right'
            }
        ],
        series: [
            {
                name: '男性',
                type: 'bar',
                tooltip: {trigger: 'item'},
                data: []
            },
            {
                name: '女性',
                type: 'bar',
                tooltip: {trigger: 'item'},
                data: []
            },
            {
                name: '总注册量',
                type: 'line',
                data: []
            },

            {
                name: '比例',
                type: 'pie',
                tooltip: {
                    trigger: 'item',
                    formatter: '{b} : {c} ({d}%)'
                },
                center: [130, 100],
                radius: [0, 50],
                itemStyle: {
                    normal: {
                        labelLine: {
                            length: 20
                        }
                    }
                },
                data: []
            }
        ]
    };
    userNum.setOption(useroption);

    sendGet('${ctx}/admin/preparerUserInfo', {}, false, function (data) {
        pies.push(data.maleCount);
        pies.push(data.femaleCount);
        var temp = data.regInfo;
        // 图标只显示最近10天的信息
        for (var i = temp.length - 1; i >= 0 && i >= temp.length - 10; i--) {
            x.push(temp[i].date);
            male.push(temp[i].maleNum);
            female.push(temp[i].femaleNum);
            sum.push(temp[i].tempTotal);
        }
        userNum.setOption({
            xAxis: {
                data: x
            },
            series: [
                {
                    // 根据名字对应到相应的系列
                    name: '男性',
                    data: male
                },
                {
                    // 根据名字对应到相应的系列
                    name: '女性',
                    data: female
                },
                {
                    name: '总注册量',
                    data: sum
                },
                {
                    name: '比例',
                    data: pies
                }

            ]
        });

        // 表格
        $('#user_table').bootstrapTable({
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
                        field: "date",
                        title: "日期",
                        align: "center",
                        valign: "middle",
                        sortable: "true"
                    },
                    {
                        field: "num",
                        title: "当日注册量",
                        align: "center",
                        valign: "middle",
                        sortable: "true"
                    },
                    {
                        field: "tempTotal",
                        title: "总注册量",
                        align: "center",
                        valign: "middle",
                        sortable: "true"
                    }
                ],
            data: temp
        });
    }, function (error) {
        toastr.error("系统错误");
        return false;
    });

    $(window).on('resize', function () {
        userNum.resize();
    });

</script>

</body>
