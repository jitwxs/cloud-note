<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<div class="col-md-10" style="float: right; ">
        <form class="form-inline" style="margin-bottom: 20px;">
            <div class="form-group" style="margin-right: 30px;">
                <div class="input-group">
                    <div class="input-group-addon">标题</div>
                    <input type="text" class="form-control" id="editorTitle">
                </div>
            </div>

            <label>Tip:每当你点到别的地方我们都会为您自动保存，别担心内容丢失哦！</label>
            <button type="button" class="btn btn-primary" onclick="saveNoteContent()" style="float:right; margin-right: 10px;">立即保存</button>
            <%--文件信息图标--%>
            <a tabindex="0" class="btn btn-default" role="button" data-toggle="popover"
               data-trigger="focus" title="" data-content="" data-placement="bottom"
               href="javascript:void(0)" onclick="getNoteInfo()" style="float:right; margin-right: 20PX;">文件信息</a>

            <%--标签--%>
            <div class="form-group" style="margin-right: 30px;margin-top: 10px;position: relative">
                    <div class="input-group" style="float: left;">
                        <div class="input-group-addon">标签</div>
                        <input type="text" class="form-control" id="newTagInput" placeholder="在此新增">
                        <div class="input-group-addon addTag"><img src="${ctx}/images/add.png" style="height: 18px;width: 18px;cursor: pointer"></div>
                    </div>
                    <div id="tag" style="float: left;">
                        <div id="tag_container">
                        </div>
                    </div>
            </div>
        </form>

    <input type="hidden" id="noteId">
    <input type="hidden" id="noteName">

    <%-- 主编辑器 --%>
    <div id="editor" style="float: right;width:100%;background: white">
        <p><b style="font-size: 20px">Tips: 您当前未选中笔记，先看看使用帮助吧！</b></p>
        <p><b>新建目录：</b>点击左侧目录树中的任一目录，右击<span><b>新建目录</b></span></p>
        <p><b>新建笔记：</b>点击左侧目录树中的任一目录，右击<span><b>新建笔记</b></span></p>
        <p><b>重命名笔记：</b>点击左侧目录树中的任一目录，右击<span><b>重命名笔记</b></span></p>
        <p><b>上传笔记：</b>点击左侧目录树中的任一目录，右击<span><b>上传笔记</b></span>，选择<span><b>无道云笔记文件(.note)</b></span></p>
        <p><b>下载笔记：</b>点击左侧目录树中的任一目录，右击<span><b>下载笔记</b></span></p>
        <p><b>分享笔记：</b>点击左侧目录树中的任一笔记，右击<span><b>分享</b></span>，你的笔记将会被公开，其他人通过链接可以查看该笔记</p>
        <p><b>删除笔记：</b>点击左侧目录树中的任一笔记，右击<span><b>删除</b></span>，笔记将会放入回收站</p>
        <p><b>删除回收站笔记：</b>点击左侧回收站中的任一笔记右击<span><b>删除</b></span>，或右击回收站选择<span><b>清空回收站</b></span></p>
    </div>
    <%-- 附件区域 --%>
    <div id="affixDiv" style="float: right;width:100%;margin-top: 10px">
        <form class="form-horizontal" role="form" enctype="multipart/form-data">
            <input type="hidden" id="affixNoteId" name="noteId">
            <div>
                <span class="btn btn-success fileinput-button">
                <span>添加附件</span>
                <input type="file" id="addAffix" name="addAffix">
            </span>
                <a class="btn btn-default fileinput-button" onclick="uploadAffix()">
                    <span>上传附件（<<strong>10MB</strong>）</span>
                </a>
                </span>
                <label id="affixName"></label>
            </div>
        </form>
        <div id="affixContent" style="margin-top: 10px">
            <table class="table table-hover table-responsive">
                <thead>
                <tr>
                    <th>附件名称</th>
                    <th>预览(支持图片、网页、word、excel、ppt、pdf)</th>
                    <th>删除</th>
                </tr>
                </thead>
                <tbody id="affixContentTBody">
                <td colspan="3" style="text-align: center">该笔记还没有任何附件</td>
                </tbody>
            </table>
        </div>
    </div>

    <!-- 过度动画区域 -->
    <div class="spinner hidden">
        <div class="rect1"></div>
        <div class="rect2"></div>
        <div class="rect3"></div>
        <div class="rect4"></div>
        <div class="rect5"></div>
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
            if(noteId != null && noteId != "" && noteName != null && noteName != "") {
                sendPost('${ctx}/user/saveNote',{'noteId':noteId, 'noteName':noteName, 'data':html},true,function (msg) {
                    if(!msg.status) {
                        toastr.error(msg.info);
                    }
                },function (error) {
                    return false;
                });
            }
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
            var noteId = $("#affixNoteId").val();
            var noteName = $("#editorTitle").val();
            if(noteId == null || noteId == "") {
                toastr.warning("未选择笔记");
                return false;
            } else if(noteName == null || noteName == "") {
                toastr.warning("笔记标题不能为空");
                return false;
            } else {
                sendPost('${ctx}/user/saveNote',{'noteId':noteId, 'noteName':noteName, 'data':content},true,function (msg) {
                    if(msg.status) {
                        toastr.success("笔记已保存");
                        var $jsNoteBtns = $('.js_note_btn');
                        for (var i = 0; i < $jsNoteBtns.length; i++ ){
                            if ($($jsNoteBtns[i]).attr('index-id') == noteId){
                                $($jsNoteBtns[i]).text(noteName);
                                break;
                            }
                        }
                    } else {
                        toastr.error(msg.info);
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

        function uploadAffix() {
            var noteId = $("#affixNoteId").val();
            var noteName = $("#editorTitle").val();
            var affixName = $("#affixName").html();

            if(noteId == null || noteId == "") {
                toastr.warning("请先选择一篇笔记");
            } else  if(affixName == null || affixName == "") {
                toastr.warning("请先选择上传文件");
            } else {
                var maxSize = 10 * 1024 * 1024;
                if(fileSize > maxSize) {
                    toastr.warning("超出大小限制");
                } else {
                    var formData = new FormData();
                    var file = document.getElementById("addAffix").files[0];

                    formData.append("noteId", noteId);
                    formData.append("file", file);

                    $.ajax({
                        url : "${ctx}/user/uploadAffix",
                        type : 'post',
                        data : formData,
                        async:true,
                        dataType:'json',
                        // 告诉jQuery不要去处理发送的数据
                        processData : false,
                        // 告诉jQuery不要去设置Content-Type请求头
                        contentType : false,
                        success:function(msg) {
                            if (msg.status) {
                                toastr.success("上传成功");
                                flushNote(noteId, noteName);
                            } else {
                                toastr.error("上传失败");
                            }
                        },
                        error : function(msg) {
                            toastr.error("系统错误");
                            return false;
                        }
                    });
                }
            }
        }

        function deleteAffix(obj) {
            var id = obj.parentElement.parentElement.id;
            var noteId = $("#affixNoteId").val();
            var noteName = $("#noteName").val();
            if(noteId == null ||noteId == "") {
                toastr.error("系统错误");
                return false;
            } else {
                var dblChoseAlert = simpleAlert({
                    "content": "确认要删除该附件吗(ｏ ‵-′)ノ",
                    "buttons": {
                        "确定": function () {
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
                            dblChoseAlert.close();
                        },
                        "取消": function () {
                            dblChoseAlert.close();
                        }
                    }
                })
            }
        }

        function previewAffix(obj) {
            var id = obj.parentElement.parentElement.id;
            var noteId = $("#affixNoteId").val();
            var previewArray = new Array("pdf","bmp", "png", "jpg", "jpeg", "gif", "htm", "html");
            var convertArray=new Array("doc","docx","xls","xlsx","ppt","pptx");

            if(noteId == null || noteId == "") {
                toastr.error("系统错误");
            } else {
                var tmpName = obj.value;
                var point = tmpName.lastIndexOf(".");
                var type = tmpName.substr(point).toLowerCase();
                type = type.substr(1,type.length);

                var previewFlag = false, convertFlag = false;

                // 如果可预览，直接预览即可
                for(var i=0; i<previewArray.length; i++) {
                    if(previewArray[i] == type) {
                        previewFlag = true;
                        break;
                    }
                }
                // 如果不可预览，判断是否是可转换的数据类型
                if(!previewFlag) {
                    for(var i = 0; i < convertArray.length; i++) {
                        if(convertArray[i] == type) {
                            convertFlag = true;
                            break;
                        }
                    }
                }

                if(previewFlag) {
                    sendPost('${ctx}/user/previewAffix',{'affixId':id},true,function (res) {
                        if(res.status) {
                            var url = res.info;
                            window.open(url);
                        } else {
                            toastr.error(res.info);
                        }
                    },function (error) {
                        toastr.error("系统错误");
                        return false;
                    });
                } else if(convertFlag) {
                    if($(".spinner").hasClass("hidden")) {
                        $(".spinner").removeClass("hidden");
                    }
                    sendPost('${ctx}/user/convertFile',{'affixId':id},true,function (res) {
                        if(!$(".spinner").hasClass("hidden")) {
                            $(".spinner").addClass("hidden");
                        }
                        if(!res.status) {
                            toastr.error(res.info);
                        } else {
                            // 转换成功后，预览文件
                            sendPost('${ctx}/user/previewAffix',{'affixId':id},true,function (res) {
                                if(res.status) {
                                    var url = res.info;
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
                        // 转换成功后。预览文件
                        if(!$(".spinner").hasClass("hidden")) {
                            $(".spinner").addClass("hidden");
                        }
                        return false;
                    });
                } else {
                    toastr.warning("该格式不支持预览");
                }
            }
        }

        $('[data-toggle="popover"]').popover({
            html: true,
            animation : true
        });

        //添加标签
        $('.addTag').off('click').on('click', function () {
            //取输入框的值
            var tagText = $('#newTagInput').val();
            var noteId = $("#affixNoteId").val();
            if (tagText != "" && noteId != "") {
                sendPost('${ctx}/user/addArticleTag', {'noteId': noteId,'tagText': tagText}, false, function (msg) {
                    if (msg.status) {
                        $('#tag_container').append('<a class="tag_content" id="' + msg.info + '">' + tagText + '\n' +
                            '                            <img src="${ctx}/images/tag_remove.png" onclick="removeTag(this)"></a>')
                        $('#newTagInput').val("");
                    } else {
                        toastr.error('标签添加失败，可能已经重复');
                    }
                }, function (error) {
                    toastr.error('系统错误');
                })
            } else {
                toastr.warning("暂未选择笔记或标签内容为空");
            }
        });

        function removeTag(obj) {
            var tagId = obj.parentElement.id;
            var noteId = $("#affixNoteId").val();
            var $parent = obj.parentElement;
            if (tagId != "" && noteId != "") {
                sendPost('${ctx}/user/removeArticleTag',{'noteId':noteId,'tagId':tagId},false,function (msg) {
                    if(msg.status){
                        //删除标签
                        $parent.remove();
                    } else
                        toastr.error('删除标签失败！');
                },function (error) {
                    toastr.error('删除标签出错！');
                })
            }
        }
    </script>
</div>