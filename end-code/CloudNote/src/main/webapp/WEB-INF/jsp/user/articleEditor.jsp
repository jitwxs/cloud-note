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
        <button type="button" class="btn btn-primary" onclick="saveNoteContent()" style="float:right;">立即保存</button>
        <%--文件信息图标--%>
        <a tabindex="0" class="btn btn-default" role="button" data-toggle="popover"
           data-trigger="focus" title="" data-content="" data-placement="bottom"
           href="javascript:void(0)" onclick="getNoteInfo()" style="float:right;">文件信息</a>
    </form>

    <input type="hidden" id="noteId">
    <input type="hidden" id="noteName">

    <%-- 主编辑器 --%>
    <div id="editor" style="float: right;width:100%;">
        <p><b style="font-size: 25px">当前未选中任何笔记，请先选中一个哦！！</b></p>
    </div>
    <%-- 附件区域 --%>
    <div id="affixDiv" style="float: right;width:100%;margin-top: 10px">
        <form method="post" action="${ctx}/user/uploadAffix" onsubmit="return checkSubmitAffix()" enctype="multipart/form-data">
            <input type="hidden" id="affixNoteId" name="noteId">
            <div>
                <span class="btn btn-success fileinput-button">
                <span>添加附件</span>
                <input type="file" id="addAffix" name="addAffix">
            </span>
                <span class="btn btn-default fileinput-button">
                <span>上传附件（<<strong>10MB</strong>）</span>
                <input type="submit">
            </span>
                <label id="affixName"></label>
            </div>
        </form>
        <div id="affixContent" style="margin-top: 10px">
            <table class="table table-striped table-responsive">
                <thead>
                <tr>
                    <th>附件</th>
                    <th>预览</th>
                    <th>删除</th>
                </tr>
                </thead>
                <tbody id="affixContentTBody">
                </tbody>
            </table>
        </div>
    </div>

    <script type="text/javascript">
        var fileSize;
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
            var noteId = $("#affixNoteId").val();
            if(noteId == null || noteId == "") {
                toastr.warning("请先选择一篇笔记");
                return false;
            }
            sendPost('${ctx}/user/getNoteInfo',{'noteId':noteId},true,function (msg) {
                if(!msg.status) {
                    toastr.error("获取信息失败");
                } else {
                    var info = "";
                    info += "标题：" + msg.articleDto.title;
                    info += "<br>创建者：" + msg.articleDto.authorName;
                    info += "<br>创建时间：" + msg.articleDto.createDate;
                    info += "<br>修改时间：" + msg.articleDto.modifedDate;
                    var isopen = msg.articleDto.isOpen == 1 ? "公开" :"不公开";
                    info += "<br>是否公开：" + isopen;
                    $('[data-toggle="popover"]').attr("data-content",info);
                    $('[data-toggle="popover"]').popover('show');
                }
            },function (error) {
                toastr.error("系统错误");
                return false;
            });
        }

        // 保存笔记
        function saveNoteContent() {
            var content = editor.txt.html();
            var editorTags = $("#editorTags").val();
            var noteId = $("#affixNoteId").val();
            var noteName = $("#editorTitle").val();
            if(noteId == null || noteId == "") {
                toastr.warning("未选择笔记");
                return false;
            } else {
                sendPost('${ctx}/user/saveNote',{'noteId':noteId, 'noteName':noteName, 'data':content,'tag':editorTags},true,function (msg) {
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
            fileSize = file.size;
        });

        function checkSubmitAffix() {
            var noteId = $("#affixNoteId").val();
            var affixName = $("#affixName").html();
            if(noteId == null || noteId == "") {
                toastr.warning("还没有选择笔记哦（´Д`）");
                return false;
            }
            if(affixName == null || affixName == "") {
                toastr.warning("不选文件我咋上传呀(○´･д･)ﾉ");
                return false;
            }
            if(fileSize / (1024 * 1024) > 10) {
                toastr.warning("附件太大啦！");
                return false;
            }
            return true;
        }

        function deleteAffix(obj) {
            var id = obj.parentElement.parentElement.id;
            var noteId = $("#affixNoteId").val();
            var noteName = $("#noteName").val();
            if(noteId == null ||noteId == "") {
                toastr.error("系统错误");
                return false;
            } else {
                var msg = "确认要删除该附件吗(ｏ ‵-′)ノ";
                if (confirm(msg)){
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
            }
        }

        function previewAffix(obj) {
            var id = obj.parentElement.parentElement.id;
            var noteId = $("#affixNoteId").val();
            var typeArray=new Array("doc","docx","xls","xlsx","ppt","pptx");

            if(noteId == null || noteId == "") {
                toastr.error("系统错误");
            } else {
                var tmpName = obj.value;
                var point = tmpName.lastIndexOf(".");
                var type = tmpName.substr(point).toLowerCase();
                type = type.substr(1,type.length);
                var flag = true;

                // 如果是pdf文件，直接预览即可
                if(type == "pdf") {
                    sendPost('${ctx}/user/previewAffix',{'affixId':id},true,function (res) {
                        if(res.status) {
                            //TODO 上线记得修改为服务器地址
                            var url = "http://localhost:8080/" + res.info;
                            window.open(url);
                        } else {
                            toastr.error(res.info);
                        }
                    },function (error) {
                        toastr.error("系统错误");
                        return false;
                    });
                } else {
                    // 如果不是pdf，判断是否是可转换的数据类型
                    for(var i=0; i<typeArray.length; i++) {
                        if(typeArray[i] == type) {
                            flag = true;
                            break;
                        }
                    }
                    if(!flag) {
                        toastr.warning("该格式似乎不支持预览");
                    } else {
                        // 转换格式
                        document.getElementById("loading").style.display = "block";
                        sendPost('${ctx}/user/convertFile',{'affixId':id},true,function (res) {
                            if(!res.status) {
                                toastr.error(res.info);
                            } else {
                                // 转换成功后。预览文件
                                document.getElementById("loading").style.display = "none";
                                sendPost('${ctx}/user/previewAffix',{'affixId':id},true,function (res) {
                                    if(res.status) {
                                        //TODO 上线记得修改为服务器地址
                                        var url = "http://localhost:8080/" + res.info;
                                        window.open(url);
                                    } else {
                                        toastr.error(res.info);
                                    }
                                },function (error) {
                                    toastr.error("系统错误");
                                    return false;
                                });
                            }
                        },function (error) {
                            toastr.error("系统错误");
                            return false;
                        });
                    }
                }
            }
        }

        $('[data-toggle="popover"]').popover({
            html: true,
            animation : true
        });
    </script>
</div>