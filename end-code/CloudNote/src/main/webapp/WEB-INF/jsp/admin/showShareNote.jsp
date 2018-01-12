    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>笔记管理</title>
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
        <%--<!-- 引入模块框 -->--%>
        <%--<jsp:include page="editUserInfo.jsp"/>--%>
        <%--<jsp:include page="editUserLogin.jsp"/>--%>

        <div class="row">
            <jsp:include page="left.jsp"/>
            <div class="col-md-10" style="margin-left: 100px">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="row">
                            <h2 class="col-md-3">分享管理</h2>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead>
                            <tr>
                                <th>笔记名</th>
                                <th>作者</th>
                                <th>创建时间</th>
                                <th>操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach  items="${noteList}" var="item">
                                <tr>
                                    <td>${item.title}</td>
                                    <td>${item.authorTel}</td>
                                    <td>${item.createDate}</td>
                                    <td>
                                        <button class="btn btn-info btn-xs">查看笔记</button>
                                        <a class="btn btn-danger btn-xs"  href="${ctx}/admin/cancelShare?id=${item.id}">取消分享</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>

<script type="text/javascript">
</script>
</html>