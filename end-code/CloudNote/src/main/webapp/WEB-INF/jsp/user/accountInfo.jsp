<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<%-- 引入头部 --%>
<jsp:include page="settingHead.jsp"/>

<body>
<%--<div class="container" >--%>
<div class="box1" style="width: 300px;float: left;margin-left: 20%">
    <h4> 账号信息</h4>
    <hr>
    <ol >账号：<label id="accountTel"/></ol>
    <ol >邮箱：<label id="emailAddr"/></ol>
    <ol >注册日期：<label id="registerDate"/></ol>
</div>
<br>
<div style="float: right;margin-right: 30%;margin-top: 80px">
    <h4 id="choose_options"> 更改密码</h4>
    <hr>
    <form id="change_password" method="post" action="${ctx}/user/resetPassword" onsubmit="return httpPost()" >
        <div class="form-group" style="width: 300px;height: 50px;">
            <label for="oldPassword">请输入原始密码</label>
            <input type="password" class="form-control" id="oldPassword" maxlength="11" required>
        </div>
        <div class="form-group" style="width: 300px;height: 50px;">
            <label for="newPassword">设置新的密码</label>
            <input type="password" class="form-control" id="newPassword" name="newPassword" required>
        </div>
        <div class="form-group" style="width: 300px;height: 50px;">
            <label for="newPassword2">重复新的密码</label>
            <input type="password" class="form-control" id="newPassword2" required>
        </div>
        <button type="submit" class="btn btn-default" style="color: white;background: lightskyblue;font-size: 18px;float: left;margin-top: 20px;">确定</button>
    </form>
</div>
<%--</div>--%>

<script>
    $(function() {
        sendGet('${ctx}/showSelfInfo',{},true,function (res) {
            $("#accountTel").html(res.userDto.tel);
            $("#emailAddr").html(res.userDto.email);
            $("#registerDate").html(res.userDto.createDate);
        },function (error) {
            toastr.error("系统错误");
            return false;
        });
    });

    function httpPost() {
        var oldPassword = $("#oldPassword").val();
        var newPassword = $("#newPassword").val();
        var newPassword2 = $("#newPassword2").val();
        var flag = true;

        if (newPassword != newPassword2) {
            toastr.warning("两次密码不一致");
            return false;
        }
        sendPost('${ctx}/user/verifyPassword', {'password': oldPassword}, false, function (msg) {
            if (!msg.status) {
                toastr.warning("原始密码不正确");
                flag = false;
            } else {
                toastr.success("验证成功");
            }
        }, function (error) {
            toastr.error("系统错误");
            flag = false;
        });
        return flag;
    }

</script>

</body>

</html>