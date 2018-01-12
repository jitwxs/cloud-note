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
        <%--<!-- 引入模块框 -->--%>
        <jsp:include page="editUserInfo.jsp"/>
        <jsp:include page="editUserLogin.jsp"/>

        <div class="row">
            <jsp:include page="left.jsp"/>
            <div class="col-md-10" style="margin-left: 100px">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="row">
                            <h2 class="col-md-3">用户列表</h2>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead>
                            <tr>
                                <th>手机号</th>
                                <th>名称</th>
                                <th>email</th>
                                <th>操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach  items="${userList}" var="item">
                                <tr>
                                    <td>${item.tel}</td>
                                    <td>${item.name}</td>
                                    <td>${item.email}</td>
                                    <td>
                                        <button class="btn btn-info btn-xs" onclick="showUserInfo(${item.tel})">修改信息</button>
                                        <button class="btn btn-info btn-xs" onclick="showUserTel(${item.tel})">修改密码</button>
                                        <button class="btn btn-info btn-xs">打入小黑屋</button>
                                        <a class="btn btn-danger btn-xs" href="${ctx}/admin/deleteUser?tel=${item.tel}" onclick="return deleteUser()">删除用户</a>
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
    function deleteUser() {
        var msg = "您真的确定要删除该用户吗？删除后将无法恢复！";
        if (confirm(msg)){
            $.message('删除成功');
            return true;
        }else{
            return false;
        }
    }
    function showUserInfo(tel) {
        sendGet('${ctx}/admin/showUserInfo',{"tel":tel},true,function (res) {
            $("#userInfoId").val(res[0].id);
            $("#userInfoTel").val(res[0].tel);
            $("#userInfoName").val(res[0].name);
            $("#userInfoEmail").val(res[0].email);
            $("#userInfoArea").val(res[0].areaName);

            $("input:radio[name='sex'][value="+res[0].sex+"]").attr('checked','true');
            $("#userInfoSign").val(res[0].sign);

            // 动态添加省级下拉框
            for(var i=0; i<res[1].length; i++) {
                $("#areaSelect1").append("<option value='"+res[1][i].id+"'>"+res[1][i].name+"</option>");
            }

            $('#showUserInfoModal').modal('show');
        },function (error) {
            toastr.error("系统错误");
            return false;
        });
    }

    function showUserTel(tel) {
        $("#userLoginTel").val(tel);
        $('#editUserLoginModal').modal('show');
    }
</script>
</html>