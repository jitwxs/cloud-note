<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<div class="modal fade" id="editUserLoginModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改密码</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="userLoginForm" role="form" action="${ctx}/admin/saveUserLogin"
                      method="post">
                    <div class="form-group">
                        <label for="userLoginTel" class="col-sm-2 control-label">手机号码</label>
                        <div class="col-sm-10">
                            <input readonly="readonly" type="text" class="form-control" id="userLoginTel" name="tel">
                        </div>
                    </div>
                    <div class="form-group ">
                        <label for="userLoginPassword" class="col-sm-2 control-label">新密码</label>
                        <div class="col-sm-10">
                            <input type="password" class="form-control" id="userLoginPassword" name="password" required="required">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="checkUserPassword()">保存</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<script>
    // 提交表单
    function checkUserPassword() {
        $("#userLoginForm").submit();
    }
</script>