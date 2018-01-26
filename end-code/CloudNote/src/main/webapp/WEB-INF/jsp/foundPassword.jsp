<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>找回密码</title>
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
    <script src="${ctx}/js/jquery.cookie.js"></script>
    <script src="${ctx}/js/http.js"></script>
    <style>
        *{
            margin: 0;
            padding: 0;
        }
        body{
            background: #fbfcfe;
        }
        #main{
            width: 400px;
            height:390px;
            box-shadow:0px 0px  10px 5px #f4e6ff;
            margin:0 auto;
            margin-top: 100px;
            position: relative;
        }
        header{
            width: 400px;
            height:45px;
        }
        .inputPhone{
            margin-top: 30px;
        }

        #main .inputPhone .name{
            width: 370px;
            margin-left: 15px;
            margin-top: 20px;
        }

        .send{
            width:110px;
            height:35px;
            border-radius: 5px;
            background: #46b4e6;
            color: white;
            margin-right: 15px;
            float: right;
            margin-top: 15px;
        }
        .changePasswd p{
            font-size: 15px;
            line-height: 15px;
            text-align: center;
            color: #949494;
        }
        #main .changePasswd .changePassword{
            text-align: left;
            margin-left: 15px;
            font-size: 20px;
            color: #949494;
        }
        #main .changePasswd .mima{
            width:300px;
            float: left;
            margin-left: 15px;

        }
        #main .changePasswd .r_mima{
            width:300px;
            float: left;
            margin-left: 15px;

        }
        #reset{
            color: white;
            font-size: 20px;
            background: #46B4E6;
            margin-left: 130px;
            margin-top: 30px;
            width:150px;
        }
    </style>
</head>

<body>
<canvas id="c" style="float: left;z-index: 0; position: fixed;top: 0;width: 100%;height: 100%;"></canvas>

<div id="main" style="position: relative;z-index: 2;background: white">
    <header >
        <p style="font-size: 20px;line-height: 45px;text-align: center;color: black;font-family: Serif">找回密码</p>
    </header>
    <div class="inputPhone" >
        <input id="tel" type="text" class="form-control name"
               placeholder="请输入手机号获取验证码" required="required">
        <input type="button" class="btn send" style="margin-bottom: 15px;cursor: pointer;" id="getting" value="发送验证码" onclick="ses_verification()">

        <input id="verityCode" name="code" style="margin-top: 35px" type="text" class="form-control name"
               placeholder="请输入验证码">
        <a class="btn send" onclick="checkCode()">确定</a>
    </div>

    <div class="changePasswd " style="display: none">
        <p style="margin-top: 20px;">您正在通过手机验证找回密码，</p>
        <p style="margin-top: 10px">请输入新密码并重复确认，以完成密码重置操作</p>
        <hr>
        <p class="changePassword" >新密码：</p>
        <input id="newPassword" style="margin-top: 5px" type="password" class="form-control mima"
               placeholder="请输入新密码" required="required">
        <p class="changePassword" style="margin-top: 60px">确认密码：</p>
        <input id="checkPassword" style="margin-top: 5px" type="password" class="form-control r_mima"
               placeholder="确认新密码" required="required">
        <a class="btn" id="reset" onclick="reset()">重置密码</a>
    </div>
</div>

<script>
    /*仿刷新：检测是否存在cookie*/
    if($.cookie("captcha")){
        var count = $.cookie("captcha");
        var btn = $('#getting');
        btn.val(count+'秒后重新获取').attr('disabled',true).css('cursor','not-allowed');
        var resend = setInterval(function(){
            count--;
            if (count > 0){
                btn.val(count+'秒后重新获取').attr('disabled',true).css('cursor','not-allowed');
                $.cookie("captcha", count, {path: '/', expires: (1/86400)*count});
            }else {
                clearInterval(resend);
                btn.val("发送验证码").removeClass('disabled').removeAttr('disabled style');

            }
        }, 1000);
    }
    function checkCode(){
        var tel = $('#tel').val();
        var re=/^1\d{10}$/;
        var verityCode = $("#verityCode").val();
        if (!re.test(tel)) {
            toastr.warning("手机号不符合规范");
            return false;
        }

        sendPost('${ctx}/codeCheck',{'tel': tel,'verityCode':verityCode},false,function (msg) {
            if(msg.status) {
                toastr.success(msg.info);
                $('.inputPhone').hide();
                $('.changePasswd').show();
            } else {
                toastr.warning(msg.info);
            }
        },function (error) {
            toastr.error("系统错误");
            return false;
        });
    }

    function reset(){
        var tel = $('#tel').val();
        var newPassword= $('#newPassword').val();
        var checkPassword = $('#checkPassword').val();
        var verityCode = $("#verityCode").val();
        if (newPassword != checkPassword){
            toastr.warning("两次密码不一致！");
            return false;
        }

        sendPost('${ctx}/foundPassword',{'tel': tel,'newPassword':newPassword,'verityCode':verityCode},false,function (msg) {
            if(msg.status) {
                toastr.success("修改成功，3秒后前往登陆页面！");
                setTimeout(function(){ window.location.href="${ctx}/login"; }, 3000);
            } else {
                toastr.warning(msg.info);
            }
        },function (error) {
            toastr.error("系统错误");
            return false;
        });
    }

    function ses_verification() {
        var flag = true;
        var tel = $("#tel").val();
        var re = /^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(17[0-9]{1}))+\d{8})$/;
        if (!re.test(tel)) {
            toastr.warning("手机号不符合规范");
            return false;
        }else{
            sendPost('${ctx}/checkTelRegistered',{'tel':tel},false,function(msg) {
                if (msg.status) {
                    toastr.error("该手机号未被注册");
                    flag = false;
                } else {
                    toastr.success("该手机号注册");
                }
            },function (error) {
                toastr.error("系统错误");
                flag = false;
                return false;
            });

            if(flag) {
                sendPost('${ctx}/smsVerification',{'tel': tel},false,function (msg) {
                    if (msg.status) {
                        toastr.success("发送成功");
                    } else {
                        flag = false;
                        toastr.info("发送失败");
                    }
                },function (error) {
                    toastr.error("系统错误");
                    return false;
                });

                if(flag) {
                    var btn = $('#getting');
                    var count = 60; //设置默认60s后获取
                    var resend = setInterval(function(){
                        count--;
                        if (count > 0){
                            btn.val(count+"秒后重新获取");
                            $.cookie("captcha", count, {path: '/', expires: (1/86400)*count});
                        }else {
                            clearInterval(resend);
                            btn.val("发送验证码").removeAttr('disabled style');
                            btn.val("发送验证码").css("margin-bottom","15px");
                        }
                    }, 1000);
                    btn.attr('disabled',true).css('cursor','not-allowed');
                }
            }
        }
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
            light_max:50,                 // 颜色亮度最大值
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