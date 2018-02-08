<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<%--
如何获取笔记id和笔记name？
noteId、noteName即使页面刷新也不会置空，
正常判断使用：affixNoteId和editorTitle代替，这两个变量在页面刷新时会置空
--%>
<style>
    .wjj_div{
        margin-left: 10px;
    }
    .wjj_div_move{
        margin-left: 10px;
    }
    .js_wjj_move{
        cursor: pointer;
    }
    .js_wjj_move:hover{
        text-decoration: none;
    }
    .default{
        color: #337AB7;
    }
    .checked{
        color: grey;
    }
</style>

<div class="col-md-2" style="overflow: hidden">
    <div class="wjj" >
        <a class="btn js_zwjj_btn" index-id="root"><img src="${ctx}/images/wjj2.png" width="15px" height="15px">
            我的文件夹</a>
        <div class="wjj_div hidden" style="">

        </div>
    </div>

    <div id="div_rubbish" style="margin-top: 20px;">
        <a id="rubbish" style="cursor: pointer;height: 20px;font-size: 15px;color: #337ab7;display:block;margin-left:14px;text-decoration: none">
            <img src="${ctx}/images/rubbish.png" style="width: 20px;height: 20px;">回收站</a>
        <div id="rubbish_container" class="hidden">
        </div>
    </div>
</div>

<script>
    /*一些全局变量*/
    //当前点击的目录
    var $chooseDir = null;
    var dirAttr = [];
    var options1 = {
        items: [
            {text: '新建目录', onclick: createDir},
            {text: '新建笔记', onclick: createNote},
            {text: '删除', onclick: removeDir},
            {text: '重命名', onclick: renameDir}
        ]
    };
    var options2 = {
        items: [
            {text: '删除', onclick: removeNote},
            {text: '重命名', onclick: renameNote},
            {text: '下载', onclick: noteDownload},
            {text:'分享',onclick:shareNote},
            {text:'移动到...',onclick:moveNote}
        ]
    };
    var options3 = {items:[
            {text: '新建目录', onclick: createDir},
            {text: '新建笔记', onclick: createNote},
            {text:'上传笔记',onclick:uploadNote}
        ]};

    var options4 = {items:[
            {text: '还原', onclick: recycle},
            {text: '彻底删除', onclick: forever_remove}
        ]};

    var options5 = {items:[
            {text: '清空回收站', onclick: clearRubbish}
        ]};

    var dirTPL = '' +
        '              <div class="wjj">\n' +
        '                    <input type="text" name="dir_name" value="新建文件夹">' +
        '                    <div class="wjj_div" >\n' +
        '                    </div>\n' +
        '                </div>';

    var dirTPL1 = '' + '<div><input type="text" name="note_name" value="新建笔记" ></div>';

    var dirTPL2 = '' +
        '        <div class="wjj">\n' +
        '            <a class="btn js_wjj_btn" index-id="_id"><img src="${ctx}/images/wjj3.png" width="20px" height="20px">_replace</a>\n' +
        '            <div class="wjj_div hidden">\n' +
        '\n' +
        '            </div>\n' +
        '        </div>';
    var dirTPL3 = '' +
        '<div><a class="btn js_note_btn" index-id="_id" style="margin-left: 20px">_replace</a><div>';

    var dirTPL4 = '' +
        '        <div class="wjj">\n' +
        '            <a class="js_wjj_move" index-id="_id"><img src="${ctx}/images/wjj3.png" width="20px" height="20px">_replace</a>\n' +
        '            <div class="wjj_div_move">\n' +
        '\n' +
        '            </div>\n' +
        '        </div>';
    var $chooseMove = null;
    sendGet('${ctx}/user/initArticleDir', {}, false, function (msg) {
        dirAttr = msg.data;
    }, function (error) {
        toastr.error("初始化笔记错误");
        return false;
    });

    //实现主目录收放
    $('.js_zwjj_btn').on("click", function () {
        var $this = $(this);
        var $brother = $this.next();
        if ($brother.hasClass("hidden")) {
            $brother.removeClass("hidden");
        } else {
            $brother.addClass("hidden");
        }
    });

    // 回收站的点击事件
    $('#rubbish').on('click',function () {
        //点击收起下面的文件
        if ($('#rubbish_container').hasClass('hidden')){
            $('#rubbish_container').removeClass('hidden')
        } else {
            $('#rubbish_container').addClass('hidden')
        }
    });

    //回收站的右击绑定事件
    $('#rubbish').bind("contextmenu",function () {
    });
    $('#rubbish').contextify(options5);

    showDir($('.wjj_div'), dirAttr);
    showRubbish();
    initUI();

    function showDir($item, dir) {
        for (var i = 0; i < dir.length; i++) {
            var name = dir[i].name;
            var _id = dir[i].id;
            //如果为目录
            if (dir[i].data != null) {
                var tempTPL = dirTPL2.replace(/_replace/, name);
                tempTPL = tempTPL.replace(/_id/, _id);
                $item.prepend(tempTPL);
                var data = dir[i].data;
                if (data != []) {
                    var $div = $("a[index-id="+_id+"]").next();
                    showDir($div, data);
                }
            } else {// 如果为笔记
                var tempTPL = dirTPL3.replace(/_replace/, name);
                tempTPL = tempTPL.replace(/_id/, _id);
                $item.append(tempTPL);
            }
        }
    }

    function showMove($item, dir) {
        for (var i = 0; i < dir.length; i++) {
            var name = dir[i].name;
            var _id = dir[i].id;
            //如果为目录
            if (dir[i].data != null) {
                var tempTPL = dirTPL4.replace(/_replace/, name);
                tempTPL = tempTPL.replace(/_id/, _id);
                $item.prepend(tempTPL);
                var data = dir[i].data;
                if (data != []) {
                    var $last = $('.wjj_div_move');
                    showMove($last.last(), data);
                }
            }
        }
    }

    function showRubbish() {
        //从服务器获取数据
        sendGet('${ctx}/user/initRecycleFile',{}, false, function (res) {
            //在rubbish——container追加文件
            for(var i=0; i<res.length; i++) {
                $('#rubbish_container').append('<div class="notediv" >\n' +
                    '            <a class="rubbish_file" index-id="'+res[i].id+'">'+res[i].title+'</a>\n' +
                    '        </div>\n');
            }
            return true;
        },function (error) {
            toastr.error("出错了！");
            return false;
        });
    }

    function recycle() {
        var id = $chooseDir.attr('index-id');
        var $parent = $chooseDir.parent();
        sendPost('${ctx}/user/recycleNote',{'noteId':id}, true, function (msg) {
            if (msg.status) {
                //删除这个笔记在回收站的位置
                $parent.remove();
                var dirId = msg.info;
                //寻找他的父目录所在的div
                var $initparent = $("a[index-id$="+dirId+"]").next();
                //在原父目录尾追加文件
                $initparent.append('<div><a class="btn js_note_btn" index-id="'+id+'" style="margin-left:20px">'+msg.name+'</a><div>');
                initUI();
                toastr.success("笔记已还原");
            } else {
                toastr.error("还原失败");
            }
        },function (error) {
            toastr.error("系统错误");
            return false;
        });
    }

    function forever_remove() {
        var dblChoseAlert = simpleAlert({
            "content": "从回收站中删除将无法恢复，确认删除吗",
            "buttons": {
                "确定": function () {
                    var id = $chooseDir.attr('index-id');
                    var $parent = $chooseDir.parent();
                    sendPost('${ctx}/user/foreverRemoveNote',{'noteId':id}, true, function (msg) {
                        if (msg.status) {
                            //删除这个笔记在回收站的位置
                            $parent.remove();
                            toastr.success("笔记已彻底删除");
                        } else {
                            toastr.error("删除失败");
                        }
                    },function (error) {
                        toastr.error("系统错误");
                        return false;
                    });
                    initUI();
                    dblChoseAlert.close();
                },
                "取消": function () {
                    dblChoseAlert.close();
                }
            }
        })
    }

    function createDir() {
        var $choosenId = $chooseDir;
        var $brother = $choosenId.next();
        $brother.append(dirTPL);
        $('input[name=dir_name]').select();
        initUI();
    }

    function createNote() {
        var $choosenId = $chooseDir;
        var $brother = $choosenId.next();
        $brother.prepend(dirTPL1);
        $('input[name=note_name]').select();
        initUI();
    }

    // 上传笔记
    function uploadNote() {
        $("#uploadNoteName").html('');
        $('#uploadNoteModal').modal('show');
    }

    function removeNote() {
        var $choosenId = $chooseDir;
        var id = $choosenId.attr('index-id');
        var name = $choosenId.text();
        var dblChoseAlert = simpleAlert({
            "content": "删除笔记后笔记将被丢入垃圾桶，确认删除？",
            "buttons": {
                "确定": function () {
                    //发送要删除的笔记的id
                    sendPost('${ctx}/user/removeNote', {'noteId': id}, false, function (msg) {
                        if (!msg.status) {
                            toastr.error("删除笔记失败");
                            return false;
                        } else {
                            $choosenId.remove();
                            toastr.success("笔记已删除");
                            $('#rubbish_container').append('<div class="notediv">\n' +
                                '            <a class="rubbish_file" index-id="'+id+'">'+name+'</a>\n' +
                                '        </div>\n');
                            initUI();
                        }
                    }, function (error) {
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

    function removeDir() {
        var $choosenId = $chooseDir;
        var $parent = $choosenId.parent();
        var id = $choosenId.attr('index-id');
        var dblChoseAlert = simpleAlert({
            "content": "删除目录后笔记将被归入上层文件夹，确认删除？",
            "buttons": {
                "确定": function () {
                    //发送要删除的目录的id
                    sendPost('${ctx}/user/removeDir', {'dirId': id}, false, function (msg) {
                        if (!msg.status) {
                            toastr.error("删除目录失败");
                            initUI();
                            return false;
                        } else {
                            $parent.remove();
                        }
                    }, function (error) {
                        toastr.error("内部错误");
                        return false;
                    });
                    location.reload(true);
                    dblChoseAlert.close();
                },
                "取消": function () {
                    dblChoseAlert.close();
                }
            }
        })
    }

    function renameDir() {
        var dirname = $chooseDir.text();
        var $parent = $chooseDir.parent();
        var dirId = $chooseDir.attr("index-id");
        $chooseDir.remove();
        var str = '<input type="text" name="dir_name" value="' + dirname + '">';
        $parent.prepend(str);
        $('input[name=dir_name]').select();
        /*失去焦点事件*/
        $('input[name=dir_name]').blur(function () {
            //获取名字
            var name = $('input[name=dir_name]').val();
            if(name == "" || name == null) {
                toastr.warning("目录名不能为空");
            } else {
                //发送给服务器
                sendPost('${ctx}/user/renameDir', {'dirId': dirId, 'dirName': name}, false, function (msg) {
                    if (!msg.status) {
                        toastr.warning(msg.info);
                        return false
                    }
                    else{
                        var $parent = $('input[name=dir_name]').parent();
                        $('input[name=dir_name]').remove();
                        //生成目录
                        $parent.prepend('<a class="btn js_wjj_btn" index-id="'+dirId+'" ><img src="${ctx}/images/wjj3.png" width="20px" height="20px">' + name + '</a>');
                        initUI();
                        return true;
                    }
                }, function (error) {
                    toastr.error("系统错误");
                    return false;
                });

            }

        })
    }

    function renameNote() {
        var notename = $chooseDir.text();
        var $parent = $chooseDir.parent();
        $chooseDir.remove();
        var noteId = $chooseDir.attr("index-id");
        var str = '<input type="text" name="note_name" value="' + notename + '">';
        $parent.append(str);
        $('input[name=note_name]').select();
        /*失去焦点事件*/
        $('input[name=note_name]').blur(function () {
            //获取名字
            var name = $('input[name=note_name]').val();
            if(name == null || name == "") {
                toastr.warning("笔记名不能为空");
            } else {
                //发送给服务器
                sendPost('${ctx}/user/renameNote', {'noteId': noteId, 'noteName': name}, false, function (msg) {
                    if (!msg.status) {
                        toastr.warning(msg.info);
                        return false;
                    } else {
                        //把文本框删掉
                        var $parent = $('input[name=note_name]').parent();
                        $('input[name=note_name]').remove();
                        //生成笔记
                        $parent.prepend('<a style="margin-left: 20px" class="btn js_note_btn" index-id="'+noteId+'">' + name + '</a>');
                        $('#editorTitle').val(name);
                        initUI();
                        return true;
                    }
                }, function (error) {
                    toastr.error("系统错误");
                    return false;
                });

            }
        });
    }

    // 笔记的右击下载功能
    function noteDownload() {
        var id = $chooseDir.attr('index-id');
        var name = $chooseDir.text();
        var url = "${ctx}/user/downloadNote?noteId=" + id + "&noteName=" + name;
        window.location.href = url;
    }

    //笔记的右击分享功能
    function shareNote() {
        var $choosenId = $chooseDir;
        var noteId = $choosenId.attr('index-id');
        var noteName = $choosenId.text();
        //发送要分享的笔记的id
        sendPost('${ctx}/user/shareNote', {'noteId': noteId}, true, function (msg) {
            if (!msg.status) {
                toastr.error("分享笔记失败");
                return false;
            } else {
                $("#shareUrl").val(msg.info);
                $("#sharePic").val(msg.name);
                $("#shareId").val(noteId);
                $("#shareName").val(noteName);
                $('#shareNoteModal').modal('show');
                return true;
            }
        }, function (error) {
            toastr.error("系统错误");
            return false;
        });
    }

    function flushNote(noteId, noteName) {
        sendPost('${ctx}/user/recoverNote', {'noteId': noteId, "noteName": noteName}, true, function (msg) {
            if(msg.status) {
                $("#noteId").val(noteId);
                $("#noteName").val(noteName);

                //添加标签
                $("#newTagInput").val("");
                $('#tag_container').html("");
                for(var i=0; i < msg.noteTag.length; i++) {
                    $('#tag_container').append('<a class="tag_content" id="'+msg.noteTag[i].id+'">'+msg.noteTag[i].name+'\n' +
                        '                            <img src="${ctx}/images/tag_remove.png" onclick="removeTag(this)"></a>')
                }

                // 添加附件信息
                var affixInfo = "";
                for(var i=0; i< msg.affixes.length; i++) {
                    affixInfo += '<tr id="'+msg.affixes[i].id+'">\n' +
                        '            <td>'+msg.affixes[i].name+'</td>\n' +
                        '            <td><button class="btn btn-info btn-sm" onclick="previewAffix(this)" value="'+msg.affixes[i].name+'">预览</button></td>\n' +
                        '            <td><button class="btn btn-danger btn-sm" onclick="deleteAffix(this)">删除</button></td>\n' +
                        '            </tr>';
                }
                $("#affixContentTBody").html(affixInfo);

                // 恢复笔记内容
                editor.txt.html(msg.info);
            } else {
                toastr.error("获取笔记内容是失败");
            }
        }, function (error) {
            toastr.error("内部错误");
            return false;
        });
    }

    //清空回收站事件
    function clearRubbish() {
        var dblChoseAlert = simpleAlert({
            "content": "确定要清空回收站吗？",
            "buttons": {
                "确定": function () {
                    sendGet('${ctx}/user/clearRubbish',{},false,function (res) {
                        if(res.status) {
                            $('#rubbish_container').children().remove();
                            toastr.success("清空成功");
                        } else {
                            toastr.error("清空失败");
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

    //模态框出现函数
    function moveNote() {
        $('.wjj_div_move').children().remove();
        sendGet('${ctx}/user/initMoveArticleDir', {}, false, function (msg) {
            dir = msg.data;
            showMove($('.wjj_div_move'),dir);
            $('#noteMoveToModel').modal('show');
            initUI();
        }, function (error) {
            toastr.error("初始化笔记错误");
            return false;
        });

    }

    function initUI() {
        // 模态框文件夹的焦点事件
        $('.js_wjj_move').off('click').on('click',function () {
            $chooseMove = $(this);
            var dirid = $chooseMove.attr('index-id');
            $('#dirId').val(dirid);
            $('.js_wjj_move').addClass("default").removeClass("checked");
            $('.js_zwjj_move').addClass("default").removeClass("checked");
            $(this).addClass("checked").removeClass("default");
        })

        $('.js_zwjj_move').off('click').on('click',function () {
            $chooseMove = $(this);
            var dirid = $chooseMove.attr('index-id');
            $('#dirId').val(dirid);
            $('.js_wjj_move').addClass("default").removeClass("checked");
            $(this).addClass("checked").removeClass("default");
        })


        //回收站文件的右击事件
        $('.rubbish_file').bind("contextmenu",function () {
            //记录右键点击的元素
            $chooseDir = $(this);

        });
        $('.rubbish_file').contextify(options4);


        $(".js_zwjj_btn").bind("contextmenu", function(){
            //记录右键点击的元素
            $chooseDir = $(this);
            var $brother = $chooseDir.next();
            $brother.removeClass("hidden");
        });
        $('.js_zwjj_btn').contextify(options3);

        //生成目录
        $(".js_wjj_btn").bind("contextmenu", function () {
            //记录右键点击的元素
            $chooseDir = $(this);
            var $brother = $chooseDir.next();
            $brother.removeClass("hidden");
        });
        $('.js_wjj_btn').contextify(options1);
        /*失去焦点事件*/
        $('input[name=dir_name]').blur(function () {
            //获取名字
            var name = $('input[name=dir_name]').val();
            var parent_id = $chooseDir.attr('index-id');
            if(name == null || name == "") {
                toastr.warning("目录名不能为空");
            } else {
                //发送给服务器
                sendPost('${ctx}/user/createDir', {'parentId': parent_id, 'dirName': name}, false, function (msg) {
                    if (!msg.status) {
                        toastr.warning(msg.info);
                        return false;
                    }
                    else {
                        //把文本框删掉
                        var $parent = $('input[name=dir_name]').parent();
                        $('input[name=dir_name]').remove();
                        //生成目录
                        $parent.prepend('<a class="btn js_wjj_btn" index-id="'+msg.dirId+'" ><img src="${ctx}/images/wjj3.png" width="20px" height="20px">' + name + '</a>');
                        initUI();
                    }
                }, function (error) {
                    toastr.error("系统错误");
                    return false;
                });
            }
        });

        //生成笔记
        $(".js_note_btn").bind("contextmenu", function () {
            //记录右键点击的元素
            $chooseDir = $(this);
            var noteid = $chooseDir.attr('index-id');
            $('#noteId').val(noteid);
        });
        $('.js_note_btn').contextify(options2);
        /*失去焦点事件*/
        $('input[name=note_name]').blur(function () {
            //获取名字
            var name = $('input[name=note_name]').val();
            if(name == null || name == "") {
                toastr.warning("笔记名不能为空");
            } else {
                var parent_id = $chooseDir.attr('index-id');
                //发送给服务器
                sendPost('${ctx}/user/createNote', {'parentId': parent_id, 'noteName': name}, false, function (msg) {
                    if (!msg.status) {
                        toastr.warning(msg.info);
                        return false;
                    } else  {
                        //把文本框删掉
                        var $parent = $('input[name=note_name]').parent();
                        $('input[name=note_name]').remove();
                        //生成笔记
                        $parent.prepend('<a class="btn js_note_btn" index-id="'+msg.noteId+'" style="margin-left: 20px">' + name + '</a>');
                        initUI();
                    }
                }, function () {
                    toastr.error("系统错误");
                    return false;
                });
            }
        });

        //实现目录收放
        $('.js_wjj_btn').off('click').on("click", function () {
            var $brother = $(this).next();
            if ($brother.hasClass("hidden")) {
                $brother.removeClass("hidden");
            } else {
                $brother.addClass("hidden");
            }
        });


        // 笔记的左击查看功能
        $('.js_note_btn').off('click').on("click", function () {
            var $this = $(this);
            var noteId = $this.attr('index-id');
            var noteName = $this.text();
            $("#editorTitle").val(noteName);
            $("#affixNoteId").val(noteId);

            flushNote(noteId, noteName);
        });


        window.onunload = function () {
            $("#editorTitle").val("");
            $("#affixNoteId").val("");
            $("#editorTags").val("");
        }
    }
</script>