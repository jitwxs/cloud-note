<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>无道云笔记</title>
    <%-- Required meta tags always come first --%>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <%-- Bootstrap CSS --%>
    <link rel="stylesheet" href="${ctx}/css/bootstrap.css">
    <link rel="stylesheet" href="${ctx}/css/bootstrap-theme.css">
    <link rel="stylesheet" href="${ctx}/css/wangEditor-fullscreen-plugin.css">
    <%-- 弹窗CSS --%>
    <link rel="stylesheet" href="${ctx}/css/toastr.css">
    <link rel="stylesheet" href="${ctx}/css/simple-alert.css">
    <%-- home页CSS --%>
    <link rel="stylesheet" href="${ctx}/css/home.css">
    <%-- jQuery first, then Bootstrap JS. --%>
    <script src="${ctx}/js/jquery-3.2.1.min.js"></script>
    <script src="${ctx}/js/bootstrap.js"></script>
    <%-- jQuery百叶窗 --%>
    <script src="${ctx}/js/jquery.contextify.js"></script>
    <%-- wangEditor依赖 --%>
    <script src="${ctx}/js/wangEditor.js"></script>
    <script src="${ctx}/js/wangEditor-fullscreen-plugin.js"></script>
    <%-- 弹窗依赖 --%>
    <script src="${ctx}/js/toastr.js"></script>
    <%-- 封装ajax --%>
    <script src="${ctx}/js/http.js"></script>
    <%-- home页JS --%>
    <script src="${ctx}/js/home.js"></script>
    <%--弹出框js--%>
    <script src="${ctx}/js/simple-alert.js"></script>
</head>

<body style="margin-top: 60px;position: absolute;width: 100%;height: auto;" id="home_body">
<%-- 引入模块框 --%>
<jsp:include page="../showSelfInfoModel.jsp"/>
<jsp:include page="shareNoteModel.jsp"/>
<jsp:include page="uploadNote.jsp"/>
<jsp:include page="noteMoveToModel.jsp"/>

<input type="hidden" id="lastLoginTime" value="${lastLoginTime}">
<input type="hidden" id="searchResId" value="${searchResId}">
<input type="hidden" id="searchResName" value="${searchResName}">

<%-- 导航栏 --%>
<jsp:include page="nav.jsp"/>

<%-- 分享区域 --%>
<jsp:include page="share.jsp"/>

<%--主体--%>
<canvas id="c" style="float: left;z-index: 0; position: fixed;top:0;width: 100%;height: 100%;"></canvas>

<div class="container" style="padding-right: 0px; width:98%;height: auto;" id="left">
    <div class="row">
        <div id="wangeditor" class="col-md-10">
            <%-- 目录区域 --%>
            <jsp:include page="directory.jsp"/>
            <%-- 编辑器区域 --%>
            <jsp:include page="articleEditor.jsp"/>
        </div>

        <%-- 广告位 --%>
        <div class="col-md-2 visible-lg" style="height: 700px;z-index:999">
            <img src="${ctx}/images/advertise.png" style="width:100%;height: 100%"/>
        </div>
    </div>
</div>

<script>
    $(function () {
        // 初始化头部小头像和下拉框名
        sendGet('${ctx}/showSelfInfo', {}, true, function (res) {
            var userTel = res.userDto.tel;
            $("#userSmallName").html(res.userDto.name);
            $("#userSmallIcon").attr('src', res.userDto.icon);

            // 初始化未读消息
            var unReadMsg = parseInt(res.info);
            if (unReadMsg != 0) {
                $('.badge').text(unReadMsg);
            } else {
                $('.badge').hide();
            }
        }, function (error) {
            toastr.error("系统错误");
        });

        // 打印上次登陆事件
        var lastTime = $("#lastLoginTime").val();
        if (lastTime != null && lastTime != "") {
            toastr.info(lastTime);
            $("#text1").val(null);
        }

        // 获取最后选择笔记信息
        var searchResId = $("#searchResId").val();
        var searchResName = $("#searchResName").val();
        if (searchResId != null && searchResId != "") {
            flushNote(searchResId, searchResName);
            $("#affixNoteId").val(searchResId);
            $("#editorTitle").val(searchResName);
        }
    });

    //背景特效
    $(document).ready(function () {
        var canvas = document.getElementById("c");
        var ctx = canvas.getContext("2d");
        var c = $("#c");
        var w, h;
        var pi = Math.PI;
        var all_attribute = {
            num: 100,            			 // 个数
            start_probability: 0.1,		     // 如果数量小于num，有这些几率添加一个新的
            radius_min: 1,   			     // 初始半径最小值
            radius_max: 2,   			     // 初始半径最大值
            radius_add_min: .3,               // 半径增加最小值
            radius_add_max: .5,               // 半径增加最大值
            opacity_min: 0.1,                 // 初始透明度最小值
            opacity_max: 0.3, 				 // 初始透明度最大值
            opacity_prev_min: .003,            // 透明度递减值最小值
            opacity_prev_max: .005,            // 透明度递减值最大值
            light_min: 20,                 // 颜色亮度最小值
            light_max: 50                  // 颜色亮度最大值
        };
        var style_color = find_random(0, 360);
        var all_element = [];
        window_resize();

        function start() {
            window.requestAnimationFrame(start);
            style_color += .1;
            ctx.fillStyle = 'hsl(' + style_color + ',100%,97%)';
            ctx.fillRect(0, 0, w, h);
            if (all_element.length < all_attribute.num && Math.random() < all_attribute.start_probability) {
                all_element.push(new ready_run);
            }
            all_element.map(function (line) {
                line.to_step();
            })
        }

        function ready_run() {
            this.to_reset();
        }

        ready_run.prototype = {
            to_reset: function () {
                var t = this;
                t.x = find_random(0, w);
                t.y = find_random(0, h);
                t.radius = find_random(all_attribute.radius_min, all_attribute.radius_max);
                t.radius_change = find_random(all_attribute.radius_add_min, all_attribute.radius_add_max);
                t.opacity = find_random(all_attribute.opacity_min, all_attribute.opacity_max);
                t.opacity_change = find_random(all_attribute.opacity_prev_min, all_attribute.opacity_prev_max);
                t.light = find_random(all_attribute.light_min, all_attribute.light_max);
                t.color = 'hsl(' + style_color + ',100%,' + t.light + '%)';
            },
            to_step: function () {
                var t = this;
                t.opacity -= t.opacity_change;
                t.radius += t.radius_change;
                if (t.opacity <= 0) {
                    t.to_reset();
                    return false;
                }
                ctx.fillStyle = t.color;
                ctx.globalAlpha = t.opacity;
                ctx.beginPath();
                ctx.arc(t.x, t.y, t.radius, 0, 2 * pi, true);
                ctx.closePath();
                ctx.fill();
                ctx.globalAlpha = 1;
            }
        };

        function window_resize() {
            w = window.innerWidth;
            h = window.innerHeight;
            canvas.width = w;
            canvas.height = h;
        }

        $(window).resize(function () {
            window_resize();
        });

        function find_random(num_one, num_two) {
            return Math.random() * (num_two - num_one) + num_one;
        }

        (function () {
            var lastTime = 0;
            var vendors = ['webkit', 'moz'];
            for (var xx = 0; xx < vendors.length && !window.requestAnimationFrame; ++xx) {
                window.requestAnimationFrame = window[vendors[xx] + 'RequestAnimationFrame'];
                window.cancelAnimationFrame = window[vendors[xx] + 'CancelAnimationFrame'] ||
                    window[vendors[xx] + 'CancelRequestAnimationFrame'];
            }

            if (!window.requestAnimationFrame) {
                window.requestAnimationFrame = function (callback, element) {
                    var currTime = new Date().getTime();
                    var timeToCall = Math.max(0, 16.7 - (currTime - lastTime));
                    var id = window.setTimeout(function () {
                        callback(currTime + timeToCall);
                    }, timeToCall);
                    lastTime = currTime + timeToCall;
                    return id;
                };
            }
            if (!window.cancelAnimationFrame) {
                window.cancelAnimationFrame = function (id) {
                    clearTimeout(id);
                };
            }
        }());
        start();
    });
</script>
</body>
</html>