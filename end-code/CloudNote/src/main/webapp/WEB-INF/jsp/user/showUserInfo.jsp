<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<div class="modal fade" id="showUserInfoModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">个人信息</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="userExpressForm" role="form" action="${ctx}/user/saveUserInfo"
                      method="post">
                    <input type="hidden" id="userId" name="id">
                    <div class="form-group">
                        <label for="userTel" class="col-sm-2 control-label">手机号码</label>
                        <div class="col-sm-10">
                            <input readonly="readonly" type="text" class="form-control" id="userTel" name="tel">
                        </div>
                    </div>
                    <div class="form-group ">
                        <label for="userName" class="col-sm-2 control-label">昵称</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="userName" name="name">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="userEmail" class="col-sm-2 control-label">电子邮箱</label>
                        <div class="col-sm-10">
                            <input type="email" id="userEmail" name="email" class="form-control">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="userArea" class="col-sm-2 control-label">地区</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="userArea" name="area">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="userIcon" class="col-sm-2 control-label">头像</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="userIcon" name="icon">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="userSex" class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <input type="text" id="userSex" name="sex" class="form-control">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="userSign" class="col-sm-2 control-label">签名</label>
                        <div class="col-sm-10">
                            <textarea class="form-control dis_change_textarea" id="userSign" name="sign"
                                      rows="2"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">保存</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>