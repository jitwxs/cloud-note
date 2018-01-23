<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<div class="modal fade" id="uploadNoteModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">上传笔记</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="uploadNoteForm" role="form" action="${ctx}/user/uploadNote"
                      method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="uploadNote" class="col-sm-2 control-label">选择文件</label>
                        <div class="col-sm-7">
                            <span class="btn btn-success fileinput-button">
                                <span>浏览...</span>
                                <input type="file" id="uploadNote" name="uploadNote">
                            </span><br><br>
                            <span class="upload-hint">上传后缀名为.note的笔记文件</span><br><br>
                            <label id="uploadNoteName"></label>
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
    function checkNote() {
        var tmpName = $("#uploadNote").val();
        if (tmpName != null && tmpName != "") {
            var point = tmpName.lastIndexOf(".");
            var type = tmpName.substr(point);
            if (type != ".note") {
                toastr.warning("上传错误");
                return false;
            }
        }
        $("#uploadNoteForm").submit();
    }

    // 实时更新选中的文件名
    $("input[type='file']").change(function () {
        var file = this.files[0];
        $("#uploadNoteName").html("当前选中：" + file.name);
    });

</script>
