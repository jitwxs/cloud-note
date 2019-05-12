<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<div class="modal fade" id="shareNoteModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">分享笔记</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="shareId">
                <input type="hidden" id="shareName">
                <input type="hidden" id="sharePic">
                <label>链接生成成功, 复制链接分享给好友吧</label>
                <div class="form-group ">
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="shareUrl" readonly="readonly">
                    </div>
                    <button class="col-sm-2 btn btn-primary" onclick="copyUrl()">复制链接</button>
                </div>
            </div>
            <div class="modal-footer" style="margin-top: 40px" onmouseover="setShare()">
                <!-- JiaThis Button BEGIN -->
                <div class="jiathis_style_32x32">
                    <a class="jiathis_button_tsina"></a>
                    <a class="jiathis_button_qzone"></a>
                    <a class="jiathis_button_weixin"></a>
                    <a class="jiathis_button_renren"></a>
                    <a href="http://www.jiathis.com/share" class="jiathis jiathis_txt jiathis_separator jtico jtico_jiathis" target="_blank"></a>
                </div>
                <!-- JiaThis Button END -->
                <button type="button" class="btn btn-default" data-dismiss="modal" onclick="cancelShare()">取消分享</button>
                <button type="button" class="btn btn-primary" onclick="goShare()">查看分享</button>
            </div>
        </div>
    </div>
</div>

<%-- 社会化分享 --%>
<script type="text/javascript" src="http://v3.jiathis.com/code/jia.js" charset="utf-8"></script>
<script>
    var jiathis_config = {};

    function setShare() {
        var url = $("#shareUrl").val();
        var pic = $("#sharePic").val();
        var shareName = $("#shareName").val();
        jiathis_config.title = "我在无道云笔记发现一篇好文章：《" + shareName + "》,现在分享给你，和我一起欣赏吧！";
        jiathis_config.url = url;
        jiathis_config.pic = pic;
    }
    
    function copyUrl() {
        $("#shareUrl").select();
        document.execCommand("Copy");
        toastr.success("复制成功");
    }

    function goShare() {
        var url = $("#shareUrl").val();
        $('#shareNoteModal').modal('hide');
        window.open(url);
    }

    function cancelShare() {
        var noteId = $("#noteId").val();
        sendPost('${ctx}/user/cancelShare', {'noteId': noteId}, true, function (msg) {
            if (msg.status) {
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