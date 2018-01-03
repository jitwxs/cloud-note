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
            width:880px;
            height:410px;
            background: white;
            border:solid black 1px;
            margin:0 auto;
            margin-top: 100px;
            position: relative;
        }
        #main .left{
            margin-left: 5px;
            border:1px solid red;
            float: left;
        }
        #main .right{
            margin-right:5px ;
            border:1px solid red;
            float: right;
        }
        a{
            color: lightskyblue;
        }
        a:hover{
            color:darkblue;
        }
    </style>
</head>

<body>
<div id="main" >
    <div class="left" style="width: 420px;height: 410px;">
        <p style="font-size: 18px;text-align: center;margin-top: 20px">手机号登录</p>
        <form method="post" action="${ctx}/login" onsubmit="return httpPost()">
            <div class="form-group" style="width: 250px;height: 50px;margin: 0 auto;margin-top: 20px">
                <input  id="tel" class="form-control" type="text" name="tel" maxlength="11"  placeholder="手机号" >
            </div>
            <div class="form-group" style="width: 250px;height: 50px;margin: 0 auto;margin-top: 20px">
                <input id="password" class="form-control" type="password" name="password" placeholder="密码">
            </div>
            <div style="width: 250px;height: 50px;margin: 0 auto;margin-top: 20px" >
                <button type="submit"  class="btn btn-default">登录</button>
            </div>
        </form>
    </div>
    <div class="right" style="width: 420px;height: 410px;">
        <p style="font-size: 18px;text-align: center;margin-top: 20px">其他账号登录</p>
        <button style="border-radius: 5px; width: 70%;height: 50px;margin-left:50px;margin-top: 20px;background: lightskyblue" onclick="loginQQ()">使用qq登录</button>
        <button style="border-radius: 5px; width: 70%;height: 50px;margin-left:50px;margin-top: 20px;background: lightskyblue" onclick="loginWchat()">使用微信登录</button>
        <button style="border-radius: 5px; width: 70%;height: 50px;margin-left:50px;margin-top: 20px;background: lightskyblue" onclick="loginSina()">使用微博登录</button>
    </div>
</div>
<script>
    function httpPost() {
        var flag = true;
        var tel = $("#tel").val();
        var password = $("#password").val();
        var re=/^1\d{10}$/;
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
            url: '/loginCheck',
            async :false,
            dataType:'json',
            data: {
                'tel': tel,
                'password': password
            },
            success: function (msg) {
                if (!msg.res){
                    alert("手机号不存在或密码错误");
                    flag = false;
                } else {
                    flag = true;
                }
            },
            error: function () {
                alert("登录失败！");
                flag = false;
            }
        });
        return flag;
    }
    //qq登录
    function loginQQ() {

    }
    //微信登录
    function loginWchat(){

    }
    //新浪微博登录
    function loginSina(){

    }
</script>
</body>

</html>