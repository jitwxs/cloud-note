<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<div class="modal fade" id="shareModal" tabindex="-1" role="dialog" aria-labelledby="shareModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="shareModalLabel"></h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="shareControlForm" role="form" action="${ctx}/admin/shareControl"
                      method="post">
                    <input type="hidden" id="shareNoteId" name="ids">
                    <input type="hidden" id="controlType" name="controlType">
                    <div class="form-group">
                        <label for="shareNoteTitle" class="col-sm-2 control-label">文章标题</label>
                        <div class="col-sm-10">
                            <input readonly="readonly" type="text" class="form-control" id="shareNoteTitle">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="reasonName" class="col-sm-2 control-label">原因</label>
                        <div class="col-sm-7">
                            <select data-live-search="true" id="reasonName" name="reasonName" class="form-control">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="submitShareControlForm()">确定</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<script>
    function submitShareControlForm() {
        if($("#reasonName").val() == -1) {
            toastr.warning("请选择原因");
        } else {
            $("#shareControlForm").submit();
        }
    }
</script>