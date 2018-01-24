<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
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
        .container1 {
            margin-top:15px;
        }
        #regist_body{
            /*background: #fbfcfe;*/
        }
        .red {
            color:red;
        }
        #ehong-code-input {
            width:42px;
            letter-spacing:2px;
            margin:0px 8px 0px 0px;
        }
        .ehong-idcode-val {
            position:relative;
            padding:1px 4px 1px 4px;
            top:0px;
            *top:-3px;
            letter-spacing:4px;
            display:inline;
            cursor:pointer;
            font-size:16px;
            font-family:"Courier New",Courier,monospace;
            text-decoration:none;
            font-weight:bold;
        }
        .ehong-idcode-val0 {
            border:solid 1px #A4CDED;
            background-color:#ECFAFB;
        }
        .ehong-idcode-val1 {
            border:solid 1px #A4CDED;
            background-color:#FCEFCF;
        }
        .ehong-idcode-val2 {
            border:solid 1px #6C9;
            background-color:#D0F0DF;
        }
        .ehong-idcode-val3 {
            border:solid 1px #6C9;
            background-color:#DCDDD8;
        }
        .ehong-idcode-val4 {
            border:solid 1px #6C9;
            background-color:#F1DEFF;
        }
        .ehong-idcode-val5 {
            border:solid 1px #6C9;
            background-color:#ACE1F1;
        }
        .ehong-code-val-tip {
            font-size:12px;
            color:#1098EC;
            top:0px;
            *top:-3px;
            position:relative;
            margin:0px 0px 0px 4px;
            cursor:pointer;
        }
    </style>
</head>
<body id="regist_body">
<canvas id="c" style="float: left;z-index: 0; position: fixed;top: 0;width: 100%;height: 100%"></canvas>

<div class="container1" style="position: relative;z-index: 2;background: white; margin:0 auto;margin-top: 80px;box-shadow:0px 0px  10px 5px #f4e6ff; width: 70%;padding-left: 20px;height: 620px;">
    <div>
        <p style="text-align: center;margin-bottom: 50px;font-size: 30px;padding-top: 50px;font-family: Inconsolata">欢迎使用无道云笔记</p>
        <form action="${ctx}/register" method="post" onsubmit="return checkRegister()">
            <div class="row" style="width: 100%;margin-left: 0px">
                <div class="col-lg-6" style=" height: 500px;">
                    <h3 style="color: #ff9476">下面为必填信息</h3>
                    <!--手机号-->
                    <div class="form-group has-feedback">
                        <div class="input-group">
                            <span class="input-group-addon"><span class="glyphicon glyphicon-phone"></span></span>
                            <input id="tel" name="tel" class="form-control" placeholder="请输入手机号码" maxlength="11" type="text" style="height:
                    50px;">
                        </div>
                        <span style="color:red;display: none;" class="tips"></span>
                        <span style="display: none;" class="glyphicon glyphicon-remove form-control-feedback"></span>
                        <span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
                    </div>

                    <!--密码-->
                    <div class="form-group has-feedback">
                        <div class="input-group">
                            <span class="input-group-addon"><span class="glyphicon glyphicon-lock"></span></span>
                            <input id="password" name="password" class="form-control" placeholder="请输入密码" maxlength="20" type="password" style="height: 50px;">
                        </div>

                        <span style="color:red;display: none;" class="tips"></span>
                        <span style="display: none;" class="glyphicon glyphicon-remove form-control-feedback"></span>
                        <span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
                    </div>

                    <!--确认密码-->
                    <div class="form-group has-feedback">
                        <div class="input-group">
                            <span class="input-group-addon"><span class="glyphicon glyphicon-lock"></span></span>
                            <input id="password1" class="form-control" placeholder="请再次输入密码" maxlength="20" type="password" style="height: 50px;">
                        </div>
                        <span style="color:red;display: none;" class="tips"></span>
                        <span style="display: none;" class="glyphicon glyphicon-remove form-control-feedback"></span>
                        <span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
                    </div>

                    <!--昵称-->
                    <div class="form-group has-feedback">
                        <div class="input-group">
                            <span class="input-group-addon"><span class="glyphicon glyphicon-user"></span></span>
                            <input id="second_name" name="name" class="form-control" placeholder="请输入昵称" maxlength="20" type="text" style="height: 50px;">
                        </div>

                        <span style="color:red;display: none;" class="tips"></span>
                        <span style="display: none;" class=" glyphicon glyphicon-remove form-control-feedback"></span>
                        <span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
                    </div>

                    <!--返回登陆-->
                    <div class="form-group">
                        <a href="${ctx}/" style="text-decoration: none;">
                            <input id="backtoLogin" type="backtoLogin" class="form-control btn-lg "
                                   value="返&nbsp;&nbsp;回&nbsp;&nbsp;首&nbsp;&nbsp;页"
                                   style="height: 50px;background: white;border: solid 1px darkgrey;
                                   color:indianred;text-align: center;cursor: pointer">
                        </a>
                    </div>

                </div>
                <div class="col-lg-6" style="height: 500px;">
                    <h3>下面为可选填信息</h3>
                    <!--邮箱-->
                    <div class="form-group has-feedback">
                        <div class="input-group">
                            <span class="input-group-addon"><span class="glyphicon glyphicon-envelope"></span></span>
                            <input id="email" class="form-control " name="email" placeholder="请输入邮箱" maxlength="20" type="email" style="height: 50px;">
                        </div>
                        <span style="color:red;display: none;" class="tips"></span>
                        <span style="display: none;" class=" glyphicon glyphicon-remove form-control-feedback"></span>
                        <span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
                    </div>

                    <!--居住地址-->
                    <div class="form-group has-feedback">
                        <div class="input-group">
                            <span class="input-group-addon"><span class="glyphicon glyphicon-globe"></span></span>
                            <input id="area" class="form-control" name="area" placeholder="请输入居住城市" maxlength="20" type="text" style="height: 50px;">
                        </div>
                        <span style="color:red;display: none;" class="tips"></span>
                        <span style="display: none;" class=" glyphicon glyphicon-remove form-control-feedback"></span>
                        <span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
                    </div>

                    <!--性别-->
                    <div class="form-group has-feedback">
                        <div class="input-group">
                            <span class="input-group-addon"><span class="glyphicon glyphicon-adjust"></span></span>
                            <input id="sex" class="form-control" name="sex" placeholder="请输入性别（男或女，默认为男）" maxlength="20" type="text" style="height: 50px;">
                        </div>
                        <span style="color:red;display: none;" class="tips"></span>
                        <span style="display: none;" class=" glyphicon glyphicon-remove form-control-feedback"></span>
                        <span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
                    </div>

                    <!--验证码-->
                    <div class="row" >
                        <div class="col-xs-7">
                            <div class="form-group has-feedback">
                                <div class="input-group">
                                    <span class="input-group-addon"><span class="glyphicon glyphicon-qrcode"></span></span>
                                    <input id="idcode-btn" class="form-control" placeholder="请输入校验码" maxlength="6" type="text" style="height: 50px;">
                                </div>
                                <span style="color:red;display: none;" class="tips"></span>
                                <span style="display: none;" class="glyphicon glyphicon-remove form-control-feedback"></span>
                                <span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
                            </div>
                        </div>
                        <div class="col-xs-5 text-center">
                            <input type="button"  id="getting"  class="btn send  btn-lg " style="margin-bottom: 15px;width: 100%;background: white;border: solid 1px darkgrey;color: lightskyblue;font-size: inherit;" value="发送验证码">
                        </div>
                    </div>
                    <!--注册按钮-->
                    <div class="form-group">
                        <input  id="submit" type="submit" class="form-control btn-lg " value="立&nbsp;&nbsp;即&nbsp;&nbsp;注&nbsp;&nbsp;册"  style="height: 50px;background: white;border: solid 1px darkgrey;color: lightskyblue;">
                    </div>
                </div>
            </div>

        </form>
    </div>
</div>

<script>
    $(function () {
        $("#tel").val("");
        $("#password").val("");
        $("#password1").val("");
        $("#idcode-btn").val("");
        $("#second_name").val("");
        $("#email").val("");
        $("#area").val("");
        $("#sex").val("");
    });

    var password;
    var check = [false, false, false, false, true, true, true, true, true];

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

    // 发送短信验证
    $('#getting').click(function(){
        var flag = true;
        var tel = $("#tel").val();
        var myreg = /^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(17[0-9]{1}))+\d{8})$/;
        if(!myreg.test(tel)){
            toastr.error('请输入手机号码！');
            return false;
        }else{
            // 再次确认手机号是否被注册
            sendPost('${ctx}/checkTelRegistered',{'tel':tel},false,function (msg) {
                if (!msg.status){
                    flag = false;
                }
            },function (error) {
                toastr.error("系统错误");
                flag = false;
            });
            if(flag) {
                // 发送验证短信
                sendPost('${ctx}/smsVerification',{'tel':tel},false,function (msg) {
                    if (!msg.status){
                        flag = false;
                    }
                },function (error) {
                    toastr.error("系统错误");
                    flag = false;
                });
                if(flag) {
                    var btn = $('#getting');
                    var count = 60;
                    var resend = setInterval(function() {
                        count--;
                        if (count > 0){
                            btn.val(count+"秒后重新获取");
                            $.cookie("captcha", count, {path: '/', expires: (1/86400)*count});
                        }else {
                            clearInterval(resend);
                            btn.val("发送验证码").removeAttr('disabled style');
                        }
                    }, 1000);
                    btn.attr('disabled',true).css('cursor','not-allowed');
                }
            }
        }
    });

    //校验成功函数
    function success(Obj, counter) {
        Obj.parent().parent().removeClass('has-error').addClass('has-success');
        $('.tips').eq(counter).hide();
        $('.glyphicon-ok').eq(counter).show();
        $('.glyphicon-remove').eq(counter).hide();
        check[counter] = true;

    }

    // 校验失败函数
    function fail(Obj, counter, msg) {
        Obj.parent().parent().removeClass('has-success').addClass('has-error');
        $('.glyphicon-remove').eq(counter).show();
        $('.glyphicon-ok').eq(counter).hide();
        $('.tips').eq(counter).text(msg).show();
        check[counter] = false;
    }

    // 验证手机号码是否合法和是否被注册
    var regPhoneNum = /^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(17[0-9]{1}))+\d{8})$/;
    $('.container1').find('input').eq(0).change(function() {
        var flag1;
        var flag2 = true;
        flag1= regPhoneNum.test($(this).val());
        sendPost('${ctx}/checkTelRegistered',{'tel':$(this).val()},false,function (msg) {
            if (!msg.status){
                flag2 = false;
            }
        },function (error) {
            toastr.error("系统错误");
            flag2 = false;
        });

        if(flag1 && flag2) {
            success($(this), 0);
        } else {
            if(!flag1) {
                fail($(this), 0, '手机号码输入有误');
            } else if(flag1 && !flag2) {
                fail($(this), 0, '手机已经被注册');
            }
        }
    });

    $('.container1').find('input').eq(1).change(function() {
        password = $(this).val();
        if ($(this).val().length < 8) {
            fail($(this), 1, '密码太短，不能少于8个字符');
        } else {
            success($(this), 1);
        }
    });


    // 再次输入密码校验
    $('.container1').find('input').eq(2).change(function() {
        if ($(this).val() == password) {
            success($(this), 2);
        } else {
            fail($(this), 2, '两次输入的密码不一致');
        }
    });

    // 昵称匹配
    $('.container1').find('input').eq(3).change(function() {
        if ($(this).val().length>=2&&($(this).val().length<=10)) {
            success($(this), 3);
        } else{
            fail($(this), 3, '昵称长度在[2,10]之间');
        }
    });

    //邮箱匹配
    var regEmail = /^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$/;
    $('.container1').find('input').eq(5).change(function() {
        if($(this).val() != null || $(this).val() != "") {
            if (regEmail.test($(this).val())) {
                success($(this), 4);
            } else {
                fail($(this),4, '邮箱输入错误');
            }
        }
    });

    //性别匹配
    $('.container1').find('input').eq(7).change(function() {
        if(($(this).val() != null) || $(this).val() != "") {
            if ($(this).val() == "男" || $(this).val() == "女") {
                success($(this), 6);
            } else {
                fail($(this), 6, '格式错误！');
            }
        }
    });

    //提交按钮检查Input 内容
    $('#submit').click(function(e) {
        if (!check.every(function(value) {
                return value == true;
            })) {
            e.preventDefault();
            for (key in check) {
                if(key == 6 )
                    continue;
                if (!check[key]) {
                    $('.container1').find('input').eq(key).parent().parent().removeClass('has-success').addClass('has-error')
                }
            }
        }
    });

    function checkRegister() {
        var tel = $("#tel").val();
        var password = $("#password").val();
        var passwor1 = $("#password1").val();
        var verifyCode = $("#idcode-btn").val();

        var re = /^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(17[0-9]{1}))+\d{8})$/;
        var flag = true;
        if (!re.test(tel)) {
            toastr.error("手机号输入错误！");
            return false;
        }
        if (password == "" || password == null) {
            toastr.error("密码不能为空！");
            return false;
        }
        if (password != passwor1) {
            toastr.error("两次密码不一致！");
            return false;
        }
        if(verifyCode == ""||verifyCode == null){
            toastr.error("请输入验证密码！");
            return false;
        }

        // 后台验证手机号与验证码
        sendPost('${ctx}/registerCheck',{'tel':tel,'code':verifyCode},false,function (msg) {
            if (!msg.status){
                toastr.error(msg.info);
                flag = false;
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