<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<jsp:include page="left.jsp"/>

<body class="admin_body">

<!--主体-->
<div class="admin_container">
    <h2 class="admin_table_title">网盘容量统计</h2>
    <div id="panSpace" class="diy_container"></div>
    <div id="table" class="diy_table">
        <table id="panSpaceTable" class="table table-responsive table-bordered tabel-hover tab-content"></table>
    </div>
</div>
<script>
    var panSpaceTable = echarts.init(document.getElementById('panSpace'));
    var labelTop = {
        normal: {
            label: {
                show: true,
                position: 'center',
                formatter: '{b}',
                textStyle: {
                    baseline: 'bottom'
                }
            },
            labelLine: {
                show: false
            }
        }
    };
    var labelFromatter = {
        normal: {
            label: {
                formatter: function (params) {
                    return 100 - params.value + '%'
                },
                textStyle: {
                    baseline: 'top'
                }
            }
        }
    };
    var labelBottom = {
        normal: {
            color: '#ccc',
            label: {
                show: true,
                position: 'center'
            },
            labelLine: {
                show: false
            }
        },
        emphasis: {
            color: 'rgba(100,,0,0)'
        }
    };
    var radius = [40, 55];
    optionwww = {
        tooltip: {
            show: true,
            trigger: 'item'
        },
        legend: {
            data: ['人数']
        },
        toolbox: {
            show: true,
            feature: {
                mark: {show: true},
                dataView: {show: true, readOnly: false},
                magicType: {show: true, type: ['line', 'bar']},
                restore: {show: true},
                saveAsImage: {show: true}
            }
        },
        calculable: true,
        xAxis: [
            {
                type: 'category',
                data: ['10%', '20%', '30%', '40%', '50%', '60%', '70%', '80%', '90%', '100%']
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
                name: '人数',
                type: 'bar',
                barWidth: 40, // 系列级个性化，柱形宽度
                data: [],
                itemStyle: {
                    normal: {
                        color: '#f5b031'
                    }
                },
                markLine: {
                    data: [
                        {type: 'average', name: '平均值'}
                    ]
                }
            },
            {
                name: '比例',
                type: 'pie',
                center: ['10%', '15%'],
                radius: radius,
                x: '0%', // for funnel
                itemStyle: labelFromatter,
                color: ['green', 'blueviolet'],
                data: [
                    {name: 'other', value: 100, itemStyle: labelBottom},
                    {name: '已用容量', value: 0, itemStyle: labelTop}
                ]
            }
        ]
    };
    panSpaceTable.setOption(optionwww);
    window.onresize = panSpaceTable.resize;//响应式表格

    //表格
    sendGet('${ctx}/admin/preparePanInfo', {}, true, function (res) {
        var y = [];
        for (var i = 0; i < res.lists.length; i++) {
            y.push(res.lists[i].v);
        }
        //填充图表数据
        panSpaceTable.setOption({
            series: [
                {
                    name: '人数',
                    data: y

                },
                {
                    name: '比例',
                    data: [
                        {name: 'other', value: 100 - res.perfect, itemStyle: labelBottom},
                        {name: '已用容量', value: res.perfect, itemStyle: labelTop}
                    ]
                }
            ]
        });

        //填充表格数据
        $('#panSpaceTable').bootstrapTable(
            {
                data: res.lists,   //最终的JSON数据放在这里
                height: $(window).height() - 100,
                striped: true,
                cache: false,
                pagination: true,
                sidePagination: "client",
                pageNumber: 1,
                pageSize: 10,
                pageList: [5, 10, 20],
                showColumns: true,
                minimunCountColumns: 2,
                sort: false,
                height: 300,
                sortOrder: "asc",
                search: true,
                showRefresh: true,
                clickToSelect: true,
                showToggle: true,
                cardView: false,    //是否显示详细视图
                detaView: false,
                columns: [
                    {
                        field: 'k',
                        title: '已使用量',
                        width: 100,
                        align: 'center',
                        valign: 'center',
                        sortable: true
                    },
                    {
                        field: 'v',
                        title: '人数',
                        align: 'center',
                        valign: 'center',
                        sortable: true

                    }
                ]
            })
    }, function (error) {
        toastr.error("系统错误");
        return false;
    });
    $(window).on('resize', function () {
        panSpaceTable.resize();
    });
</script>
</body>
