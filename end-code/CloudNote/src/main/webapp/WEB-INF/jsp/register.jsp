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
    <link rel="stylesheet" href="${ctx}/css/message.css">
    <!-- jQuery first, then Bootstrap JS. -->
    <script src="${ctx}/js/jquery-3.2.1.min.js"></script>
    <script src="${ctx}/js/bootstrap.js"></script>
    <script src="${ctx}/js/message.js"></script>
    <style>
        #loginDiv {
            margin-right: 100px;
            width: 250px;
            margin-left: 700px;
        }
    </style>
</head>

<body>
    <div id="loginDiv">
        已有账号？去<a class="btn btn-default"href="${ctx}/login" style="margin-right: 50px;color: red">登陆</a>
    </div>
    <div style="width:100%; height:auto;text-align:center">
        <h3>欢迎使用无道云笔记</h3>
        <form action="${ctx}/register" method="post" onsubmit="return registerPost()">
            手机号: <input type="tel" id="tel" name="tel" style="margin-left: 20px;"/><br/>
            密 码：<input type="password" id="password" name="password" style="margin-left: 24px;"/><br/>
            确认密码<input type="password" id="password1" style="margin-left: 12px;"/><br/>
            验证码:<input type="text" style="margin-left: 15px; width:60px;"> <input type="button" value="获取手机验证码"> <br/>
            <input type="submit" value="注册" id="register"
                   style="width:180px;background-color: firebrick;margin-left: 70px;height: 30px;"/>
        </form>
    </div>
<script>
    function registerPost() {
        var password = $("#password").val();
        var password1 = $("#password1").val();
        var tel = $("#tel").val();

        var re = /^1\d{10}$/;
        var flag = true;
        alert(password);
        alert(password1);
        if (!re.test(tel)) {
            alert("手机号不符合规范");
            return false;
        }
        if (password == "" || password == null) {
            alert("密码不能为空");
            return false;
        }
        if (password != password1) {
            alert("两次密码不一致！");
            return false;
        }

        $.ajax({
            type: 'post',
            url: '/registerCheck',
            dataType: 'json',
            data: {
                'tel': tel
            },
            async : false,
            success: function (msg) {
                if (!msg.res) {
                    alert("手机号码已经被注册");
                    flag = false;
                }
            },
            error: function () {
                alert("注册失败！");
                flag = false;
            }
        });
        return flag;
    }
</script>
</body>

</html>