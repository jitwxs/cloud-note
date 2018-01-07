<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<div class="modal fade" id="importNoteModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">导入笔记</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="importNoteForm" role="form" action="${ctx}/user/importNote"
                      method="post" enctype="multipart/form-data">
                    <input type="hidden" id="userId" name="id">
                    <div class="form-group">
                        <label for="importNote" class="col-sm-2 control-label">上传文件</label>
                        <div class="col-sm-7">
                            <span class="btn btn-success fileinput-button">
                                <span>浏览...</span>
                                <input type="file" id="importNote" name="importNote">
                            </span><br><br>
                            <label id="importNoteName">当前未选中文件</label>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary" onclick="checkNote()">导入</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<script>
    // 提交表单
    function checkNote() {
        $("#importNoteForm").submit();
    }

    // 实时更新选中的文件名
    $("input[type='file']").change(function(){
        var file = this.files[0];
        $("#importNoteName").html("当前选中："+file.name);
    });

</script>
