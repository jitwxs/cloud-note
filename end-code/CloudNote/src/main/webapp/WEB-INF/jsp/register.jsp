<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <title></title>
    <!-- Required meta tags always come first -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${ctx}/css/bootstrap.css">
    <link rel="stylesheet" href="${ctx}/css/toastr.css">
    <!-- jQuery first, then Bootstrap JS. -->
    <script src="${ctx}/js/jquery-3.2.1.min.js"></script>
    <script src="${ctx}/js/bootstrap.js"></script>
    <script src="${ctx}/js/toastr.js"></script>
    <script src="${ctx}/js/jquery.cookie.js"></script>
</head>

<body>
    <a href="${ctx}/login">已有账号？去<input type="button" class="btn btn-info" value="登陆"></a>

    <div  class="container" style="width:60%; height:auto;text-align:center">
        <div class="col-md-6 col-md-offset-3">
            <h3>欢迎使用无道云笔记</h3>
            <form action="${ctx}/register" method="post" onsubmit="return registerPost()">
                <div class="form-group has-feedback">
                    <div class="input-group">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-user"></span></span>
                        <input id="tel" class="form-control" name="tel" placeholder="请输入手机号" maxlength="20" type="text" required="required">
                    </div>
                    <span style="color:red;display: none;" class="tips"></span>
                    <span style="display: none;" class=" glyphicon glyphicon-remove form-control-feedback"></span>
                    <span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
                </div>
                <div class="row">
                    <div class="col-xs-7">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <span class="input-group-addon"><span class="glyphicon glyphicon-qrcode"></span></span>
                                <input id="codeBtn" class="form-control" placeholder="请输入校验码" maxlength="6" type="text">
                            </div>
                            <span style="color:red;display: none;" class="tips"></span>
                            <span style="display: none;" class="glyphicon glyphicon-remove form-control-feedback"></span>
                            <span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
                        </div>
                    </div>
                    <div class="col-xs-5 text-center">
                        <input type="button" class="btn send  btn btn-primary" id="getting" onclick="sms_verification()" value="发送验证码" style="margin-bottom: 15px;width: 100%;" >
                    </div>
                </div>
                <div class="form-group has-feedback">
                    <div class="input-group">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-lock"></span></span>
                        <input id="password" name="password" class="form-control" placeholder="请输入密码" maxlength="20" type="password" required="required">
                    </div>
                    <span style="color:red;display: none;" class="tips"></span>
                    <span style="display: none;" class="glyphicon glyphicon-remove form-control-feedback"></span>
                    <span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
                </div>
                <div class="form-group has-feedback">
                    <div class="input-group">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-lock"></span></span>
                        <input id="password1" class="form-control" placeholder="请再次输入密码" maxlength="20" type="password" required="required">
                    </div>
                    <span style="color:red;display: none;" class="tips"></span>
                    <span style="display: none;" class="glyphicon glyphicon-remove form-control-feedback"></span>
                    <span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
                </div>
                <div class="form-group has-feedback">
                    <div class="input-group">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-user"></span></span>
                        <input id="second_name" class="form-control" name="name" placeholder="请输入昵称（可选）" maxlength="20" type="text">
                    </div>
                    <span style="color:red;display: none;" class="tips"></span>
                    <span style="display: none;" class=" glyphicon glyphicon-remove form-control-feedback"></span>
                    <span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
                </div>
                <div class="form-group has-feedback">
                    <div class="input-group">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-user"></span></span>
                        <input id="email" class="form-control " name="email" placeholder="请输入邮箱（可选）" maxlength="20" type="email">
                    </div>
                    <span style="color:red;display: none;" class="tips"></span>
                    <span style="display: none;" class=" glyphicon glyphicon-remove form-control-feedback"></span>
                    <span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
                </div>
                <div class="form-group has-feedback">
                    <div class="input-group">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-user"></span></span>
                        <input id="area" class="form-control" name="area" placeholder="请选择所在城市（可选）" maxlength="20" type="text">
                    </div>
                    <span style="color:red;display: none;" class="tips"></span>
                    <span style="display: none;" class=" glyphicon glyphicon-remove form-control-feedback"></span>
                    <span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
                </div>
                <div class="form-group has-feedback">
                    <div class="input-group">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-user"></span></span>
                        <input id="sex" class="form-control" name="sex" placeholder="请输入性别（可选）" maxlength="20" type="text">
                    </div>
                    <span style="color:red;display: none;" class="tips"></span>
                    <span style="display: none;" class=" glyphicon glyphicon-remove form-control-feedback"></span>
                    <span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
                </div>
                <div class="form-group">
                    <input class="form-control btn btn-primary" id="submit" value="立&nbsp;&nbsp;即&nbsp;&nbsp;注&nbsp;&nbsp;册" type="submit">
                </div>
            </form>
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

    /*点击改变按钮状态，已经简略掉ajax发送短信验证的代码*/
    $('#getting').click(function(){
        var phonenum = $("#tel").val();
        var myreg = /^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(17[0-9]{1}))+\d{8})$/;
        if(!myreg.test(phonenum)){
            toastr.error('请输入手机号码！');
            return false;
        }else{
            var btn = $('#getting');
            var count = 60;
            var resend = setInterval(function(){
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
    });

    function registerPost() {
        var password = $("#password").val();
        var password1 = $("#password1").val();
        var tel = $("#tel").val();
        var code = $("#codeBtn").val();

        var re = /^1\d{10}$/;
        var flag = true;
        if (!re.test(tel)) {
            toastr.warning("手机号不符合规范");
            return false;
        }

        if (password != password1) {
            toastr.error("手机号不符合规范");
            return false;
        }

        $.ajax({
            type: 'post',
            url: '/registerCheck',
            dataType: 'json',
            data: {
                'tel': tel,
                'code': code
            },
            async : false,
            success: function (msg) {
                if (!msg.status) {
                    toastr.warning(msg.info);
                    flag = false;
                } else {
                    toastr.success("注册成功");
                }
            },
            error: function () {
                toastr.error("系统错误");
                flag = false;
            }
        });
        return flag;
    }
    
    function sms_verification() {
        var re = /^1\d{10}$/;
        var tel = $("#tel").val();
        if (!re.test(tel)) {
            toastr.warning("手机号不符合规范");
            return false;
        }
        $.ajax({
            type: 'post',
            url: '${ctx}/smsVerification',
            dataType: 'json',
            data: {
                'tel': tel
            },
            async : false,
            success: function (msg) {
                if (msg.status) {
                    toastr.success("发送成功");
                } else {
                    toastr.info("发送失败");
                }
            },
            error: function () {
                toastr.error("系统错误");
            }
        });
    }
</script>
</body>

</html>