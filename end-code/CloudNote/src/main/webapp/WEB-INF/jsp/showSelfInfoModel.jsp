<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<div class="modal fade" id="showSelfInfoModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">个人信息</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="userInfoForm" role="form" action="${ctx}/saveSelfInfo"
                      method="post" enctype="multipart/form-data">
                    <input type="hidden" id="userId" name="id">
                    <div class="form-group">
                        <label for="userBigIcon" class="col-sm-2 control-label">头像</label>
                        <div class="col-sm-3">
                            <img class="img-circle" id="userBigIcon" name="icon" style="width: 100px;height: 100px"
                                 src=""/>
                        </div>
                        <div class="col-sm-7">
                            <span class="btn btn-success fileinput-button">
                                <span>上传头像</span>
                                <input type="file" id="uploadIcon" name="uploadIcon">
                            </span><br><br>
                            <span class="upload-hint">支持大多数图片格式，小于2MB</span><br>
                            <label id="fileName"></label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="userTel" class="col-sm-2 control-label">账号</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="userTel" name="tel" disabled>
                        </div>
                    </div>
                    <div class="form-group ">
                        <label for="userName" class="col-sm-2 control-label">昵称</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="userName" name="name" maxlength="16" required="required">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="userEmail" class="col-sm-2 control-label">电子邮箱</label>
                        <div class="col-sm-10">
                            <input type="email" id="userEmail" name="email" class="form-control" maxlength="32">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="userArea" class="col-sm-2 control-label">地区</label>
                        <div class="col-sm-4">
                            <input type="text" class="form-control" id="userArea" disabled>
                        </div>
                        <div class="col-sm-3">
                            <select data-live-search="true" id="areaSelect1" class="form-control">
                            </select>
                        </div>
                        <div class="col-sm-3">
                            <select data-live-search="true" id="areaSelect2" class="form-control" name="area">
                                <option value=-1>请选择市/区</option>
                            </select>
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
                        <label for="userSign" class="col-sm-2 control-label">签名</label>
                        <div class="col-sm-10">
                            <textarea class="form-control dis_change_textarea" id="userSign" name="sign"
                                      rows="2" style="resize: none" maxlength="64"></textarea>
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
    $('#areaSelect1').on('change', function () {
        var areaId = $(this).val();
        if (areaId != -1) {
            sendPost('${ctx}/getSecondArea', {'areaId': areaId}, true, function (res) {
                var options = '<option value="-1">请选择市/区</option>';
                // 动态添加二级下拉框
                var data = res.areas;
                for (var i = 0; i < data.length; i++) {
                    options += '<option value="' + data[i].id + '">' + data[i].name + '</option>';
                }
                $('#areaSelect2').html(options);
            }, function (error) {
                return false;
            });
        }
    });

    // 提交表单
    function checkUserInfo() {
        // 如果上传了头像，判断头像是否符合规范
        var icon = $("#uploadIcon").val();
        if (icon != null && icon != "") {
            var pictureSuffix = new Array("bmp", "png", "jpg", "jpeg", "gif");
            var point = icon.lastIndexOf(".");
            var type = icon.substr(point).toLowerCase();
            type = type.substr(1, type.length);

            var flag = false;
            for (var i = 0; i < pictureSuffix.length; i++) {
                if (pictureSuffix[i] == type) {
                    flag = true;
                    break;
                }
            }
            if (!flag) {
                toastr.warning("图片格式错误");
                return false;
            }
            if (fileSize / (1024 * 1024) > 2) {
                toastr.warning("头像太大啦");
                return false;
            }
        }

        var name = $("#userName").val();
        if (!(name.length >= 2 && name.length <= 10)) {
            toastr.warning("昵称长度在[2,10]之间");
            return false;
        }

        $("#userInfoForm").submit();
    }

    // 实时更新选中的文件名
    $("#uploadIcon").change(function () {
        var file = this.files[0];
        $("#fileName").html("当前选中：" + file.name);
        fileSize = file.size;
    });

</script>