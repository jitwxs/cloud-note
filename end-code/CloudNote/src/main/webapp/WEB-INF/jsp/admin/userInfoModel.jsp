<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<div class="modal fade" id="userInfoModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">用户信息</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="userInfoTel" class="col-sm-2 control-label">账户</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="userInfoTel" name="tel" disabled>
                        </div>
                    </div>
                    <div class="form-group ">
                        <label for="userInfoName" class="col-sm-2 control-label">昵称</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="userInfoName" name="name" disabled>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="userInfoEmail" class="col-sm-2 control-label">电子邮箱</label>
                        <div class="col-sm-10">
                            <input type="email" class="form-control" id="userInfoEmail" name="email" disabled>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="userInfoArea" class="col-sm-2 control-label">地区</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="userInfoArea" disabled>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="checkbox-inline">
                                <input type="radio" name="sex" value="男" checked>男
                            </label>
                            <label class="checkbox-inline">
                                <input type="radio" name="sex" value="女">女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="userInfoSign" class="col-sm-2 control-label">签名</label>
                        <div class="col-sm-10">
                            <textarea class="form-control dis_change_textarea" id="userInfoSign" name="sign"
                                      rows="2" disabled></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>