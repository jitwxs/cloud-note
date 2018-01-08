var E = window.wangEditor
var editor = new E('#main')
editor.customConfig.onblur = function (html) {
    console.log('onblur', html)
}
editor.create()
/*var dirAttr = [
    {
        name:"一级目录1",
        id:"1",
        data:[
                {
                    name:"二级目录1",
                    id:"2",
                    data:[
                        {
                            name:"三级笔记1",
                            id:"3"
                        }
                    ]
                },
                {
                    name:"二级笔记1",
                    id:"2"
                }
            ]
    },
    {
        name:"一级目录2",
        id:"3",
        data:[
                {
                    name:"二级目录2",
                    data:[],
                }
            ]
    },
    {
        name:"一级笔记",
        id:"1"
    }
];*/
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
    {text:'重命名',onclick:renameNote},
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
    '            <a class="btn js_wjj_btn" index-id="_id"><img src="img/wjj3.png" width="20px" height="20px">_replace</a>\n' +
    '            <div class="wjj_div">\n' +
    '\n' +
    '            </div>\n' +
    '        </div>';
var dirTPL3 = '' +
    '<div><a class="btn js_note_btn" index-id="_id" style="margin-left: 20px">_replace</a><div>';

//    sendGet("",function (msg) {
//        if (msg.res){
//            dirAttr = msg.data;
//        }
//        else{
//            return false;
//        }
//    },function (error) {
//        alert("error");
//        return false;
//    });
showDir($('.wjj_div'),dirAttr);''
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
//        sendPost('',{'removeId':id},function (msg) {
//            if (!msg.res){alert("删除笔记失败！");return false}
//            else  $chooseDir.remove();
//        },function (error) {
//            alert("删除笔记出错了！");
//            return false;
//        });
    $chooseDir.remove();
}
function removeDir() {
    var $parent = $chooseDir.parent();
    var id = $chooseDir.attr('index-id');
    //发送要删除的目录的id
//        sendPost('',{'removeId':id},function (msg) {
//            if (!msg.res){alert("删除目录失败！");return false}
//            else   $parent.remove();
//        },function (error) {
//            alert("删除目录出错了！");
//            return false;
//        });
    $parent.remove();
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
//            sendPost('',{'parent':parent_id,'dirName':name},function (msg) {
//                if (!msg.res){alert("生成目录失败！");return false}
//                else return true;
//            },function (error) {
//                alert("出错了！");
//                return false;
//            });
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
//            sendPost('',{'parent':parent_id,'noteName':name},function (msg) {
//                if (!msg.res){alert("生成笔记失败！");return false}
//                else return true;
//            },function (error) {
//                alert("出错了！");
//                return false;
//            });
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
//            sendPost('',{'parent':parent_id,'dirName':name},function (msg) {
//                if (!msg.res){alert("生成目录失败！");return false}
//                else return true;
//            },function (error) {
//                alert("出错了！");
//                return false;
//            });

        //把文本框删掉
        var $parent = $('input[name=dir_name]').parent();
        $('input[name=dir_name]').remove();
        //生成目录
        $parent.prepend('<a class="btn js_wjj_btn" index-id="" ><img src="img/wjj3.png" width="20px" height="20px">'+ name+'</a>');
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
//            sendPost('',{'parent':parent_id,'noteName':name},function (msg) {
//                if (!msg.res){alert("生成笔记失败！");return false}
//                else return true;
//            },function (error) {
//                alert("出错了！");
//                return false;
//            });
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


//富文本区域的表单提交
function headlinePost() {
    var headline = $("#headline").val();
    var tag = $("#tag").val();
    $ajax({
        type:'post',
        url:'/fileInfo',
        dataType:'json',
        data: {
           'headline':headline,
           'tag':tag
        },
        success: function (msg) {
            if (msg == "保存成功") {
                toastr.success("保存成功！");
                flag = false;
            }

        },
        error: function (error) {
            toastr.warning("提交失败！请查看网络状态");
            flag = true;
        }

    });
    return flag;
}
/*!
 * classie - class helper functions
 * from bonzo https://github.com/ded/bonzo
 *
 * classie.has( elem, 'my-class' ) -> true/false
 * classie.add( elem, 'my-new-class' )
 * classie.remove( elem, 'my-unwanted-class' )
 * classie.toggle( elem, 'my-class' )
 */

/*jshint browser: true, strict: true, undef: true */

( function( window ) {

    'use strict';

// class helper functions from bonzo https://github.com/ded/bonzo

    function classReg( className ) {
        return new RegExp("(^|\\s+)" + className + "(\\s+|$)");
    }

// classList support for class management
// altho to be fair, the api sucks because it won't accept multiple classes at once
    var hasClass, addClass, removeClass;

    if ( 'classList' in document.documentElement ) {
        hasClass = function( elem, c ) {
            return elem.classList.contains( c );
        };
        addClass = function( elem, c ) {
            elem.classList.add( c );
        };
        removeClass = function( elem, c ) {
            elem.classList.remove( c );
        };
    }
    else {
        hasClass = function( elem, c ) {
            return classReg( c ).test( elem.className );
        };
        addClass = function( elem, c ) {
            if ( !hasClass( elem, c ) ) {
                elem.className = elem.className + ' ' + c;
            }
        };
        removeClass = function( elem, c ) {
            elem.className = elem.className.replace( classReg( c ), ' ' );
        };
    }

    function toggleClass( elem, c ) {
        var fn = hasClass( elem, c ) ? removeClass : addClass;
        fn( elem, c );
    }

    window.classie = {
        // full names
        hasClass: hasClass,
        addClass: addClass,
        removeClass: removeClass,
        toggleClass: toggleClass,
        // short names
        has: hasClass,
        add: addClass,
        remove: removeClass,
        toggle: toggleClass
    };

})( window );