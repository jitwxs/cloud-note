<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<div class="col-md-2">
    <div class="wjj">
        <a class="btn js_wjj_btn"><img src="${ctx}/images/wjj2.png" width="15px" height="15px"> 我的文件夹</a>
        <div class="wjj_div">

        </div>
    </div>
</div>

<script>
    /*var dirAttr= [
        {
            "data": [
                {
                    "data": [],
                    "id": "a9eff09ae43b476996cff1cscqca04c3",
                    "name": "文章一"
                },
                {
                    "data": [
                        {
                            "data": [],
                            "id": "a9eff09ae43b476996cff1chwqca04c3",
                            "name": "文章二"
                        }
                    ],
                    "id": "rteff09ae43b476996cff1csh9ca04c3",
                    "name": "jitwxs子文件夹一"
                }
            ],
            "id": "a9eff09ae43b476996cff193c9ca04c3",
            "name": "jitwxs文件夹一"
        },
        {
            "data": [],
            "id": "a9eff09ae43b476996cff1csh9ca04c3",
            "name": "jitwxs文件夹二"
        }
    ]*/

    /*一些全局变量*/
    //当前点击的目录
    var $chooseDir = null;
    var dirAttr = [];
    var options1 = {items:[
            {text: '新建目录', onclick: createDir},
            {text: '新建笔记', onclick: createNote},
            {text:'删除',onclick: removeDir},
            {text:'重命名',onclick:renameDir}
        ]};
    var options2 = {items:[
            {text:'删除',onclick: removeNote},
            {text:'重命名',onclick:renameNote}
        ]};
    var dirTPL = '' +
        '              <div class="wjj">\n' +
        '                    <input type="text" name="dir_name" value="新建文件夹">' +
        '                    <div class="wjj_div" >\n' +
        '                    </div>\n' +
        '                </div>';

    var dirTPL1 = ''+'<div><input type="text" name="note_name" value="新建笔记" ></div>'

    var dirTPL2 = '' +
        '        <div class="wjj">\n' +
        '            <a class="btn js_wjj_btn" index-id="_id"><img src="${ctx}/images/wjj3.png" width="20px" height="20px">_replace</a>\n' +
        '            <div class="wjj_div">\n' +
        '\n' +
        '            </div>\n' +
        '        </div>';
    var dirTPL3 = '' +
        '<div><a class="btn js_note_btn" index-id="_id" style="margin-left: 20px">_replace</a><div>';

    sendGet('${ctx}/user/initDirectory',{},false,function (msg) {
        dirAttr = msg.data;
    },function (error) {
        alert("删除笔记出错了！");
        return false;
    });

    showDir($('.wjj_div'),dirAttr);
    function showDir($item,dir) {
        for (var i = 0 ;i < dir.length; i++){
            var name = dir[i].name;
            var _id = dir[i].id;
            //如果为目录
            if(dir[i].data != null){
                var tempTPL = dirTPL2.replace(/_replace/,name);
                tempTPL = tempTPL.replace(/_id/,_id);
                $item.append(tempTPL);
                var data = dir[i].data;
                if(data != []){
                    var $last = $('.wjj_div');
                    showDir($last.last() ,data);
                }
            }else{// 如果为笔记
                var tempTPL = dirTPL3.replace(/_replace/,name);
                tempTPL = tempTPL.replace(/_id/,_id);
                $item.append(tempTPL);
            }
        }

    }

    initUI();
    function createDir() {
        var $brother = $chooseDir.next();
        $brother.prepend(dirTPL);
        $('input[name=dir_name]').select();
        initUI();
    }
    function createNote() {
        var $brother = $chooseDir.next();
        $brother.append(dirTPL1);
        $('input[name=note_name]').select();
        initUI();
    }
    function removeNote() {
        var id = $chooseDir.attr('index-id');
        //发送要删除的笔记的id
        sendPost('',{'removeId':id},false,function (msg) {
            if (!msg.res){alert("删除笔记失败！");return false}
            else  $chooseDir.remove();
        },function (error) {
            alert("删除笔记出错了！");
            return false;
        });
    }
    function removeDir() {
        var $parent = $chooseDir.parent();
        var id = $chooseDir.attr('index-id');
        //发送要删除的目录的id
        sendPost('',{'removeId':id},false,function (msg) {
            if (!msg.res){alert("删除目录失败！");return false}
            else   $parent.remove();
        },function (error) {
            alert("删除目录出错了！");
            return false;
        });
    }
    function renameDir() {
        var dirname = $chooseDir.text();
        var $parent = $chooseDir.parent();
        $chooseDir.remove();
        var str = '<input type="text" name="dir_name" value="'+dirname+'">';
        $parent.prepend(str);
        $('input[name=dir_name]').select();
        /*失去焦点事件*/
        $('input[name=dir_name]').blur(function(){
            //获取名字
            var name = $('input[name=dir_name]').val();
            //发送给服务器
            sendPost('',{'parent':parent_id,'dirName':name},false,function (msg) {
                if (!msg.res){alert("生成目录失败！");return false}
                else return true;
            },function (error) {
                alert("出错了！");
                return false;
            });
            var $parent = $('input[name=dir_name]').parent();
            $('input[name=dir_name]').remove();
            //生成目录
            $parent.prepend('<a class="btn js_wjj_btn" index-id="" >'+name+'</a>');
            initUI();
        })
    }
    function renameNote() {
        var notename = $chooseDir.text();
        console.log(notename)
        var $parent = $chooseDir.parent();
        $chooseDir.remove();
        var str = '<input type="text" name="note_name" value="'+notename+'">';
        $parent.append(str);
        $('input[name=note_name]').select();
        /*失去焦点事件*/
        $('input[name=note_name]').blur(function(){
            //获取名字
            var name = $('input[name=note_name]').val();
            //发送给服务器
            sendPost('',{'parent':parent_id,'noteName':name},false,function (msg) {
                if (!msg.res){alert("生成笔记失败！");return false}
                else return true;
            },function (error) {
                alert("出错了！");
                return false;
            });
            //把文本框删掉
            var $parent = $('input[name=note_name]').parent();
            $('input[name=note_name]').remove();
            //生成笔记
            $parent.prepend('<a class="btn js_note_btn" index-id="">'+name+'</a>');
            initUI();
        });
    }

    function initUI() {

        //生成目录
        $(".js_wjj_btn").bind("contextmenu", function(){
            //记录右键点击的元素
            $chooseDir = $(this);

            var $brother = $chooseDir.next();
            $brother.removeClass("hidden");
        });
        $('.js_wjj_btn').contextify(options1);
        /*失去焦点事件*/
        $('input[name=dir_name]').blur(function(){
            //获取名字
            var name = $('input[name=dir_name]').val();
            var parent_id = $chooseDir.attr('index-id');
            //发送给服务器
            sendPost('',{'parent':parent_id,'dirName':name},false,function (msg) {
                if (!msg.res){alert("生成目录失败！");return false}
                else return true;
            },function (error) {
                alert("出错了！");
                return false;
            });

            //把文本框删掉
            var $parent = $('input[name=dir_name]').parent();
            $('input[name=dir_name]').remove();
            //生成目录
            $parent.prepend('<a class="btn js_wjj_btn" index-id="" ><img src="${ctx}/images/wjj3.png" width="20px" height="20px">'+ name+'</a>');
            initUI();
        })


        //生成笔记
        $(".js_note_btn").bind("contextmenu", function(){
            //记录右键点击的元素
            $chooseDir = $(this);
        });
        $('.js_note_btn').contextify(options2);
        /*失去焦点事件*/
        $('input[name=note_name]').blur(function(){
            //获取名字
            var name = $('input[name=note_name]').val();
            var parent_id = $chooseDir.attr('index-id');
            //发送给服务器
            sendPost('',{'parent':parent_id,'noteName':name},false,function (msg) {
                if (!msg.res){alert("生成笔记失败！");return false}
                else return true;
            },function (error) {
                alert("出错了！");
                return false;
            });
            //把文本框删掉
            var $parent = $('input[name=note_name]').parent();
            $('input[name=note_name]').remove();
            //生成笔记
            $parent.prepend('<a class="btn js_note_btn" index-id="" style="margin-left: 20px">'+name+'</a>');
            initUI();
        });

        //实现目录收放
        $('.js_wjj_btn').on("click",function () {
            var $this = $(this);
            var $brother = $this.next();
            if ($brother.hasClass("hidden")){
                $brother.removeClass("hidden");
            }else {
                $brother.addClass("hidden");
            }
        });
    }

</script>