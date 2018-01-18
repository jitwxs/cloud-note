<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<div class="modal fade" id="uploadPanModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">上传笔记</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="uploadPanForm" role="form" action="${ctx}/user/uploadPan"
                      method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="uploadFile" class="col-sm-2 control-label">选择文件</label>
                        <div class="col-sm-7">
                            <span class="btn btn-success fileinput-button">
                                <span>浏览...</span>
                                <input id="uploadNote_parent" type="hidden">
                                <input type="file" id="uploadFile">
                            </span><br><br>
                            <label id="uploadPanName">当前未选择文件！</label>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary" >导入</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<script>

    // 提交表单
    $('.btn-primary').on('click',function () {
        if ($('#uploadPanName').text() == "当前未选择文件！") {
            alert("当前未选择文件！");
            return false;
        } else {
            var formData = new FormData();
            var file = document.getElementById("uploadFile").files[0];
            var dirId = $("#uploadNote_parent").val();

            formData.append("dirId", dirId);
            formData.append("file", file);

            $.ajax({
                url : "${ctx}/user/uploadPan",
                type : 'post',
                data : formData,
                async:false,
                dataType:'json',
                // 告诉jQuery不要去处理发送的数据
                processData : false,
                // 告诉jQuery不要去设置Content-Type请求头
                contentType : false,
                beforeSend:function(){
                    console.log("正在进行，请稍候");
                },
                success:function(msg) {
                    $('#uploadPanModal').modal('hide');
                    if (msg.status) {
                        $('#content').append('<div class="wj">\n' +
                            '                        <a class="wenjian" index-id="'+msg.info+'"><img src="${ctx}/images/file.png">'+msg.name+'</a>\n' +
                            '                        <a  class="delete"><img src="${ctx}/images/delete.png"></a>\n' +
                            '                        <a  class="rename_note"><img src="${ctx}/images/rename.png"></a>\n' +
                            '                        <a class="download"><img src="${ctx}/images/download.png"></a>\n' +
                            '                    </div>');
                        initUI();
                    } else {
                        toastr.error("上传文件失败！");
                        return false;
                    }
                },
                error : function(msg) {
                    toastr.error("出错了！");
                    return false;
                }
            });
        }
    });


    // 实时更新选中的文件名
    $("input[type='file']").change(function(){
        var file = this.files[0];
        $("#uploadPanName").html("当前选中："+file.name);
    });

</script>
