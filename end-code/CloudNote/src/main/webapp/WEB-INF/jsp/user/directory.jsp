<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!--
如何获取笔记id和笔记name？
noteId、noteName即使页面刷新也不会置空，
正常判断使用：affixNoteId和editorTitle代替，这两个变量在页面刷新时会置空
-->
<div class="col-md-2">
    <div class="wjj">
        <a class="btn js_zwjj_btn" index-id="root"><img src="${ctx}/images/wjj2.png" width="15px" height="15px">
            我的文件夹</a>
        <div class="wjj_div">

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
            {text:'分享',onclick:shareNote}
        ]
    };
    var options3 = {items:[
            {text: '新建目录', onclick: createDir},
            {text: '新建笔记', onclick: createNote}
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
        '            <div class="wjj_div">\n' +
        '\n' +
        '            </div>\n' +
        '        </div>';
    var dirTPL3 = '' +
        '<div><a class="btn js_note_btn" index-id="_id" style="margin-left: 20px">_replace</a><div>';

    sendGet('${ctx}/user/initDirectory', {}, false, function (msg) {
        dirAttr = msg.data;
    }, function (error) {
        alert("删除笔记出错了！");
        return false;
    });

    showDir($('.wjj_div'), dirAttr);

    function showDir($item, dir) {
        for (var i = 0; i < dir.length; i++) {
            var name = dir[i].name;
            var _id = dir[i].id;
            //如果为目录
            if (dir[i].data != null) {
                var tempTPL = dirTPL2.replace(/_replace/, name);
                tempTPL = tempTPL.replace(/_id/, _id);
                $item.append(tempTPL);
                var data = dir[i].data;
                if (data != []) {
                    var $last = $('.wjj_div');
                    showDir($last.last(), data);
                }
            } else {// 如果为笔记
                var tempTPL = dirTPL3.replace(/_replace/, name);
                tempTPL = tempTPL.replace(/_id/, _id);
                $item.append(tempTPL);
            }
        }
    }

    initUI();

    function createDir() {
        var $choosenId = $chooseDir;
        var $brother = $choosenId.next();
        $brother.prepend(dirTPL);
        $('input[name=dir_name]').select();
        initUI();
    }

    function createNote() {
        var $choosenId = $chooseDir;
        var $brother = $choosenId.next();
        $brother.append(dirTPL1);
        $('input[name=note_name]').select();
        initUI();
    }

    function removeNote() {
        var $choosenId = $chooseDir;
        var id = $choosenId.attr('index-id');

        var msg = "删除笔记后笔记将被丢入垃圾桶，确认不考虑下(ｏ ‵-′)ノ";
        if (confirm(msg)){
            //发送要删除的笔记的id
            sendPost('${ctx}/user/removeNote', {'noteId': id}, false, function (msg) {
                if (!msg.status) {
                    toastr.error("删除笔记失败");
                    return false;
                } else {
                    $choosenId.remove();
                    toastr.success("笔记已删除");
                }
            }, function (error) {
                toastr.error("系统错误");
                return false;
            });
        } else {
            return true;
        }
    }

    function removeDir() {
        var $choosenId = $chooseDir;
        var $parent = $choosenId.parent();
        var id = $choosenId.attr('index-id');

        var msg = "删除目录后笔记将被归入上层文件夹，真的要 (￢_￢)ﾉ？";
        if (confirm(msg)){
            //发送要删除的目录的id
            sendPost('${ctx}/user/removeDir', {'dirId': id}, false, function (msg) {
                if (!msg.status) {
                    toastr.error("删除目录失败");
                    return false;
                } else {
                    $parent.remove();
                }
            }, function (error) {
                toastr.error("内部错误");
                return false;
            });
            location.reload(true);
        }else{
            return false;
        }
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
            //发送给服务器
            sendPost('${ctx}/user/renameDir', {'dirId': dirId, 'dirName': name}, false, function (msg) {
                if (!msg.status) {
                    toastr.error("生成目录失败");
                    return false
                }
                else return true;
            }, function (error) {
                toastr.error("系统错误");
                return false;
            });
            var $parent = $('input[name=dir_name]').parent();
            $('input[name=dir_name]').remove();
            //生成目录
            $parent.prepend('<a class="btn js_wjj_btn" index-id="" >' + name + '</a>');
            initUI();
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
            //发送给服务器
            sendPost('${ctx}/user/renameNote', {'noteId': noteId, 'noteName': name}, false, function (msg) {
                if (!msg.status) {
                    toastr.error("生成笔记失败");
                    return false;
                }
                else return true;
            }, function (error) {
                toastr.error("系统错误");
                return false;
            });
            //把文本框删掉
            var $parent = $('input[name=note_name]').parent();
            $('input[name=note_name]').remove();
            //生成笔记
            $parent.prepend('<a class="btn js_note_btn" index-id="">' + name + '</a>');
            initUI();
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
        var id = $choosenId.attr('index-id');
        var name = $choosenId.text();
        //发送要分享的笔记的id和name
        sendPost('${ctx}/user/shareNote', {'noteId': id,'noteName':name}, true, function (msg) {
            if (!msg.status) {
                toastr.error("分享笔记失败");
                return false;
            } else {
                $("#shareUrl").val(msg.info);
                $("#noteId").val(msg.noteId);
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
            $("#noteId").val(noteId);
            $("#noteName").val(noteName);
            // 添加标签内容
            $("#editorTags").val("");
            for(var i=0; i < msg.noteTag.length; i++) {
                $("#editorTags").val($("#editorTags").val() + msg.noteTag[i].name + " ");
            }

            var affixInfo = "";
            // 添加附件信息
            for(var i=0; i< msg.affixes.length; i++) {
                affixInfo += '<div id="' + msg.affixes[i].id  + '">' + msg.affixes[i].name + "" +
                    '<button onclick="previewAffix(this)">预览</button>' +  '<button onclick="deleteAffix(this)">删除</button>' + '</div>';
            }
            $("#affixContent").html(affixInfo);

            // 恢复笔记内容
            editor.txt.html(msg.info);
        }, function (error) {
            toastr.error("内部错误");
            return false;
        });
    }

    function initUI() {
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
            //发送给服务器
            sendPost('${ctx}/user/createDir', {'parentId': parent_id, 'dirName': name}, false, function (msg) {
                if (!msg.status) {
                    toastr.error("创建目录失败");
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

        });

        //生成笔记
        $(".js_note_btn").bind("contextmenu", function () {
            //记录右键点击的元素
            $chooseDir = $(this);
        });
        $('.js_note_btn').contextify(options2);
        /*失去焦点事件*/
        $('input[name=note_name]').blur(function () {
            //获取名字
            var name = $('input[name=note_name]').val();
            var parent_id = $chooseDir.attr('index-id');
            //发送给服务器
            sendPost('${ctx}/user/createNote', {'parentId': parent_id, 'noteName': name}, false, function (msg) {
                if (!msg.status) {
                    toastr.error("创建笔记失败");
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
                alert("内部错误");
                return false;
            });
        });

        //实现目录收放
        $('.js_wjj_btn').on("click", function () {
            var $this = $(this);
            var $brother = $this.next();
            if ($brother.hasClass("hidden")) {
                $brother.removeClass("hidden");
            } else {
                $brother.addClass("hidden");
            }
        });
        //实现目录收放
        $('.js_zwjj_btn').on("click", function () {
            var $this = $(this);
            var $brother = $this.next();
            if ($brother.hasClass("hidden")) {
                $brother.removeClass("hidden");
            } else {
                $brother.addClass("hidden");
            }
        });

        // 笔记的左击查看功能
        $('.js_note_btn').on("click", function () {
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