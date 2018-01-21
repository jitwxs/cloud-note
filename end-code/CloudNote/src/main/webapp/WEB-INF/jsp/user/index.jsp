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
    <link rel="stylesheet" href="${ctx}/css/bootstrap-theme.css">
    <link rel="stylesheet" href="${ctx}/css/wangEditor-fullscreen-plugin.css">
    <%-- 弹窗CSS --%>
    <link rel="stylesheet" href="${ctx}/css/toastr.css">
    <%-- home页CSS --%>
    <link rel="stylesheet" href="${ctx}/css/home_css.css">
    <%-- jQuery first, then Bootstrap JS. --%>
    <script src="${ctx}/js/jquery-3.2.1.min.js"></script>
    <script src="${ctx}/js/bootstrap.js"></script>
    <%-- jQuery百叶窗 --%>
    <script src="${ctx}/js/jquery.contextify.js"></script>
    <%-- wangEditor依赖 --%>
    <script src="${ctx}/js/wangEditor.js"></script>
    <script src="${ctx}/js/wangEditor-fullscreen-plugin.js"></script>
    <%-- 弹窗依赖 --%>
    <script src="${ctx}/js/toastr.js"></script>
    <%-- 封装ajax --%>
    <script src="${ctx}/js/http.js"></script>
    <%-- home页JS --%>
    <script src="${ctx}/js/home_js.js"></script>
</head>

<body style="margin-top: 60px;position: absolute;width: 100%;height: auto;" id="home_body">
<div id="loading">
    <img src="${ctx}/images/loding.gif" class="img-responsive">
</div>
<%-- 引入模块框 --%>
<jsp:include page="../showSelfInfoModel.jsp"/>
<jsp:include page="shareNoteModel.jsp"/>
<jsp:include page="uploadNote.jsp"/>
<jsp:include page="noteMoveToModel.jsp"/>

<input type="hidden" id="lastLoginTime" value="${lastLoginTime}">

<%-- 头部 --%>
<jsp:include page="indexHead.jsp"/>

<%-- 分享区域 --%>
<jsp:include page="share.jsp"/>

<%--主体--%>
<div  class="container" style="padding-right: 0px; width:98%;height: auto;" id="left">
    <div class="row">
        <div id="wangeditor" class="col-md-10">
            <%-- 目录区域 --%>
            <jsp:include page="directory.jsp"/>
            <%-- 编辑器区域 --%>
            <jsp:include page="articleEditor.jsp"/>
        </div>

        <%-- 广告位 --%>
        <div class="col-md-2 visible-lg" id="advertisment" style="height: 700px;z-index:999">
            <img src="${ctx}/images/advertiment.png" style="width:100%;height: 100%"/>
        </div>
    </div>
</div>

<script>
$(function() {
        // 初始化头部小头像和下拉框名
        sendGet('${ctx}/showSelfInfo',{},true,function (res) {
            var userTel = res.userDto.tel;
            $("#userSmallName").html(res.userDto.name);
            $("#userSmallIcon").attr('src', res.userDto.icon);

            // 初始化未读消息
            var unReadMsg = parseInt(res.info);
            if (unReadMsg != 0){
                $('.badge').text(unReadMsg);
            } else {
                $('.badge').hide();
            }
        },function (error) {
            toastr.error("系统错误");
            return false;
        });

        // 打印上次登陆事件
        var lastTime = $("#lastLoginTime").val();
        if(lastTime != null && lastTime != "") {
            toastr.info(lastTime);
            $("#text1").val(null);
        }

        // 初始化隐藏loading
        document.getElementById("loading").style.display = "none";
    });
</script>
</body>
</html>