<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<jsp:include page="left.jsp"/>

<body>
<div class="container">
    <%-- 引入模块框 --%>
    <jsp:include page="editIllegalReason.jsp"/>
    <jsp:include page="addIllegalReason.jsp"/>

    <%-- 封禁设置 --%>
    <div class="panel panel-primary">
        <div class="panel-heading">封禁设置</div>
        <div class="panel-body">
            <a class="btn btn-default btn-sm" data-toggle="modal" data-target="#myModal" onclick="addReason()">
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
            <c:forEach items="${IllegalReasonList}" var="item">
                <tr>
                    <td>${item.name}</td>
                    <td>
                        <button class="btn btn-info btn-xs"
                                onclick="editReason('${item.id}','${item.name}')">修改
                        </button>
                        <a class="btn btn-danger btn-xs" onclick="return deleteReason('${item.id}')">删除</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <%-- 系统设置 --%>
    <div class="panel panel-primary">
        <div class="panel-heading">系统设置</div>
        <div class="panel-body">
            <p>配置系统，谨慎设置</p>
        </div>

        <ul class="list-group">
            <%-- 设置登陆信息 --%>
            <li class="list-group-item">
                <label>用户默认性别</label>
                <label class="radio-inline">
                    <input type="radio" name="inlineRadioOptions" id="inlineRadio1" value="option1">男
                </label>
                <label class="radio-inline">
                    <input type="radio" name="inlineRadioOptions" id="inlineRadio2" value="option2">女
                </label>
            </li>
            <li class="list-group-item">Dapibus ac facilisis in</li>
            <li class="list-group-item">Morbi leo risus</li>
            <li class="list-group-item">Porta ac consectetur ac</li>
            <li class="list-group-item">Vestibulum at eros</li>
        </ul>
    </div>


</div>

<script>
    function editReason(id, name) {
        $("#illegalReasonName").val(name);
        $("#illegalReasonId").val(id);
        $('#updateIllegalModal').modal('show');
    }

    function addReason() {
        $('#addIllegalModal').modal('show');
    }

    function deleteReason(id) {
        var msg = "您真的确定要删除该原因吗？删除后可能解封一些用户！";
        if (confirm(msg)) {
            window.location.href = '${ctx}/admin/deleteIllegal?id=' + id;
        } else {
            return false;
        }
    }
</script>

</body>
</html>