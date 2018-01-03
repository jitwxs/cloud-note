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
    <link rel="stylesheet" href="${ctx}/css/message.css">
    <!-- jQuery first, then Bootstrap JS. -->
    <script src="${ctx}/js/jquery-3.2.1.min.js"></script>
    <script src="${ctx}/js/bootstrap.js"></script>
</head>

<body>
<h1>首页</h1>

<a href="${ctx}/login">登陆</a>
<a href="${ctx}/register">注册</a>

<button type="button" class="btn btn-default" onclick="save()">保存</button>

<jsp:include page="/WEB-INF/jsp/global/footer.jsp"/>

<script>
    function save() {
        var a = '<!DOCTYPE html><html lang="zh-cn">';
        var z = "</html>";
        var by = $(":root").html();
        alert(a+by+z);
    }

</script>
</body>

</html>