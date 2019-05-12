<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<div class="modal fade" id="addReasonModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">添加原因</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="addReasonForm" role="form" action="${ctx}/admin/addReason"
                      method="post">
                    <input type="hidden" id="reasonType" name="type">
                    <div class="form-group ">
                        <label for="addReasonName" class="col-sm-2 control-label">原因</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="addReasonName" name="name"
                                   required="required">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="submitAddReason()">保存</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<script>
    function submitAddReason() {
        var type = $('#reasonType').val();
        var name = $('#addReasonName').val();
        sendPost('${ctx}/admin/addReasonCheck', {'type': type, 'name': name}, false, function (msg) {
            if (msg.status) {
                $("#addReasonForm").submit();
            } else {
                toastr.warning("原因名重复！");
            }
        },function (error) {
            toastr.error("系统错误");
        });
    }
</script>