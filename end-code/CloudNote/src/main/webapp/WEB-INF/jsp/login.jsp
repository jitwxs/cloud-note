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
    <style type="text/css">
        * {
            margin: 0;
            padding: 0;
        }
        #main {
            width: 860px;
            height: 410px;
            border: solid black 1px;
        }
    </style>
</head>

<body>
<div id="main">
    <form method="post" action="${ctx}/login" onsubmit="return httpPost()">
        <table>
            <tr>
                <td>手机号:</td>
                <td><input type="text" id="tel" name="tel" maxlength="11"></td>
            </tr>
            <tr>
                <td>密码:</td>
                <td><input type="password" id="password" name="password"></td>
            </tr>
            <tr>
                <td><input type="submit" value="登录" class="button"></td>
            </tr>
        </table>
    </form>
</div>
<script>
    function httpPost() {
        var tel = $("#tel").val();
        var password = $('#password').val();
        var re = /^1\d{10}$/;

        var flag = true;
        if (!re.test(tel)) {
            alert("手机号输入不正确");
            return false;
        }
        if (password == "" || password == null) {
            alert("密码不能为空");
            return false;
        }
        $.ajax({
            type: 'post',
            url: '${ctx}/loginCheck',
            dataType: 'json',
            data: {
                'tel': tel,
                'password': password
            },
            async : false,
            success: function (msg) {
                if (!msg.res) {
                    alert("账户未注册或密码错误");
                    flag = false;
                }
            },
            error: function () {
                alert("登录失败！");
                flag = false;
            }
        });
        return flag;
    }
</script>
</body>

</html>