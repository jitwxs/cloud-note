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
    <link rel="stylesheet" href="${ctx}/css/simple-alert.css">
    <link rel="stylesheet" href="${ctx}/css/account_setting.css">
    <%-- 进度条CSS --%>
    <link rel="stylesheet" href="${ctx}/css/font-awesome.css">
    <%-- jQuery first, then Bootstrap JS. --%>
    <script src="${ctx}/js/jquery-3.2.1.min.js"></script>
    <script src="${ctx}/js/bootstrap.js"></script>
    <script src="${ctx}/js/jquery.contextify.js"></script>
    <%-- 弹窗依赖 --%>
    <script src="${ctx}/js/toastr.js"></script>
    <script src="${ctx}/js/simple-alert.js"></script>
    <%-- 封装ajax --%>
    <script src="${ctx}/js/http.js"></script>
    <%--引入cookie--%>
    <script src="${ctx}/js/jquery.cookie.js"></script>
</head>

<div style="width: 100%;">
    <div class="row" style="background: #7c6aa6;">
        <div >
            <ul class="nav nav-tabs" style="margin-top: 30px;width: 100%;">
                <li style="margin-left:15%;" ><a style="color: black;" href="${ctx}/user/index">返回笔记</a></li>
                <li style="margin-left: 5%;"><a style="color: black;" href="${ctx}/user/accountInfo">账号信息</a></li>
                <li style="margin-left: 5%;"><a style="color: black;" href="${ctx}/user/accountShare">我的分享</a></li>
                <li style="margin-left: 5%;"><a style="color: black;" href="${ctx}/user/disk">我的网盘</a></li>
                <li style="margin-left: 5%;"><a style="color: black;" href="${ctx}/user/notify">站内信</a></li>
            </ul>
        </div>
    </div>
</div>

<script>
    $(function() {
        // 初始化头部小头像和下拉框名
        sendGet('${ctx}/showSelfInfo',{},true,function (res) {
            $("#userSmallName").html(res.userDto.name);
            $("#userSmallIcon").attr('src', res.userDto.icon);
        },function (error) {
            toastr.error("系统错误");
            return false;
        });
    });
</script>