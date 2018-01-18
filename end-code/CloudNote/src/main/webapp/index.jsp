<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en" >

<head>
    <meta charset="UTF-8">
    <title>无道云笔记</title>
    <script src="${ctx}/js/jquery-3.2.1.min.js"></script>
    <script src="${ctx}/js/bootstrap.js"></script>
    <script src="${ctx}/js/chinamap.js"></script>
    <script src="${ctx}/js/http.js"></script>
    <link rel="stylesheet" href="${ctx}/css/index.css">
    <link rel="stylesheet" href="${ctx}/css/bootstrap.css">
    <link rel="stylesheet" href="${ctx}/css/chinamap.css">
</head>

<body>
<div class="navbar navbar-fixed-top " style="background-color: #4494ff">
    <div class="navbar-header">
        <a class="navbar-brand" href="#" style="font-size: 20px;color: white">无道云笔记</a>
        <button type="button" class="navbar-toggle navbar-toggle-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
        <a class="navbar-toggle navbar-toggle-collapse navbar-login" href="${ctx}/login">登录</a>
    </div>
    <div class="navbar-nav-collapse" id="navbar-link">
        <ul class="navbar-nav navbar-right">
            <li><a class="navbar-nav-link active" href="${ctx}/">首页</a></li>
            <li><a class="navbar-nav-link" href="${ctx}/login">登录</a></li>
            <li><a class="navbar-nav-link" href="${ctx}/register">注册</a></li>

        </ul>
    </div>
</div>
<div style="height: 98%;width:100%;margin-top: 50px">
    <canvas class="canvas" style="height:98%;width: 100%;"></canvas>
    <div class="help"></div>
    <div class="ui" style="display: none">
        <input class="ui-input" type="text"/>
    </div>
    <div class="overlay">
        <div class="tabs">
            <div class="tabs-labels">
                <span class="tabs-label"></span>
            </div>
            <div class="tabs-panels">
                <ul class="tabs-panel commands">
                </ul>
            </div>
        </div>
    </div>
</div>

<div class="data-manager">
    <div class="container text-center">
        <div class="row">
            <div class="col-xs-12 text-center"><h2>记录、保存、整理、分享</h2></div>
        </div>
        <div class="row">
            <div class="col-sm-4 col-xs-6">
                <img class="img-responsive center-block" src="${ctx}/images/note.png">
                <h3>记录</h3>
                <p>以文字、清单、图片、等形式记录，一次记录永久保存。</p>
            </div>
            <div class="col-sm-4 col-xs-6">
                <img class="img-responsive center-block" src="${ctx}/images/edit.png">
                <h3>编辑</h3>
                <p>遵循Office习惯的轻量级编辑工具，同时支持各种格式转换，帮你写出漂亮的文档。</p>
            </div>
            <div class="col-sm-4 col-xs-6">
                <img class="img-responsive center-block" src="${ctx}/images/save.png">
                <h3>保存</h3>
                <p>资料永久保存，无需担心资料丢失。</p>
            </div>
            <div class="col-sm-4 col-xs-6">
                <img class="img-responsive center-block" src="${ctx}/images/share.png">
                <h3>共享</h3>
                <p>用链接、QQ、微信等方式分享资料给任何人，用群组和团队成员一起共享资料。</p>
            </div>
            <div class="col-sm-4 col-xs-6">
                <img class="img-responsive center-block" src="${ctx}/images/arrange.png">
                <h3>整理</h3>
                <p>使用多级文件夹、标签和笔记内链整理资料，让资料井井有条。</p>
            </div>
            <div class="col-sm-4 col-xs-6">
                <img class="img-responsive center-block" src="${ctx}/images/search.png">
                <h3>查找</h3>
                <p>通过文件夹、关键词搜索、快捷方式、近期笔记和消息等方式快速找到所需资料。</p>
            </div>
        </div>
    </div>
</div>

<div class="container2 mooc-box">
    <p>无道云笔记在线记录平台</p>
    <h2>轻松 · 高效 · 超越期待</h2>
    <a href="${ctx}/login" >立即使用</a>
</div>
<div id="map" style="height: 600px;width: 100%;"></div>
<div class="footer">
    <div class="myfooter" style="padding-top:20px">
        <div class="footer_text"><a class="footer"  href="http://www.miitbeian.gov.cn/">苏 ICP 备 16061429
            号</a></div>
        <div class="footer_text">Designed By <a class="footer" >无道云笔记团队 </a>
            &copy; 2018
        </div>
        <div class="footer_text">邮箱：jitwxs@foxmail.com | 地址：南京市江宁区弘景大道99号</div>
    </div>
</div>
<script src="${ctx}/js/index.js"></script>
<script>
    var map = L.map('map');
    var baseLayers = {
        'GeoQ灰色底图': L.tileLayer('http://map.geoq.cn/ArcGIS/rest/services/ChinaOnlineStreetPurplishBlue/MapServer/tile/{z}/{y}/{x}').addTo(map)
    };
    L.tileLayer('https://a.tiles.mapbox.com/v3/foursquare.map-0y1jh28j/{z}/{x}/{y}.png', {
        attribution: 'Map &copy; Pacific Rim Coordination Center (PRCC).  Certain data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>',
        key: 'BC9A493B41014CAABB98F0471D759707',
        styleId: 22677
    });
    var layercontrol = L.control.layers(baseLayers,{}, {
        position: "topleft"
    }).addTo(map);
    map.setView(L.latLng(37.550339, 104.114129), 4);
    var overlay = new L.echartsLayer3(map, echarts);
    var chartsContainer = overlay.getEchartsContainer();
    var myChart = overlay.initECharts(chartsContainer);
    var geoCoordMap = {
        '上海': [121.4648, 31.2891],
        '东莞': [113.8953, 22.901],
        '东营': [118.7073, 37.5513],
        '中山': [113.4229, 22.478],
        '临汾': [111.4783, 36.1615],
        '临沂': [118.3118, 35.2936],
        '丹东': [124.541, 40.4242],
        '丽水': [119.5642, 28.1854],
        '乌鲁木齐': [87.9236, 43.5883],
        '佛山': [112.8955, 23.1097],
        '保定': [115.0488, 39.0948],
        '兰州': [103.5901, 36.3043],
        '包头': [110.3467, 41.4899],
        '北京': [116.4551, 40.2539],
        '北海': [109.314, 21.6211],
        '南京': [118.8062, 31.9208],
        '南宁': [108.479, 23.1152],
        '南昌': [116.0046, 28.6633],
        '南通': [121.1023, 32.1625],
        '厦门': [118.1689, 24.6478],
        '台州': [121.1353, 28.6688],
        '合肥': [117.29, 32.0581],
        '呼和浩特': [111.4124, 40.4901],
        '咸阳': [108.4131, 34.8706],
        '哈尔滨': [127.9688, 45.368],
        '唐山': [118.4766, 39.6826],
        '嘉兴': [120.9155, 30.6354],
        '大同': [113.7854, 39.8035],
        '大连': [122.2229, 39.4409],
        '天津': [117.4219, 39.4189],
        '太原': [112.3352, 37.9413],
        '威海': [121.9482, 37.1393],
        '宁波': [121.5967, 29.6466],
        '宝鸡': [107.1826, 34.3433],
        '宿迁': [118.5535, 33.7775],
        '常州': [119.4543, 31.5582],
        '广州': [113.5107, 23.2196],
        '廊坊': [116.521, 39.0509],
        '延安': [109.1052, 36.4252],
        '张家口': [115.1477, 40.8527],
        '徐州': [117.5208, 34.3268],
        '德州': [116.6858, 37.2107],
        '惠州': [114.6204, 23.1647],
        '成都': [103.9526, 30.7617],
        '扬州': [119.4653, 32.8162],
        '承德': [117.5757, 41.4075],
        '拉萨': [91.1865, 30.1465],
        '无锡': [120.3442, 31.5527],
        '日照': [119.2786, 35.5023],
        '昆明': [102.9199, 25.4663],
        '杭州': [119.5313, 29.8773],
        '枣庄': [117.323, 34.8926],
        '柳州': [109.3799, 24.9774],
        '株洲': [113.5327, 27.0319],
        '武汉': [114.3896, 30.6628],
        '汕头': [117.1692, 23.3405],
        '江门': [112.6318, 22.1484],
        '沈阳': [123.1238, 42.1216],
        '沧州': [116.8286, 38.2104],
        '河源': [114.917, 23.9722],
        '泉州': [118.3228, 25.1147],
        '泰安': [117.0264, 36.0516],
        '泰州': [120.0586, 32.5525],
        '济南': [117.1582, 36.8701],
        '济宁': [116.8286, 35.3375],
        '海口': [110.3893, 19.8516],
        '淄博': [118.0371, 36.6064],
        '淮安': [118.927, 33.4039],
        '深圳': [114.5435, 22.5439],
        '清远': [112.9175, 24.3292],
        '温州': [120.498, 27.8119],
        '渭南': [109.7864, 35.0299],
        '湖州': [119.8608, 30.7782],
        '湘潭': [112.5439, 27.7075],
        '滨州': [117.8174, 37.4963],
        '潍坊': [119.0918, 36.524],
        '烟台': [120.7397, 37.5128],
        '玉溪': [101.9312, 23.8898],
        '珠海': [113.7305, 22.1155],
        '盐城': [120.2234, 33.5577],
        '盘锦': [121.9482, 41.0449],
        '石家庄': [114.4995, 38.1006],
        '福州': [119.4543, 25.9222],
        '秦皇岛': [119.2126, 40.0232],
        '绍兴': [120.564, 29.7565],
        '聊城': [115.9167, 36.4032],
        '肇庆': [112.1265, 23.5822],
        '舟山': [122.2559, 30.2234],
        '苏州': [120.6519, 31.3989],
        '莱芜': [117.6526, 36.2714],
        '菏泽': [115.6201, 35.2057],
        '营口': [122.4316, 40.4297],
        '葫芦岛': [120.1575, 40.578],
        '衡水': [115.8838, 37.7161],
        '衢州': [118.6853, 28.8666],
        '西宁': [101.4038, 36.8207],
        '西安': [109.1162, 34.2004],
        '贵阳': [106.6992, 26.7682],
        '连云港': [119.1248, 34.552],
        '邢台': [114.8071, 37.2821],
        '邯郸': [114.4775, 36.535],
        '郑州': [113.4668, 34.6234],
        '鄂尔多斯': [108.9734, 39.2487],
        '重庆': [107.7539, 30.1904],
        '金华': [120.0037, 29.1028],
        '铜川': [109.0393, 35.1947],
        '银川': [106.3586, 38.1775],
        '镇江': [119.4763, 31.9702],
        '长春': [125.8154, 44.2584],
        '长沙': [113.0823, 28.2568],
        '长治': [112.8625, 36.4746],
        '阳泉': [113.4778, 38.0951],
        '青岛': [120.4651, 36.3373],
        '韶关': [113.7964, 24.7028]
    };

    var NJData = [];

    sendGet('${ctx}/showUserCity',{},false,function (res) {
        for(var i=0; i<res.length; i++) {
            var key = res[i].k;
            var val = res[i].v*10;
            NJData.push([{name: "南京"}, {name: key, value: val}]);
        }
    },function (error) {
        toastr.error("系统错误");
        return false;
    });

    var planePath = 'path://M1705.06,1318.313v-89.254l-319.9-221.799l0.073-208.063c0.521-84.662-26.629-121.796-63.961-121.491c-37.332-0.305-64.482,36.829-63.961,121.491l0.073,208.063l-319.9,221.799v89.254l330.343-157.288l12.238,241.308l-134.449,92.931l0.531,42.034l175.125-42.917l175.125,42.917l0.531-42.034l-134.449-92.931l12.238-241.308L1705.06,1318.313z';

    var convertData = function (data) {
        var res = [];
        for (var i = 0; i < data.length; i++) {
            var dataItem = data[i];
            var fromCoord = geoCoordMap[dataItem[0].name];
            var toCoord = geoCoordMap[dataItem[1].name];
            if (fromCoord && toCoord) {
                res.push([{
                    coord: fromCoord
                }, {
                    coord: toCoord
                }]);
            }
        }
        return res;
    };

    var color = [ '#ffa022'];
    var series = [];
    [ ['南京', NJData]].forEach(function (item, i) {
        series.push({
                name: item[0] + ' Top10',
                type: 'lines',
                zlevel: 1,
                effect: {
                    show: true,
                    period: 6,
                    trailLength: 0.7,
                    color: '#fff',
                    symbolSize: 3
                },
                lineStyle: {
                    normal: {
                        color: color[i],
                        width: 0,
                        curveness: 0.2
                    }
                },
                data: convertData(item[1])
            },
            {
                name: item[0] + ' Top10',
                type: 'lines',
                zlevel: 2,
                effect: {
                    show: true,
                    period: 6,
                    trailLength: 0,
                    symbol: planePath,
                    symbolSize: 15
                },
                lineStyle: {
                    normal: {
                        color: color[i],
                        width: 1,
                        opacity: 0.4,
                        curveness: 0.2
                    }
                },
                data: convertData(item[1])
            },
            {
                name: item[0] + ' Top10',
                type: 'effectScatter',
                coordinateSystem: 'geo',
                zlevel: 2,
                rippleEffect: {
                    brushType: 'stroke'
                },
                label: {
                    normal: {
                        show: true,
                        position: 'right',
                        formatter: '{b}'
                    }
                },
                symbolSize: function (val) {
                    return val[2] / 8;
                },
                itemStyle: {
                    normal: {
                        color: color[i]
                    }
                },
                data: item[1].map(function (dataItem) {
                    return {
                        name: dataItem[1].name,
                        value: geoCoordMap[dataItem[1].name].concat([dataItem[1].value])
                    };
                })
            });
    });

    option = {
//        backgroundColor: '#404a59',
        title: {
            text: '用户分布图',
            left: 'center',
            textStyle: {
                color: '#fff'
            }
        },
        tooltip: {
            trigger: 'item'
        },
        legend: {
            orient: 'vertical',
            top: 'bottom',
            left: 'right',
            data: [ '南京 Top10'],
            textStyle: {
                color: '#fff'
            },
            selectedMode: 'single'
        },
        geo: {
            map: '',
            label: {
                emphasis: {
                    show: false
                }
            },
            roam: true,
            itemStyle: {
                normal: {
                    areaColor: '#323c48',
                    borderColor: '#404a59'
                },
                emphasis: {
                    areaColor: '#2a333d'
                }
            }
        },
        series: series
    };
    // 使用刚指定的配置项和数据显示图表。
    overlay.setOption(option);
</script>

</body>

</html>
