<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<jsp:include page="left.jsp"/>

<body class="admin_body">
<div class="admin_container" style="margin-top: 60px;">
    <%-- 引入模块框 --%>
    <jsp:include page="updateReasonModel.jsp"/>
    <jsp:include page="addReasonModel.jsp"/>
        <h2 style="text-align: center; margin-top: 50px;margin-bottom: 50px;">系&nbsp;统&nbsp;设&nbsp;置</h2>
    <%-- 用户封禁 --%>
    <div class="panel panel-success" style="width:80%; margin-left: 10%;margin-bottom: 70px;" >
        <div class="panel-heading">用户封禁</div>
        <div class="panel-body">
            <a class="btn btn-default btn-sm" data-toggle="modal" data-target="#myModal" onclick="addReason(1)">
                添加
                <sapn class="glyphicon glyphicon-plus"/>
            </a>
        </div>
        <table class="table table-bordered table-hover">
            <thead>
            <tr>
                <th>原因</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${illegalReason}" var="item">
                <tr>
                    <td>${item.name}</td>
                    <td>
                        <button class="btn btn-info btn-xs"
                                onclick="updateReason('${item.id}','${item.name}')">修改
                        </button>
                        <a class="btn btn-danger btn-xs" onclick="return deleteReason('${item.id}')">删除</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <%-- 分享审核 --%>
    <div class="panel panel-success" style="width:80%; margin-left: 10%;">
        <div class="panel-heading">分享审核</div>
        <div class="panel-body">
            <a class="btn btn-default btn-sm" data-toggle="modal" data-target="#myModal" onclick="addReason(2)">
                添加
                <sapn class="glyphicon glyphicon-plus"/>
            </a>
        </div>
        <table class="table table-bordered table-hover">
            <thead>
            <tr>
                <th>原因</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${shareReason}" var="item">
                <tr>
                    <td>${item.name}</td>
                    <td>
                        <button class="btn btn-info btn-xs"
                                onclick="updateReason('${item.id}','${item.name}')">修改
                        </button>
                        <a class="btn btn-danger btn-xs" onclick="return deleteReason('${item.id}')">删除</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

</div>

<script>
    function updateReason(id, name) {
        $("#reasonName").val(name);
        $("#reasonId").val(id);
        $('#updateReasonModal').modal('show');
    }

    function addReason(type) {
        $("#reasonType").val(type);
        $('#addReasonModal').modal('show');
    }

    function deleteReason(id) {
        var msg = "您真的确定要删除该原因吗？";
        if (confirm(msg)) {
            window.location.href = '${ctx}/admin/deleteReason?id=' + id;
        } else {
            return false;
        }
    }
</script>

</body>
</html>