<<<<<<< HEAD
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>CloudNote</title>
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
            width:100px;
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
        <input id="phonenum" type="text" class="form-control name"
               placeholder="请输入手机号获取验证码">
        <input type="button" class="btn send" style="margin-bottom: 15px" id="second" value="发送验证码">

        <input id="yanzhengma" name="code" style="margin-top: 35px" type="text" class="form-control name"
               placeholder="请输入验证码">
        <a class="btn send" onclick="changePassword()">确定</a>
    </div>

    <div class="changePasswd" >
        <p style="margin-top: 20px;">您正在通过手机验证找回密码，</p>
        <p style="margin-top: 10px">请输入新密码并重复确认，以完成密码重置操作</p>
        <hr>
        <p class="changePassword" >新密码：</p>
        <input id="newPassword" style="margin-top: 5px" type="password" class="form-control mima"
               placeholder="请输入新密码">
        <p class="changePassword" style="margin-top: 60px">确认密码：</p>
        <input id="checkPassword" style="margin-top: 5px" type="password" class="form-control r_mima"
               placeholder="确认新密码">
        <a class="btn" id="reset" onclick="reset()">重置密码</a>
    </div>
</div>

<jsp:include page="${ctx}/WEB-INF/jsp/global/footer.jsp"/>
<script>
    function reset(){
        var newPassword= $('#newPassword').val();
        var checkPassword = $('#checkPassword').val();
        if (newPassword != checkPassword){
            toastr.warning("两次密码不一致！");
        }
        $.ajax({
            type:'post',
            url: '${ctx}/resetPassword',
            async:false,
            dataType:'json',
            data:{
                'id':'tel',
                'newPassword':newPassword
            },
            success:function (msg) {
                if(msg.status) {
                    toastr.success("修改成功!");
                } else {
                    toastr.warning("修改失败!");
                }
            },
            error:function () {
                toastr.error("内部错误");
            }
        });
    }
</script>
</body>

=======
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>CloudNote</title>
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
            width:100px;
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
        <input id="phonenum" type="text" class="form-control name"
               placeholder="请输入手机号获取验证码">
        <input type="button" class="btn send" style="margin-bottom: 15px" id="second" value="发送验证码">

        <input id="yanzhengma" name="code" style="margin-top: 35px" type="text" class="form-control name"
               placeholder="请输入验证码">
        <a class="btn send" onclick="changePassword()">确定</a>
    </div>

    <div class="changePasswd" >
        <p style="margin-top: 20px;">您正在通过手机验证找回密码，</p>
        <p style="margin-top: 10px">请输入新密码并重复确认，以完成密码重置操作</p>
        <hr>
        <p class="changePassword" >新密码：</p>
        <input id="newPassword" style="margin-top: 5px" type="password" class="form-control mima"
               placeholder="请输入新密码">
        <p class="changePassword" style="margin-top: 60px">确认密码：</p>
        <input id="checkPassword" style="margin-top: 5px" type="password" class="form-control r_mima"
               placeholder="确认新密码">
        <a class="btn" id="reset" onclick="reset()">重置密码</a>
    </div>
</div>

<jsp:include page="${ctx}/WEB-INF/jsp/global/footer.jsp"/>
<script>
    function reset(){
        var newPassword= $('#newPassword').val();
        var checkPassword = $('#checkPassword').val();
        if (newPassword != checkPassword){
            toastr.warning("两次密码不一致！");
        }
        $.ajax({
            type:'post',
            url: '${ctx}/resetPassword',
            async:false,
            dataType:'json',
            data:{
                'id':'tel',
                'newPassword':newPassword
            },
            success:function (msg) {
                if(msg.status) {
                    toastr.success("修改成功!");
                } else {
                    toastr.warning("修改失败!");
                }
            },
            error:function () {
                toastr.error("内部错误");
            }
        });
    }
</script>
</body>

>>>>>>> origin/master
</html>