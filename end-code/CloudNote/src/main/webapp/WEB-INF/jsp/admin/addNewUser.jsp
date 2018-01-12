    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>人员管理</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- 引入bootstrap -->
    <link rel="stylesheet" type="text/css" href="${ctx}/css/bootstrap.css">
    <link rel="stylesheet" type="text/css" href="${ctx}/css/custom.css">
    <link rel="stylesheet" type="text/css" href="${ctx}/css/message.css">
    <!-- 引入JQuery  bootstrap.js-->
    <script src="${ctx}/js/jquery-3.2.1.min.js"></script>
    <script src="${ctx}/js/bootstrap.js"></script>
    <script src="${ctx}/js/message.js"></script>
    <script src="${ctx}/js/http.js"></script>
</head>
<body>
    <div class="container" id="content" style="margin-bottom: 100px">
        <div class="row">
            <jsp:include page="left.jsp"/>
            <div class="col-md-10" style="margin-left: 100px">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="row">
                            <h2 class="col-md-3">添加用户</h2>
                        </div>
                    </div>


                </div>
            </div>
        </div>
    </div>
</body>

<script type="text/javascript">
</script>
</html>