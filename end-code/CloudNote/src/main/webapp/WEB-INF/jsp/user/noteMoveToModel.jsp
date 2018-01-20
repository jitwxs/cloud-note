<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<div class="modal fade" id="noteMoveToModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">移动到</h4>
            </div>
            <div class="modal-body">
                <div class="wjj" >
                    <input class="hidden" id="noteId" value="">
                    <input class="hidden" id="dirId" value="">
                    <a class="js_zwjj_move" style="cursor:pointer " index-id="root"><img src="${ctx}/images/wjj2.png" width="15px" height="15px">
                        我的文件夹</a>
                    <div class="wjj_div_move default" style="">

                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary"  onclick="submit()">确定</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<script>
   function submit() {
       // 获取源文件的名字和id
       // $chooseMove = $(this);
       var noteid = $('#noteId').val();
       var dirid = $('#dirId').val();
       console.log(noteid);
       console.log(dirid);
       // var id = $chooseMove.attr('index-id');
       sendPost('${ctx}/user/moveNoteToDir', {'dirId':dirid,'noteId':noteid}, false, function (msg) {
           if (msg.status) {
               $('#noteMoveToModel').modal('hide');
               $('.wjj_div').children().remove();
               sendGet('${ctx}/user/initArticleDir', {}, false, function (msg) {
                   dirAttr = msg.data;
                   showDir($('.wjj_div'), dirAttr);
                   initUI();
               }, function (error) {
                   toastr.error("初始化笔记错误");
                   return false;
               });
           } else {
               toastr.warning(msg.info);
           }
       },function (error) {
           toastr.error("选择文件夹出错了！")
       })
   }
</script>
