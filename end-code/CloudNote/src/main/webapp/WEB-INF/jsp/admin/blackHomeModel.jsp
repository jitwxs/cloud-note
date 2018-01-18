<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<div class="modal fade" id="blackHomeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">加入小黑屋</h4>
            </div>
            <div class="modal-body">
                    <form class="form-horizontal" id="blackHomeForm" role="form" action="${ctx}/admin/addToBlackHome"
                      method="post">
                    <input type="hidden" id="userBlacklistId" name="userId">
                    <div class="form-group">
                        <label for="userBlacklistTel" class="col-sm-2 control-label">封禁账户</label>
                        <div class="col-sm-10">
                            <input readonly="readonly" type="text" class="form-control" id="userBlacklistTel" name="userTel">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="blacklistReason" class="col-sm-2 control-label">封禁原因</label>
                        <div class="col-sm-7">
                            <select data-live-search="true" id="blacklistReason" name="reasonId" class="form-control">
                                <option value=-1>请选择原因</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">封禁时长</label>
                        <div class="col-sm-7">
                            <label class="radio-inline">
                                <input type="radio" name="duration" value=3 checked> 3天
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="duration" value=7> 7天
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="duration" value=30> 1个月
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="duration" value=90> 3个月
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="duration" value=9999> 永久
                            </label>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="checkToBlacklist()">保存</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<script>
    // 提交表单
    function checkToBlacklist() {
        var tel = $("#userBlacklistTel").val();

        sendPost('${ctx}/admin/addBlacklistCheck',{'tel':tel},false,function (res) {
            if (res.status) {
                var msg =  res.info;
                if (!confirm(msg)){
                    $('#addBlackHomeModal').modal('hide');
                } else {
                    $("#blackHomeForm").submit();
                }
            } else {
                $("#blackHomeForm").submit();
            }
        },function (error) {
            toastr.error("系统错误");
        });
    }
</script>