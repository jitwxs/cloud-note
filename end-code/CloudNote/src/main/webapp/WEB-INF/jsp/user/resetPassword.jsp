<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<%-- 引入头部 --%>
<jsp:include page="settingHead.jsp"/>

<body>
    <div class="container">
        <div class="box1" >
            <h4 style="margin-left: 40px"> 更改密码</h4>
            <hr>
            <form method="post" action="${ctx}/user/resetPassword" onsubmit="return httpPost()">
                <div class="form-group" style="width: 250px;height: 50px;margin: 0 auto;margin-top: 20px">
                    请输入原始密码:<input  id="oldPassword" class="form-control" type="text" name="tel" maxlength="11"  placeholder="" required="required">
                </div>
                <div class="form-group" style="width: 250px;height: 50px;margin: 0 auto;margin-top: 20px">
                    设置新的密码:<input id="newPassword" class="form-control" type="password" name="newPassword" required="required">
                </div>
                <div class="form-group" style="width: 250px;height: 50px;margin: 0 auto;margin-top: 20px">
                    重复新的密码:<input id="newPassword2" class="form-control" type="password" name="newPassword2" required="required">
                </div>
                <button id="login_btn" type="submit"  class="btn btn-default" >确定</button>
            </form>
        </div>
    </div>

    <script>
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
                    toastr.error("原始密码不正确");
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