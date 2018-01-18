<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<jsp:include page="left.jsp"/>

<body>
<div class="container" id="content" style="margin-bottom: 100px">

    <%--<!-- 引入模块框 -->--%>
    <jsp:include page="editIllegalReason.jsp"/>
    <jsp:include page="addIllegalReason.jsp"/>

    <div class="row">
        <div class="col-md-10" style="margin-left: 100px">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="row">
                        <h2 class="col-md-3">封禁设置</h2>
                        <button class="btn btn-default col-md-offset-2" data-toggle="modal" data-target="#myModal" style="margin-top: 20px;margin-left: 265px" onclick="addReason()">
                            添加原因<sapn class="glyphicon glyphicon-plus"/>
                        </button>
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="table table-bordered table-hover">
                        <thead>
                        <tr>
                            <th>封禁原因</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach  items="${IllegalReasonList}" var="item">
                            <tr>
                                <td>${item.name}</td>
                                <td>
                                    <button class="btn btn-info btn-xs" onclick="editReason('${item.id}','${item.name}')">修改</button>
                                    <a class="btn btn-danger btn-xs" onclick="return deleteReason('${item.id}')">删除</a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div class="panel-heading" style="margin-top: 100px">
                    <div class="row">
                        <h2 class="col-md-3">其他设置</h2>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
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
        if (confirm(msg)){
            window.location.href='${ctx}/admin/deleteIllegal?id=' + id;
        }else{
            return false;
        }
    }
</script>

</body>

</html>