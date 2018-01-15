<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<jsp:include page="left.jsp"/>

<body style="width: 100%;height: 1000px;" >

    <div class="container" style="height: 1000px;width: 100%; text-align: center;">
        <h2 >用户信息统计</h2>
        <div id="usernum" class="diy_container"></div>
        <div id="table" class="diy_table">
            <table class="table table-responsive table-bordered table-hover">
                <thead>
                <tr>
                    <th>时间</th>
                    <th>当日注册量</th>
                    <th>总注册量</th>
                </tr>
                </thead>
                <tbody id="userInfoBody">
                </tbody>
            </table>
        </div>
    </div>

    <script>

        //userNum表格
        var userNum = echarts.init(document.getElementById('usernum'));
        var pies=[];

        var useroption = {
            title: {
                text: '用户量统计'
            },
            tooltip : {
                trigger: 'axis'
            },
            toolbox: {
                show : true,
                y: 'bottom',
                feature : {
                    mark : {show: true},
                    dataView : {show: true, readOnly: false},
                    magicType : {show: true, type: ['line', 'bar', 'tiled']},
                    restore : {show: true},
                    saveAsImage : {show: true}
                }
            },
            calculable : true,
            legend: {
                data:['男性', '女性', '总注册量']
            },
            grid:{
                x:25,
                y:45,
                x2:50,
                y2:50,
                borderWidth:1
            },
            xAxis : [
                {
                    type : 'category',
                    splitLine : {show : false},
                    data : []
                }
            ],
            yAxis : [
                {
                    type : 'value',
                    position: 'right'
                }
            ],
            series : [
                {
                    name:'男性',
                    type:'bar',
                    tooltip : {trigger: 'item'},
                    data: []
                },
                {
                    name:'女性',
                    type:'bar',
                    tooltip : {trigger: 'item'},
                    data:[]
                },
                {
                    name:'总注册量',
                    type:'line',
                    data: []
                },

                {
                    name:'比例',
                    type:'pie',
                    tooltip : {
                        trigger: 'item',
                        formatter: '{b} : {c} ({d}%)'
                    },
                    center: [130,100],
                    radius : [0, 50],
                    itemStyle :　{
                        normal : {
                            labelLine : {
                                length : 20
                            }
                        }
                    },
                    data: []
                }
            ]
        };
        userNum.setOption(useroption);

        sendGet('${ctx}/admin/preparerUserInfo',{},false,function (data) {
            var res = "";
            for(var i=0; i<data.date.length; i++) {
                var countUser = data.maleNum[i] + data.femaleNum[i];
                res += '<tr>\n' +
                    '                    <td>'+data.date[i]+'</td>\n' +
                    '                    <td>'+countUser+'</td>\n' +
                    '                    <td>'+data.tempTotal[i]+'</td>\n' +
                    '                </tr>';
            }
            $("#userInfoBody").html(res);

            pies.push(data.maleCount);
            pies.push(data.femaleCount);
            userNum.setOption({
                xAxis: {
                    data: data.date
                },
                series: [
                    {
                        // 根据名字对应到相应的系列
                        name:'男性',
                        data: data.maleNum
                    },
                    {
                        // 根据名字对应到相应的系列
                        name:'女性',
                        data: data.femaleNum
                    },
                    {
                        name:'总注册量',
                        data:data.tempTotal
                    },
                    {
                        name:'比例',
                        data:pies
                    }

                ]
            });
        },function (error) {
            toastr.error("系统错误");
            return false;
        });
    </script>

</body>
