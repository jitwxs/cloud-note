<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<div class="modal fade" id="shareNoteModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" >
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">分享笔记</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="noteId">
                <label>链接生成成功, 复制链接分享给好友吧</label>
                <div class="form-group ">
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="shareUrl" readonly="readonly">
                    </div>
                    <button class="col-sm-2 btn-primary" onclick="copyContent()">复制链接</button>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal" onclick="cancelShare()">取消分享</button>
                <button type="button" class="btn btn-primary" onclick="goShare()">查看分享</button>
            </div>
        </div>
    </div>
</div>

<script>
    function copyContent(){
        $("#shareUrl").select();
        document.execCommand("Copy");
        toastr.success("复制成功");
    }

    function goShare() {
        var url = $("#shareUrl").val();
        window.open(url);
    }

    function cancelShare() {
        var noteId = $("#noteId").val();
        sendPost('${ctx}/user/cancelShare', {'noteId': noteId}, true, function (msg) {
            if(msg.status) {
                toastr.success("取消分享成功");
            } else {
                toastr.error("取消分享失败");
            }
        }, function (error) {
            toastr.error("内部错误");
            return false;
        });
    }
</script>