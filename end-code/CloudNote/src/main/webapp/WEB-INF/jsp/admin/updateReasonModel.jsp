<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<div class="modal fade" id="updateReasonModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改原因</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="updateReasonForm" role="form" action="${ctx}/admin/updateReason"
                      method="post">
                    <div class="form-group ">
                        <input type="hidden" class="form-control" id="reasonId" name="id">
                        <label for="reasonName" class="col-sm-2 control-label">原因</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="reasonName" name="name"
                                   required>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="submitUpdateReason()">保存</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<script>
    function submitUpdateReason() {
        $("#updateReasonForm").submit();
    }
</script>