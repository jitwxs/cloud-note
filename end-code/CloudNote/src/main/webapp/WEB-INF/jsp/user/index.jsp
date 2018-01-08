<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>无道云笔记</title>
    <!-- Required meta tags always come first -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${ctx}/css/bootstrap.css">
    <link rel="stylesheet" href="${ctx}/css/wangEditor-fullscreen-plugin.css">
    <!-- 弹窗CSS -->
    <link rel="stylesheet" href="${ctx}/css/toastr.css">
    <!-- 自定义CSS -->
    <link rel="stylesheet" href="${ctx}/css/custom.css">
    <link rel="stylesheet" href="${ctx}/css/home_css.css">
    <!-- jQuery first, then Bootstrap JS. -->
    <script src="${ctx}/js/jquery-3.2.1.min.js"></script>
    <script src="${ctx}/js/bootstrap.js"></script>
    <!-- jQuery百叶窗 -->
    <script src="${ctx}/js/jquery.contextify.js"></script>
    <!-- wangEditor依赖 -->
    <script src="${ctx}/js/wangEditor.js"></script>
    <script src="${ctx}/js/wangEditor-fullscreen-plugin.js"></script>
    <!-- 弹窗依赖 -->
    <script src="${ctx}/js/toastr.js"></script>
    <!-- 封装ajax -->
    <script src="${ctx}/js/http.js"></script>
    <script src="${ctx}/js/home_js.js"></script>


</head>

<body style="margin-top: 60px;position: absolute;width: 100%" id="home_body">

<!-- 引入模块框 -->
<jsp:include page="showSelfInfo.jsp"/>
<jsp:include page="importNote.jsp"/>

<input type="hidden" id="lastLoginTime" value="${lastLoginTime}">

<!-- 导入头部 -->
<jsp:include page="head.jsp"/>

<!--侧边栏-->
<nav class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-left" id="cbp-spmenu-s1" style="height: 1500px;">
    ....
</nav>

<!--主体-->
<div  class="container" style="padding-right: 0px; width:100%" id="left">
    <div class="row">
        <div id="wangeditor" class="col-lg-10">
            <jsp:include page="directory.jsp"/>
            <jsp:include page="articleEditor.jsp"/>
        </div>
        <div class="col-lg-2" id="advertisment" style="background: yellow;height: 700px;">
    </div>
</div>

<!-- 引入页脚 -->
<jsp:include page="${ctx}/WEB-INF/jsp/global/footer.jsp"/>

<script>
    var menuLeft = document.getElementById( 'cbp-spmenu-s1' ),  //nav整个导航栏
        showLeftPush = document.getElementById( 'showLeftPush' ),//button按钮
        body = document.getElementById("home_body");
    showLeftPush.onclick = function() {
        var nav_id=document.getElementById("cbp-spmenu-s1");
        classie.toggle( this, 'active' );
        classie.toggle( body, 'cbp-spmenu-push-toright' );   //body 左移200px
        classie.toggle( menuLeft, 'cbp-spmenu-open' );   //nav 的left:0
    };

    var userTel;
    // 页面加载函数
    $(function(){
        // 得到当前用户手机号码
        userTel = $.trim($("#showId").text());
        var lastTime = $("#lastLoginTime").val();
        if(lastTime != null && lastTime != "") {
            toastr.info(lastTime);
            $("#text1").val(null);
        }
    });
</script>
</body>
</html>