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
                <form class="form-horizontal" id="userInfoForm" role="form" action="${ctx}/admin/saveUserInfo"
                      method="post">
                    <input type="hidden" id="userInfoId" name="id">
                    <div class="form-group">
                        <label for="userInfoTel" class="col-sm-2 control-label">手机号码</label>
                        <div class="col-sm-10">
                            <input readonly="readonly" type="text" class="form-control" id="userInfoTel" name="tel">
                        </div>
                    </div>
                    <div class="form-group ">
                        <label for="userInfoName" class="col-sm-2 control-label">昵称</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="userInfoName" name="name" required="required">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="userInfoEmail" class="col-sm-2 control-label">电子邮箱</label>
                        <div class="col-sm-10">
                            <input type="email" id="userInfoEmail" name="email" class="form-control">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="userInfoArea" class="col-sm-2 control-label">地区</label>
                        <div class="col-sm-3">
                            <input type="text" class="form-control" id="userInfoArea" readonly="readonly">
                        </div>
                        <duv class="col-sm-7">
                            <select data-live-search="true" id="areaSelect1">
                                <option value=-1>请选择省/市</option>
                            </select>
                            <select data-live-search="true" id="areaSelect2" name="area">
                                <option value=-1>请选择市/区</option>
                            </select>
                        </duv>
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
                                      rows="2"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="checkUserInfo()">保存</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<script>
    var fileSize;
    $('#areaSelect1').on('change',function(){
        var areaId = $(this).val();
        if(areaId != -1){
            sendPost('${ctx}/getSecondArea', {'areaId': areaId}, true, function (res) {
                var options = '<option value="-1">请选择市/区</option>';
                // 动态添加市级下拉框
                for(var i=0; i<res.length; i++) {
                    options += '<option value="' + res[i].id+ '">'+ res[i].name + '</option>';
                }
                $('#areaSelect2').html(options);
            }, function (error) {
                return false;
            });
        }
    });

    // 提交表单
    function checkUserInfo() {
        $("#userInfoForm").submit();
    }
</script>