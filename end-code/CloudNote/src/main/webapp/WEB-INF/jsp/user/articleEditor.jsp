<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<div class="col-md-10" style="float: right">
    <form class="form-inline">
        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">标题</div>
                <input type="text" class="form-control" id="editorTitle">
            </div>
        </div>
        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">标签</div>
                <input type="text" class="form-control" id="editorTags">
            </div>
        </div>
        <label>Tip:每当你点到别的地方我们都会为您自动保存，别担心内容丢失哦！</label>
        <button type="button" class="btn btn-default" onclick="getNoteInfo()" style="float:right;">笔记信息</button>
        <button type="button" class="btn btn-primary" onclick="saveNoteContent()" style="float:right;">立即保存</button>
    </form>

    <input type="hidden" id="noteId">
    <input type="hidden" id="noteName">

    <!-- 主编辑器 -->
    <div id="editor" style="float: right;width:100%;">
        <p><b style="font-size: 25px">当前未选中任何文件，请先选择文件哦！！</b></p>
    </div>
    <!-- 附件区域 -->
    <div id="affixDiv" style="float: right;width:100%;margin-top: 10px">
        <form method="post" enctype="multipart/form-data" action="${ctx}/user/uploadAffix" onsubmit="return checkSubmitAffix()">
            <input type="hidden" id="affixNoteId" name="noteId">
            <div>
                <span class="btn btn-success fileinput-button">
                <span>添加附件</span>
                <input type="file" id="addAffix" name="addAffix">
            </span>
                <label id="affixName"></label>
                <span class="btn btn-default fileinput-button">
                <span>上传附件</span>
                <input type="submit">
            </span>
            </div>
        </form>
        <div id="affixContent" style="margin-top: 10px">
        </div>
    </div>

    <script type="text/javascript">
        var strRegex = "^((https|http|ftp|rtsp|mms)?://)"
            + "?(([0-9a-z_!~*'().&=+$%-]+: )?[0-9a-z_!~*'().&=+$%-]+@)?" //ftp的user@
            + "(([0-9]{1,3}\.){3}[0-9]{1,3}" // IP形式的URL- 199.194.52.184
            + "|" // 允许IP和DOMAIN（域名）
            + "([0-9a-z_!~*'()-]+\.)*" // 域名- www.
            + "([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\." // 二级域名
            + "[a-z]{2,6})" // first level domain- .com or .museum
            + "(:[0-9]{1,4})?" // 端口- :80
            + "((/?)|" // a slash isn't required if there is no file name
            + "(/[0-9a-z_!~*'().;?:@&=+$,%#-]+)+/?)$";

        var E = window.wangEditor;
        var editor = new E('#editor');

        // 对输入链接的校验
        editor.customConfig.linkCheck = function (text, link) {
            var re=new RegExp(strRegex);
            if (re.test(link))
                return true;
            else
                return "链接不合法";
        };

        // 区域失去焦点
        editor.customConfig.onblur = function (html) {
            var noteId = $("#noteId").val();
            var noteName = $("#noteName").val();
            sendPost('${ctx}/user/saveNote',{'noteId':noteId, 'noteName':noteName, 'data':html},true,function (msg) {
            },function (error) {
                return false;
            });
        };

        // 使用 base64 保存图片
        editor.customConfig.uploadImgShowBase64 = true;

        editor.customConfig.zIndex = 100;
        editor.create();

        // 初始化全屏插件
        E.fullscreen.init('#editor');

        // 获取笔记信息
        function getNoteInfo() {
            var noteId = $("#noteId").val();
            sendPost('${ctx}/user/getNoteInfo',{'noteId':noteId},true,function (msg) {
                if(!msg.status) {
                    toastr.error("获取信息失败");
                }
            },function (error) {
                toastr.error("系统错误");
                return false;
            });
        }

        // 保存笔记
        function saveNoteContent() {
            var content = editor.txt.html();

            var noteId = $("#affixNoteId").val();
            var noteName = $("#editorTitle").val();
            if(noteId == null || noteId == "") {
                toastr.warning("未选择笔记");
                return false;
            } else {
                sendPost('${ctx}/user/saveNote',{'noteId':noteId, 'noteName':noteName, 'data':content},true,function (msg) {
                    if(msg.status) {
                        toastr.success("笔记已保存");
                    } else {
                        toastr.error("保存失败");
                    }
                },function (error) {
                    toastr.error("系统错误");
                    return false;
                });
            }
        }

        // 实时更新选中的文件名
        $("#addAffix").change(function(){
            var file = this.files[0];
            $("#affixName").html("当前选中："+file.name);
        });

        function checkSubmitAffix() {
            var noteId = $("#affixNoteId").val();
            var affixName = $("#affixName").val();
            if(noteId == null || noteId == "") {
                toastr.warning("还没有选择笔记哦（´Д`）");
                return false;
            }
            if(affixName == null || affixName == "") {
                toastr.warning("不选文件我咋上传呀(○´･д･)ﾉ");
                return false;
            }
            return true;
        }

        function deleteAffix(obj) {
            var id = obj.parentElement.id;
            var noteId = $("#noteId").val();
            var noteName = $("#noteName").val();
            sendPost('${ctx}/user/removeAffix',{'affixId':id},true,function (res) {
                if(res.status) {
                    toastr.success("删除成功!");
                    flushNote(noteId, noteName);
                } else {
                    toastr.error("删除失败!");
                }
            },function (error) {
                toastr.error("系统错误");
                return false;
            });
        }
        
        <%--function previewAffix(this) {--%>
            <%--var id = obj.parentElement.id;--%>
            <%--sendPost('${ctx}/user/showAffix',{'affixId':id},true,function (res) {--%>
                <%--if(res.status) {--%>
                    <%--toastr.success("删除成功!");--%>
                <%--} else {--%>
                    <%--toastr.warning("删除失败!");--%>
                <%--}--%>
            <%--},function (error) {--%>
                <%--toastr.error("系统错误");--%>
                <%--return false;--%>
            <%--});--%>
        <%--}--%>

    </script>
</div>