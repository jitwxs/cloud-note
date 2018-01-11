<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>无道云笔记</title>
    <%-- Required meta tags always come first --%>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <%-- Bootstrap CSS --%>
    <link rel="stylesheet" href="${ctx}/css/bootstrap.css">
    <link rel="stylesheet" href="${ctx}/css/wangEditor-fullscreen-plugin.css">
    <%-- 弹窗CSS --%>
    <link rel="stylesheet" href="${ctx}/css/toastr.css">
    <%-- 自定义CSS --%>
    <link rel="stylesheet" href="${ctx}/css/custom.css">
    <%-- jQuery first, then Bootstrap JS. --%>
    <script src="${ctx}/js/jquery-3.2.1.min.js"></script>
    <script src="${ctx}/js/bootstrap.js"></script>
    <%-- 弹窗依赖 --%>
    <script src="${ctx}/js/toastr.js"></script>
    <%-- 封装ajax --%>
    <script src="${ctx}/js/http.js"></script>
    <style>
        @media  screen and (min-width: 200px) {
            .box1 {
                /*border:1px solid red;*/
                height: 120px;
                width: 600px;
            }

        }
        .box1{
            margin-top: 150px;
            margin-left:300px;
            margin-right: 500px;
            /*font-family: "微软雅黑 Light";*/
        }
        #btn{
            color: white;
            background: lightskyblue;
            font-size: 18px;
            float: left;
            margin-top: 30px;
            margin-left: 300px;
        }

    </style>
</head>
<body>

<jsp:include page="head.jsp"/>

<div class="container">
    <div class="row">
        <div>
            <ul class="nav nav-tabs" style="margin-top: 60px;float: right ">
                <li style="margin-left: 450px;"><a href="#">账号信息</a></li>
                <li><a href="accountsafe.html">账号安全</a></li>
                <li><a href="#">上传文件</a></li>
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        下载文件 <span class="caret"></span>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a href="#">本地下载</a></li>
                        <li><a href="#">高速下载</a></li>
                        <li class="divider"></li>
                        <li><a href="#">链接</a></li>
                    </ul>
                </li>
                <li><a href="#">更改密码</a></li>
            </ul>
        </div>

        <div class="box1" >
            <h4 style="margin-left: 40px"> 更改密码</h4>
            <hr>
            <form method="post" action="${ctx}/user/resetPassword" onsubmit="return httpPost()">
                <div class="form-group" style="width: 250px;height: 50px;margin: 0 auto;margin-top: 20px">
                    请输入原始密码:<input  id="oldPassword" class="form-control" type="text" name="tel" maxlength="11"  placeholder="" required="required">
                </div>
                <div class="form-group" style="width: 250px;height: 50px;margin: 0 auto;margin-top: 20px">
                    设置新的密码:<input id="newPassword" class="form-control" type="password" name="newPassword" placeholder="" required="required">
                </div>
                <div class="form-group" style="width: 250px;height: 50px;margin: 0 auto;margin-top: 20px">
                    重复新的密码:<input id="newPassword2" class="form-control" type="password" name="newPassword2" placeholder="" required="required">
                </div>
                <button id="btn" type="submit"  class="btn btn-default" >确定</button>
            </form>
        </div>
    </div>
</div>

<%-- 引入页脚 --%>
<jsp:include page="${ctx}/WEB-INF/jsp/global/footer.jsp"/>
<script>
    // 页面加载函数
    $(function(){
        // 得到当前用户手机号码
        var userTel = $.trim($("#showId").text());
    });

    function httpPost() {
        var oldPassword = $("#oldPassword").val();
        var newPassword = $("#newPassword").val();
        var newPassword2 = $("#newPassword2").val();

        if (newPassword != newPassword2) {
            toastr.error("两次密码不一致");
            return false;
        }

        sendPost('${ctx}/user/verifyPassword',{'password':oldPassword},false,function (msg) {
            if (!msg.status){toastr.warning("原始密码不正确");return false}
            else return true;
        },function (error) {
            toastr.error("系统错误");
            return false;
        });
    }
</script>
</body>
</html>