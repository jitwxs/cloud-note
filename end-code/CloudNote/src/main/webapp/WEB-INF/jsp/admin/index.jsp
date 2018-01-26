<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">
<jsp:include page="left.jsp"/>

<body class="admin_body">

<div class="admin_container">
    <%--卡片--%>
    <div class="row" style="margin-bottom: 20px;width: 100%;">

        <%--1111--%>
        <div class="col-md-3" style="padding: 5px;">
            <div style="border-radius:10px;
                         height: 150px;
                         background:rgba(0,0,0,0.5) url(../../../images/card1.jpg);
                         padding: 0;
                         margin-left: 10px;">
                <div style="height: 70%;width: 100%;">
                    <div style="margin-top: 35px;
                            margin-bottom: 10px; width: 100px;
                            height: 60px;float: right;text-align: right;
                            color: white;font-size: 20px;padding-right: 10px;">
                        注册量<br/>
                        <span id="span1"></span>
                    </div>
                </div>
                <div style="height: 30%;width: 100%;
                                background: #bc281f;border-bottom-left-radius:10px;
                                border-bottom-right-radius: 10px;">
                    <a href="${ctx}/admin/userInfo" style="color: white;"> 查看更多</a>
                </div>
            </div>
        </div>
        <%--2222--%>
        <div class="col-md-3" style="padding: 5px;">
            <div style="border-radius:10px;
                                                height: 150px;
                                                background:rgba(0,0,0,0.5) url(../../../images/card2.jpg);
                                                padding: 0;
                                                margin-left: 10px;">
                <div style="height: 70%;width: 100%;">
                    <div style="margin-top: 35px;
                                margin-bottom: 10px; width: 100px;
                                height: 60px;float: right;text-align: right;
                                color: white;font-size: 20px;padding-right: 10px;">
                        分享量<br/>
                        <span id="span2">1512</span>
                    </div>
                </div>
                <div style="height: 30%;width: 100%;
                                background: #144ca8;border-bottom-left-radius:10px;
                                border-bottom-right-radius: 10px;">
                    <a href="${ctx}/admin/shareInfo" style="color: white;"> 查看更多</a>
                </div>
            </div>
        </div>

        <%--3333--%>
        <div class="col-md-3" style="padding: 5px;">
            <div style="border-radius:10px;
                                                height: 150px;
                                                background:rgba(0,0,0,0.5) url(../../../images/card3.jpg);
                                                padding: 0;
                                                margin-left: 10px;">
                <div style="height: 70%;width: 100%;">
                    <div style="margin-top: 35px;
                                margin-bottom: 10px; width: 100px;
                                height: 60px;float: right;text-align: right;
                                color: white;font-size: 20px;padding-right: 10px;">
                        登陆量<br/>
                        <span id="span3">1512</span>
                    </div>
                </div>
                <div style="height: 30%;width: 100%;
                                background: #1b316d;border-bottom-left-radius:10px;
                                border-bottom-right-radius: 10px;">
                    <a href="${ctx}/admin/loginInfo" style="color: white;"> 查看更多</a>
                </div>
            </div>
        </div>

        <%--4444--%>
        <div class="col-md-3" style="padding: 5px;">
            <div style="border-radius:10px;
                                                height: 150px;
                                                background:rgba(0,0,0,0.5) url(../../../images/card4.jpg);
                                                padding: 0;
                                                margin-left: 10px;">
                <div style="height: 70%;width: 100%;">
                    <div style="margin-top: 35px;
                                margin-bottom: 10px; width: 100px;
                                height: 60px;float: right;text-align: right;
                                color: white;font-size: 20px;padding-right: 10px;">
                        网盘容量<br/>
                        <span id="span4">1512</span>
                    </div>
                </div>
                <div style="height: 30%;width: 100%;
                                background: #0b5d5d;border-bottom-left-radius:10px;
                                border-bottom-right-radius: 10px;">
                    <a href="${ctx}/admin/panInfo" style="color: white;"> 查看更多</a>
                </div>
            </div>
        </div>
    </div>
    <%--class="diy_container" 图表的类--%>
    <div class="row" style="width: 95%; text-align: center;">
        <div class="col-md-6 col-lg-6 col-sm-6" style="height: 400px;padding: 20px;">
            <div id="usernum" style="width: 100%;height: 80%;"></div>
        </div>

        <div class="col-md-6 col-lg-6 col-sm-6" style="height:400px; padding: 20px;">
            <div id="shared_num" style="width: 100%;height: 80%;"></div>
        </div>
    </div>
    <div class="row" style="width: 95%; text-align: center;">
        <div class="col-md-6 col-lg-6 col-sm-6" style="height: 400px;padding: 20px;">
            <div id="login_statistics" style="width: 100%;height: 80%;"></div>
        </div>
        <div class="col-md-6 col-lg-6 col-sm-6" style="height: 400px;padding: 20px;">
            <div id="panSpace" style="width: 100%;height: 80%;"></div>
        </div>
    </div>

</div>

<%--用户信息--%>
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
    window.onresize = userNum.resize;

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
        var te = document.getElementById("span1");
        var total = parseInt(data.femaleCount) + parseInt(data.maleCount);
        te.innerHTML = total.toString();
    }, function (error) {
        toastr.error("系统错误");
        return false;
    });

</script>

<%--文章分享量--%>
<script>
    var shared_echarts = echarts.init(document.getElementById("shared_num"));
    shared_echarts.setOption({
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
    $(window).on('resize', function () {
        shared_echarts.resize();
    });

    //ajax
    sendGet('${ctx}/admin/preparerShareInfo', {}, true, function (res) {
        var date = [];
        var num = [];
        var totalnum = [];
        var count = 0;
        // 只显示最近十日记录
        for (var i = 0; i < res.length; i++) {
            count += parseInt(res[i].v);
            if(i<10) {
                date.push(res[i].k);
                num.push(res[i].v);
                totalnum.push(count);
            }
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

        var te = document.getElementById("span2");
        te.innerHTML = count.toString();

    }, function (error) {
        toastr.error("系统错误");
        return false;
    });

</script>

<%--服务器访问量--%>
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
    $(window).on('resize', function () {
        time_echarts.resize();
    });

    //true 异步
    sendGet('${ctx}/admin/preparerLoginInfo', {}, true, function (res) {
        var date = [];
        var loginNum = [];
        var count = 0;
        // 只显示最近十日记录
        for (var i = 0; i < res.length; i++) {
            count += parseInt(res[i].v);
            if(i <10) {
                date.push(res[i].k);
                loginNum.push(res[i].v);
            }

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

        var te = document.getElementById("span3");
        te.innerHTML = count.toString();

    }, function (error) {
        toastr.error("系统错误");
        return false;
    });
    $(window).on('resize', function () {
        time_echarts.resize();
    });

</script>

<%--盘剩余空间--%>
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
    var radius = [30, 40];
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
        var cnm = document.getElementById("span4");
        cnm.innerHTML = res.usedSize;
    }, function (error) {
        toastr.error("系统错误");
        return false;
    });
    $(window).on('resize', function () {
        panSpaceTable.resize();
    });
</script>
</body>

</html>