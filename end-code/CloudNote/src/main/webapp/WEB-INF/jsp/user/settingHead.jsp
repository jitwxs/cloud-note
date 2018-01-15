<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<head>
    <title>无道云笔记</title>
    <%-- Required meta tags always come first --%>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <%-- Bootstrap CSS --%>
    <link rel="stylesheet" href="${ctx}/css/bootstrap.css">
    <%-- 弹窗CSS --%>
    <link rel="stylesheet" href="${ctx}/css/toastr.css">
    <%--&lt;%&ndash; 自定义CSS &ndash;%&gt;--%>
    <%--<link rel="stylesheet" href="${ctx}/css/custom.css">--%>
    <link rel="stylesheet" href="${ctx}/css/account_setting.css">
    <%-- jQuery first, then Bootstrap JS. --%>
    <script src="${ctx}/js/jquery-3.2.1.min.js"></script>
    <script src="${ctx}/js/bootstrap.js"></script>
    <script src="${ctx}/js/jquery.contextify.js"></script>
    <%-- 弹窗依赖 --%>
    <script src="${ctx}/js/toastr.js"></script>
    <%-- 封装ajax --%>
    <script src="${ctx}/js/http.js"></script>
</head>

<nav class="navbar navbar-default navbar-fixed-top">
    <div class="container-fluid">
        <div class="navbar-header" style="margin-top: 10px;height: 40px;position: relative">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                    data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a href="javascript:void(0)" class="navbar-brand"
               style="font-family:'Open Sans', Arial, sans-serif;font-size: 20px;color: black;">
                无道云笔记</a>
            <img src="${ctx}/images/favicon.png" style="width: 50px;height: 40px;" alt="无道云笔记">
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1" >
            <ul class="nav navbar-nav navbar-right">
                <li role="presentation">
                    <img id="userSmallIcon" class="img-responsive img-rounded" style="width: 50px;height: 50px" src="" >
                </li>
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                        <div id="showName"><label id="userSmallName"></label><span class="caret"></span></div>
                    </a>
                    <ul class="dropdown-menu">
                        <li ><a href="${ctx}/user/index">返回笔记</a></li>
                        <li class="divider"></li>
                        <li ><a href="${ctx}/logout">退出</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div style="width: 100%;">
    <div class="row">
        <div>
            <ul class="nav nav-tabs" style="margin-top: 60px;float: right;width: 100%">
                <li ><a href="${ctx}/user/index" style="margin-left: 630px;">返回笔记</a></li>
                <li><a href="${ctx}/user/accountInfo">账号信息</a></li>
                <li><a href="${ctx}/user/accountShare">我的分享</a></li>
                <li><a href="${ctx}/user/disk">我的网盘</a></li>
                <li><a href="${ctx}/user/resetPassword">更改密码</a></li>
            </ul>
        </div>
    </div>
</div>

<script>
    $(function() {
        // 初始化头部小头像和下拉框名
        sendGet('${ctx}/showSelfInfo',{},true,function (res) {
            $("#userSmallName").html(res.userDto.name);
            $("#userSmallIcon").attr('src',"${ctx}/upload/"+ res.userDto.tel + "/images/" + res.userDto.icon);
        },function (error) {
            toastr.error("系统错误");
            return false;
        });
    });
</script>