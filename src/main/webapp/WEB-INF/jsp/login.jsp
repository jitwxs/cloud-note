<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <title></title>
    <%-- Required meta tags always come first --%>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <%-- Bootstrap CSS --%>
    <link rel="stylesheet" href="${ctx}/css/bootstrap.css">
    <link rel="stylesheet" href="${ctx}/css/toastr.css">
    <%-- jQuery first, then Bootstrap JS. --%>
    <script src="${ctx}/js/jquery-3.2.1.min.js"></script>
    <script src="${ctx}/js/bootstrap.js"></script>
    <script src="${ctx}/js/toastr.js"></script>
    <script src="${ctx}/js/http.js"></script>
    <style type="text/css">
        *{
            margin: 0;
            padding: 0;
        }
        body{
            background: #fbfcfe;
        }
        header{
            background: lightskyblue;
            width:100%;
            height:50px;
        }
        #main{
            width:900px;
            background: white;
            margin:0 auto;
            margin-top: 100px;
            position: relative;
            box-shadow:0px 0px  10px 5px #f4e6ff;
        }
        #main .left{
            margin-left: 15px;
            /*border:1px solid red;*/
            float: left;
        }
        #main .right{
            margin-left:10px ;
            /*border:1px solid red;*/
            float:left;
        }
        #main .right a{
            border-radius: 8px;
            width: 70%;
            height:50px;
            padding:13px;
            margin-left:60px;
            margin-top: 35px;
            background: white;
            color: lightskyblue;
            font-size: 18px;
            border: 1px solid lightskyblue;
        }
        #main .left button{
            width:130px;
            height: 45px;
            display: block;
            border-radius: 8px;
            font-size: 18px;
        }
        #login_btn{
            color: white;
            background: lightskyblue;
            font-size: 18px;
            float: left;
            margin-top: 18px;
            margin-left: 70px;
        }
        #register_btn{
            color: lightskyblue;
            font-size: 18px;
            background: white;
            margin-top: 18px;
            margin-right: 45px;
            float: right;
        }
    </style>
</head>

<body>
<canvas id="c" style="float: left;z-index: 0; position: fixed;top: 0;width: 100%;height: 100%;"></canvas>
<div id="main" style="height:490px;z-index: 2" >
    <p style="font-size: 30px;text-align: center;padding-top: 15px;font-family: Serif;">欢迎使用无道云笔记</p>
    <div class="left " style="width: 420px;height: 420px;">
        <p style="font-size: 18px;text-align: center;margin-top: 30px;font-family: Serif;">账号登录</p>
        <form method="post" action="${ctx}/login" onsubmit="return httpPost()">
            <div class="form-group" style="width: 307px;height: 50px;margin: 0 auto;margin-top: 45px;margin-left: 70px">
                <input style="width: 307px;height: 45px;" id="tel" class="form-control" type="text" name="tel" maxlength="11"  placeholder="手机号" >
            </div>
            <div class="form-group" style="width: 307px;height: 50px;margin: 0 auto;margin-top: 20px;margin-left: 70px">
                <input style="width: 307px;height: 45px;"id="password" class="form-control" type="password" name="password" placeholder="密码">
            </div>
            <div style="width:100px ;height: 40px;margin-left:313px;margin-top: 10px">
                <a href="${ctx}/foundPassword">忘记密码？</a>
            </div>

            <button id="login_btn" type="submit"  class="btn btn-default" >登录</button>
            <button id="register_btn" type="button" class="btn btn-default" onclick="window.location='${ctx}/register'">注册</button>
        </form>
    </div>
    <div class="center" style="height: 340px;margin-left:20px;margin-top: 20px;background: #f4e6ff;width: 1px;float: left;"></div>
    <div class="right " style="width: 420px;height: 420px;">
        <p style="font-size: 18px;text-align: center;margin-top: 30px;font-family: Serif;">快速登录</p>
        <a class="btn" style="padding-left: 33px" onclick="window.location.href='${ctx}/qqLogin'"><img src="${ctx}/images/qq.png">  使用QQ登录</a>
        <a style="margin-top: 50px;padding-left: 55px" class="btn" onclick="window.location.href='${ctx}/githubLogin'"><img src="${ctx}/images/github.png">  使用Github登录</a>
    </div>
</div>

<script>
    function httpPost() {
        var flag = false;
        var tel = $("#tel").val();
        var password = $("#password").val();
        var re=/^1\d{10}$/;
        if (!re.test(tel)) {
            toastr.warning("手机号不符合规范");
            return false;
        }
        sendPost('${ctx}/loginCheck',{'tel': tel,'password': password},false,function (msg) {
            if (!msg.status) {
                toastr.error(msg.info);
                flag = false;
            } else {
                flag = true;
            }
        },function (error) {
            toastr.error("系统错误");
            flag = false;
        });
        return flag;
    }

    //背景特效
    $(document).ready(function() {
        var canvas = document.getElementById("c");
        var ctx = canvas.getContext("2d");
        var c = $("#c");
        var w,h;
        var pi = Math.PI;
        var all_attribute = {
            num:100,            			 // 个数
            start_probability:0.1,		     // 如果数量小于num，有这些几率添加一个新的
            radius_min:1,   			     // 初始半径最小值
            radius_max:2,   			     // 初始半径最大值
            radius_add_min:.3,               // 半径增加最小值
            radius_add_max:.5,               // 半径增加最大值
            opacity_min:0.1,                 // 初始透明度最小值
            opacity_max:0.3, 				 // 初始透明度最大值
            opacity_prev_min:.003,            // 透明度递减值最小值
            opacity_prev_max:.005,            // 透明度递减值最大值
            light_min:20,                 // 颜色亮度最小值
            light_max:50                 // 颜色亮度最大值
        };
        var style_color = find_random(0,360);
        var all_element =[];
        window_resize();
        function start(){
            window.requestAnimationFrame(start);
            style_color+=.1;
            ctx.fillStyle = 'hsl('+style_color+',100%,97%)';
            ctx.fillRect(0, 0, w, h);
            if (all_element.length < all_attribute.num && Math.random() < all_attribute.start_probability){
                all_element.push(new ready_run);
            }
            all_element.map(function(line) {
                line.to_step();
            })
        }
        function ready_run(){
            this.to_reset();
        }
        ready_run.prototype = {
            to_reset:function(){
                var t = this;
                t.x = find_random(0,w);
                t.y = find_random(0,h);
                t.radius = find_random(all_attribute.radius_min,all_attribute.radius_max);
                t.radius_change = find_random(all_attribute.radius_add_min,all_attribute.radius_add_max);
                t.opacity = find_random(all_attribute.opacity_min,all_attribute.opacity_max);
                t.opacity_change = find_random(all_attribute.opacity_prev_min,all_attribute.opacity_prev_max);
                t.light = find_random(all_attribute.light_min,all_attribute.light_max);
                t.color = 'hsl('+style_color+',100%,'+t.light+'%)';
            },
            to_step:function(){
                var t = this;
                t.opacity -= t.opacity_change;
                t.radius += t.radius_change;
                if(t.opacity <= 0){
                    t.to_reset();
                    return false;
                }
                ctx.fillStyle = t.color;
                ctx.globalAlpha = t.opacity;
                ctx.beginPath();
                ctx.arc(t.x,t.y,t.radius,0,2*pi,true);
                ctx.closePath();
                ctx.fill();
                ctx.globalAlpha = 1;
            }
        }
        function window_resize(){
            w = window.innerWidth;
            h = window.innerHeight;
            canvas.width = w;
            canvas.height = h;
        }
        $(window).resize(function(){
            window_resize();
        });
        function find_random(num_one,num_two){
            return Math.random()*(num_two-num_one)+num_one;
        }
        (function() {
            var lastTime = 0;
            var vendors = ['webkit', 'moz'];
            for(var xx = 0; xx < vendors.length && !window.requestAnimationFrame; ++xx) {
                window.requestAnimationFrame = window[vendors[xx] + 'RequestAnimationFrame'];
                window.cancelAnimationFrame = window[vendors[xx] + 'CancelAnimationFrame'] ||
                    window[vendors[xx] + 'CancelRequestAnimationFrame'];
            }

            if (!window.requestAnimationFrame) {
                window.requestAnimationFrame = function(callback, element) {
                    var currTime = new Date().getTime();
                    var timeToCall = Math.max(0, 16.7 - (currTime - lastTime));
                    var id = window.setTimeout(function() {
                        callback(currTime + timeToCall);
                    }, timeToCall);
                    lastTime = currTime + timeToCall;
                    return id;
                };
            }
            if (!window.cancelAnimationFrame) {
                window.cancelAnimationFrame = function(id) {
                    clearTimeout(id);
                };
            }
        }());
        start();
    });
</script>
</body>

</html>