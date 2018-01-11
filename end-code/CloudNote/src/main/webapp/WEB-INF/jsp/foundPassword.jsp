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
            width:400px;
            height:390px;
            box-shadow:0 0 5px #46B4E6;
            margin:0 auto;
            margin-top: 100px;
            position: relative;
        }
        header{
            width: 400px;
            height:45px;
            background: #46b4e6;
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

<div id="main">
    <header >
        <p style="font-size: 20px;line-height: 45px;text-align: center;color: white;">找回密码</p>
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

<jsp:include page="${ctx}/WEB-INF/jsp/global/footer.jsp"/>
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
</script>
</body>
</html>