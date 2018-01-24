<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<%-- 引入头部 --%>
<jsp:include page="settingHead.jsp"/>

<body>
<div class="container">
    <div class="box1" >
        <h4> 账号信息</h4>
        <hr>
        <ol >账号：<label id="accountTel"/></ol>
        <ol >绑定邮箱：<label id="emailAddr"/></ol>
        <ol >注册日期：<label id="registerDate"/></ol>

        <br>
        <h4 id="choose_options"> 更改密码</h4>
        <hr>
        <form id="change_password" method="post" action="${ctx}/user/resetPassword" onsubmit="return httpPost()" >
            <div class="form-group" style="width: 300px;height: 50px;">
                <label for="oldPassword">请输入原始密码</label>
                <input type="password" class="form-control" id="oldPassword" maxlength="11" required>
            </div>
            <div class="form-group" style="width: 300px;height: 50px;">
                <label for="newPassword">设置新的密码</label>
                <input type="password" class="form-control" id="newPassword" name="newPassword" required>
            </div>
            <div class="form-group" style="width: 300px;height: 50px;">
                <label for="newPassword2">重复新的密码</label>
                <input type="password" class="form-control" id="newPassword2" required>
            </div>
            <button type="submit" class="btn btn-default" style="color: white;background: lightskyblue;font-size: 18px;float: left;margin-top: 20px;">确定</button>
        </form>
        <div id="input_phoneNumber" class="hidden" >
            <div class="form-group" style="width: 300px;height: 50px;">
                <label for="oldPassword">请输入手机号获取验证码</label>
                <input type="text" class="form-control" id="tel_number" maxlength="11" required>
                <input type="button" class="btn send" style="margin-bottom: 15px;cursor: pointer;background: lightskyblue;color: white;margin-top: 20px" id="getting" value="发送验证码" onclick="ses_verification()">
                <div class="form-group" style="width: 300px;height: 50px;">
                    <label for="newPassword">输入验证码</label>
                    <input type="password" class="form-control" id="code" name="newPassword" required>
                </div>
                <button type="submit" class="btn btn-default" style="color: white;background: lightskyblue;font-size: 18px;float: left;margin-top: 20px;" onclick="checkCode()" >确定</button>
            </div>
        </div>
    </div>
</div>

<script>
    $(function() {
        sendGet('${ctx}/showSelfInfo',{},true,function (res) {
            $("#accountTel").html(res.userDto.tel);
            $("#emailAddr").html(res.userDto.email);
            $("#registerDate").html(res.userDto.createDate);

            var str = $('#accountTel').text();
            //如果是第三方登陆
            if(str.match(/\D/)!=null){
                $('#change_password').hide();
                $('#input_phoneNumber').removeClass('hidden');
                $('#choose_options').text("绑定手机号");
            }
        },function (error) {
            toastr.error("系统错误");
            return false;
        });
    });

    function httpPost() {
        var oldPassword = $("#oldPassword").val();
        var newPassword = $("#newPassword").val();
        var newPassword2 = $("#newPassword2").val();
        var flag = true;

        if (newPassword != newPassword2) {
            toastr.warning("两次密码不一致");
            return false;
        }
        sendPost('${ctx}/user/verifyPassword', {'password': oldPassword}, false, function (msg) {
            if (!msg.status) {
                toastr.warning("原始密码不正确");
                flag = false;
            } else {
                toastr.success("验证成功");
            }
        }, function (error) {
            toastr.error("系统错误");
            flag = false;
        });
        return flag;
    }

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

    //检查手机号
    function ses_verification() {
        var flag = true;
        var tel = $("#tel_number").val();
        console.log(tel);
        var re = /^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(17[0-9]{1}))+\d{8})$/;
        if (!re.test(tel)) {
            toastr.warning("手机号不符合规范");
            return false;
        }else{
            sendPost('${ctx}/checkTelRegistered',{'tel':tel},false,function(msg) {
                if (msg.status) {
                    toastr.success("该手机号未被注册");
                } else {
                    toastr.warning("该手机号注册");
                    flag = false;
                }
            },function (error) {
                toastr.error("系统错误");
                flag = false;
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

    //检查验证码
    function checkCode(){
        var tel = $('#tel_number').val();
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
</script>

</body>

</html>