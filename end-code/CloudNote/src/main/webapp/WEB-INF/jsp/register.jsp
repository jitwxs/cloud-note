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

        #loginDiv{
            margin-right: 100px;
            width: 250px;
            margin-left: 700px;
        }
        .navbar {
            background-color: #e9e6ea;
        }
        .navbar .navbar-brand {
            color: #010f13;
        }
        .navbar .navbar-brand:hover,
        .navbar .navbar-brand:focus {
            color: #080111;
        }
        .navbar .navbar-text {
            color: #010f13;
        }
        .navbar .navbar-nav .nav-link {
            color: #010f13;
            border-radius: .25rem;
            margin: 0 0.25em;
        }
        .navbar .navbar-nav .nav-link:not(.disabled):hover,
        .navbar .navbar-nav .nav-link:not(.disabled):focus {
            color: #080111;
        }
        .navbar .navbar-nav .nav-item.active .nav-link,
        .navbar .navbar-nav .nav-item.active .nav-link:hover,
        .navbar .navbar-nav .nav-item.active .nav-link:focus,
        .navbar .navbar-nav .nav-item.show .nav-link,
        .navbar .navbar-nav .nav-item.show .nav-link:hover,
        .navbar .navbar-nav .nav-item.show .nav-link:focus {
            color: #080111;
            background-color: #b5adb8;
        }
        .navbar .navbar-toggle {
            border-color: #b5adb8;
        }
        .navbar .navbar-toggle:hover,
        .navbar .navbar-toggle:focus {
            background-color: #b5adb8;
        }
        .navbar .navbar-toggle .navbar-toggler-icon {
            color: #010f13;
        }
        .navbar .navbar-collapse,
        .navbar .navbar-form {
            border-color: #010f13;
        }
        .navbar .navbar-link {
            color: #010f13;
        }
        .navbar .navbar-link:hover {
            color: #080111;
        }

        @media (max-width: 575px) {
            .navbar-expand-sm .navbar-nav .show .dropdown-menu .dropdown-item {
                color: #010f13;
            }
            .navbar-expand-sm .navbar-nav .show .dropdown-menu .dropdown-item:hover,
            .navbar-expand-sm .navbar-nav .show .dropdown-menu .dropdown-item:focus {
                color: #080111;
            }
            .navbar-expand-sm .navbar-nav .show .dropdown-menu .dropdown-item.active {
                color: #080111;
                background-color: #b5adb8;
            }
        }

        @media (max-width: 767px) {
            .navbar-expand-md .navbar-nav .show .dropdown-menu .dropdown-item {
                color: #010f13;
            }
            .navbar-expand-md .navbar-nav .show .dropdown-menu .dropdown-item:hover,
            .navbar-expand-md .navbar-nav .show .dropdown-menu .dropdown-item:focus {
                color: #080111;
            }
            .navbar-expand-md .navbar-nav .show .dropdown-menu .dropdown-item.active {
                color: #080111;
                background-color: #b5adb8;
            }
        }

        @media (max-width: 991px) {
            .navbar-expand-lg .navbar-nav .show .dropdown-menu .dropdown-item {
                color: #010f13;
            }
            .navbar-expand-lg .navbar-nav .show .dropdown-menu .dropdown-item:hover,
            .navbar-expand-lg .navbar-nav .show .dropdown-menu .dropdown-item:focus {
                color: #080111;
            }
            .navbar-expand-lg .navbar-nav .show .dropdown-menu .dropdown-item.active {
                color: #080111;
                background-color: #b5adb8;
            }
        }

        @media (max-width: 1199px) {
            .navbar-expand-xl .navbar-nav .show .dropdown-menu .dropdown-item {
                color: #010f13;
            }
            .navbar-expand-xl .navbar-nav .show .dropdown-menu .dropdown-item:hover,
            .navbar-expand-xl .navbar-nav .show .dropdown-menu .dropdown-item:focus {
                color: #080111;
            }
            .navbar-expand-xl .navbar-nav .show .dropdown-menu .dropdown-item.active {
                color: #080111;
                background-color: #b5adb8;
            }
        }

        .navbar-expand .navbar-nav .show .dropdown-menu .dropdown-item {
            color: #010f13;
        }
        .navbar-expand .navbar-nav .show .dropdown-menu .dropdown-item:hover,
        .navbar-expand .navbar-nav .show .dropdown-menu .dropdown-item:focus {
            color: #080111;
        }
        .navbar-expand .navbar-nav .show .dropdown-menu .dropdown-item.active {
            color: #080111;
            background-color: #b5adb8;
        }
    </style>
</head>

<body>
<nav class="navbar navbar-default navbar-fixed-top" style="height: 50px;">

    <div class="container-fluid">
        <!--无道云的图标-->
        <div class="navbar-header">
            <a class="navbar-brand" href="#">
                <img alt="Brand" src="...">
            </a>
        </div>

        <!--搜索-->
        <div>
            <form class="navbar-form navbar-left" role="search">
                <div class="form-group">
                    <input type="text" class="form-control" style="border:none; background:none;outline:none;" placeholder="Search" />
                </div>
                <button type="submit" class="btn btn-default">查找</button>
            </form>
        </div>
        <div style="float: right;">
            <a href="#">
                已有账号？去<input type="button" class="btn btn-info" value="登陆">
            </a>
        </div>
    </div>

    <div  class="container" style="width:60%; height:auto;text-align:center">
        <div class="col-md-6 col-md-offset-3">
            <h3>欢迎使用无道云笔记</h3>
            <form action="" method="" onsubmit="return registerPost()">

                <div class="form-group has-feedback">
                    <div class="input-group">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-user"></span></span>
                        <input id="tel" class="form-control" name="tel" placeholder="请输入手机号" maxlength="20" type="text" required="required">
                    </div>
                    <span style="color:red;display: none;" class="tips"></span>
                    <span style="display: none;" class=" glyphicon glyphicon-remove form-control-feedback"></span>
                    <span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
                </div>
                <div class="form-group has-feedback">
                    <div class="input-group">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-lock"></span></span>
                        <input id="password" name="password" class="form-control" placeholder="请输入密码" maxlength="20" type="password">
                    </div>

                    <span style="color:red;display: none;" class="tips"></span>
                    <span style="display: none;" class="glyphicon glyphicon-remove form-control-feedback"></span>
                    <span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
                </div>

                <div class="form-group has-feedback">
                    <div class="input-group">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-lock"></span></span>
                        <input id="password1" class="form-control" placeholder="请再次输入密码" maxlength="20" type="password">
                    </div>
                    <span style="color:red;display: none;" class="tips"></span>
                    <span style="display: none;" class="glyphicon glyphicon-remove form-control-feedback"></span>
                    <span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
                </div>
                <div class="row">
                    <div class="col-xs-7">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <span class="input-group-addon"><span class="glyphicon glyphicon-qrcode"></span></span>
                                <input id="idcode-btn" class="form-control" placeholder="请输入校验码" maxlength="6" type="text">
                            </div>
                            <span style="color:red;display: none;" class="tips"></span>
                            <span style="display: none;" class="glyphicon glyphicon-remove form-control-feedback"></span>
                            <span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
                        </div>
                    </div>
                    <div class="col-xs-5 text-center">
                        <button type="button" id="loadingButton" class="btn btn-primary" autocomplete="off">获取短信校验码</button>
                    </div>
                </div>
                <div class="form-group">
                    <input class="form-control btn btn-primary" id="submit" value="立&nbsp;&nbsp;即&nbsp;&nbsp;注&nbsp;&nbsp;册" type="submit">
                </div>

            </form>
        </div>
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