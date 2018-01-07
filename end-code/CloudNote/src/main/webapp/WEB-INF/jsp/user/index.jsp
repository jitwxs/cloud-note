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
</head>

<body>
<jsp:include page="head.jsp"/>
<!-- 引入模块框 -->
<jsp:include page="showSelfInfo.jsp"/>
<jsp:include page="importNote.jsp"/>

<input type="hidden" id="lastLoginTime" value="${lastLoginTime}">

<div class="container">
    <div class="row">
        <!-- 引入左侧目录结构 -->
        <jsp:include page="directory.jsp"/>

        <!-- 引入右侧富文本编辑器 -->
        <jsp:include page="articleEditor.jsp"/>
    </div>
</div>

<!-- 引入页脚 -->
<jsp:include page="${ctx}/WEB-INF/jsp/global/footer.jsp"/>
<script>
    // 页面加载函数
    $(function(){
        // 得到当前用户手机号码
        // var userTel = $.trim($("#showId").text());
        var lastTime = $("#lastLoginTime").val();
        if(lastTime != null && lastTime != "") {
            toastr.info(lastTime);
            $("#text1").val(null);
        }
    });
</script>
</body>
</html>