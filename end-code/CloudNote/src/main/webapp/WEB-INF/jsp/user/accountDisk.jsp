<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<%-- 引入头部 --%>
<jsp:include page="settingHead.jsp"/>

<body>
<div class="container">
    <div id="wangpan">
        <!--头部导航-->
        <div id="head" >
            <form id="uploadForm">
                <a class="upload">
                    <img src="${ctx}/images/uploadfile.png">
                    上传文件
                    <input type="file">
                </a>
            </form>
            <a class="btn" id="xj-wjj-btn" ><img src="${ctx}/images/newfile.png"> 新建文件夹</a>
            <input style="width: 245px;height: 35px;float: left;margin-left: 240px;margin-top:7px;" type="text" class="form-control"placeholder="搜索您的文件" />
            <span class="input-group-btn">
               <button class="btn btn-info btn-search" style="float:left;margin-left: 5px;margin-top:7px;">查找</button>
            </span>
        </div>
        <ol class="breadcrumb">
        </ol>
        <hr style="margin: 0;">
        <!--文件放置-->
        <div id="content">
            <div class="neirong">
                <%--<div class="wjj">--%>
                    <%--<a class="js-wjj js-btn" index-id="1"><img src="${ctx}/images/wjj4.png">我的文件夹</a>--%>
                <%--</div>--%>
                <%--<div class="wj">--%>
                    <%--<a class="js-wj js-btn " index-id="2"><img src="${ctx}/images/file.png">我的文件</a>--%>
                <%--</div>--%>
            </div>
        </div>
    </div>
</div>

<script>
    //    全局变量
    var dirAttr = [];
    //当前右击的元素
    var $chooseDir = null;

    var dirTPL1 = '<div class="wjj">\n' +
        '                    <a class="js-wjj js-btn" index-id="_id"><img src="${ctx}/images/wjj4.png">_replace</a>\n' +
        '                </div>';

    var dirTPL2 = '<div class="wj">\n' +
        '                    <a class="js-wj js-btn " index-id="_id"><img src="${ctx}/images/file.png">_replace</a>\n' +
        '                </div>';
    //    //测试数据
    //    var test =''+ '<div class="neirong ">\n' +
    //        '                <div class="wjj">\n' +
    //        '                    <a class="js-wjj js-btn test1"  index-id="3"><img src="${ctx}/images/wjj4.png">子文件夹1</a>\n' +
    //        '                </div>\n' +
    //        '                <div class="wj">\n' +
    //        '                    <a class="js-wj js-btn" index-id="4"><img src="${ctx}/images/file.png">我的文件1</a>\n' +
    //        '                </div>\n' +
    //        '            </div>';
    //    var test2 =''+ '<div class="neirong ">\n' +
    //        '                <div class="wjj">\n' +
    //        '                    <a class="js-wjj js-btn" index-id="5"><img src="${ctx}/images/wjj4.png">子文件夹2</a>\n' +
    //        '                </div>\n' +
    //        '                <div class="wj">\n' +
    //        '                    <a class="js-wj js-btn" index-id="6"><img src="${ctx}/images/file.png">我的文件2</a>\n' +
    //        '                </div>\n' +
    //        '            </div>';

    //文件和文件夹的右击事件
    var options = {items:[
            {text: '重命名', onclick:rename},
            {text: '删除', onclick: del},
            {text: '下载',onclick:function () {alert("下载")}}
        ]};

    //页面初始化时，，从服务器接收数据
    sendGet("",function (msg) {
        if (msg.res){
//            获取数据放入dirAttr
            dirAttr = msg.data;
            //新建一个最大的面包屑，id为主文件夹的id
            $('.breadcrumb').append('<li><a id="mainbread" index-id="'+msg.id+'" >全部文件</a></li>');
        }
        else{
            toastr.error("页面初始化失败！");
            return false;
        }
    },function (error) {
        toastr.error("出错了！");
        return false;
    });
    //页面初始化的数据展示在屏幕上
    showDir($('.neirong'),dirAttr);
    function showDir($item,dir) {
        for (var i = 0 ;i < dir.length; i++){
            var name = dir[i].name;
            var _id = dir[i].id;
            //如果为目录
            if(dir[i].data != null){
                var tempTPL = dirTPL1.replace(/_replace/,name);
                tempTPL = tempTPL.replace(/_id/,_id);
                $item.append(tempTPL);
            }else{// 如果为笔记
                var tempTPL = dirTPL2.replace(/_replace/,name);
                tempTPL = tempTPL.replace(/_id/,_id);
                $item.append(tempTPL);
            }
        }
    }

    initUI();
    function initUI() {
        //当前右击的元素
        $(".js-btn").bind("contextmenu",function() {
            $chooseDir = $(this);
        });
        $('.js-btn').contextify(options);

        //当前左击的元素
        $('.js-wjj').on('click',function () {
            //包裹目录的div
            var $parent = $(this).parent().parent();
            //content区域
            var $pparent = $parent.parent();
            //左击文件夹的id和name
            var id = $(this).attr('index-id');
            var dirname = $(this).text();
            //把左击文件夹的id发给服务器
            sendPost('',{'dirId':id},function (msg) {
                if (!msg.res) {
                    //删除原包裹的div
                    $parent.remove();
                    //在面包屑导航上加入左击文件夹的名字的面包屑
                    $('.breadcrumb').append('<li ><a index-id="'+id+'">'+dirname+'</a></li>');
                    //在content区域传入数据
                    dirAttr = msg.data;
                    //在content里面新加一个包裹
                    $pparent.append('<div class="neirong">\n' +
                        '                </div>');
                    showDir('.neirong',dirAttr);
                    initUI();
                    return true;
                } else {
                    toastr.error("打开目录失败！");
                    return false;
                }
            },function (error) {
                toastr.error("出错了！");
                return false;
            });
        });
    }

    //最大的面包屑事件
    $('#mainbread').on('click',function () {
        //获取当前面包屑的id，，即最上层文件夹的id
        var id = $(this).find('a').attr('index-id');
        //删除当前content下级的div的内容
        $('.neirong').remove();
        //删除当前面包屑的后面所有的面包屑
        $(this).parent().nextAll().remove();
//        获取该id所属的data数据即文件数据
        sendPost('',{'dirId':id},function (msg) {
            if (!msg.res) {
                //在获取数据放入dirAttr
                dirAttr = msg.data;
                //在content里面新加一个包裹
                $pparent.append('<div class="neirong">\n' +
                    '                </div>');
                showDir('.neirong',dirAttr);
                initUI();
                return true;
            } else {
                toastr.error("跳转失败！");
                return false;
            }
        },function (error) {
            toastr.error("出错了！");
            return false;
        });
    });

    //中间的面包屑事件
    $('.breadcrumb a').on('click',function () {
        //获取当前面包屑的id，，即上层文件夹的id
        var id = $(this).find('a').attr('index-id');
        //删除当前content下级的div的内容
        $('.neirong').remove();
        //删除当前面包屑的后面所有的面包屑
        $(this).parent().nextAll().remove();
//        获取该id所属的data数据即文件数据
        sendPost('',{'dirId':id},function (msg) {
            if (!msg.res) {
                //在获取数据放入dirAttr
                dirAttr = msg.data;
                //在content里面新加一个包裹
                $pparent.append('<div class="neirong">\n' +
                    '                </div>');
                showDir('.neirong',dirAttr);
                initUI();
                return true;
            } else {
                toastr.error("跳转失败！");
                return false;
            }
        },function (error) {
            toastr.error("出错了！");
            return false;
        });
    })

    //重命名事件
    function rename() {
        //判断是文件夹的重命名还是文件的重命名
        var classname = $chooseDir.parent().attr('class');
        var dirname = $chooseDir.text();
        //文件夹重命名
        if (classname == "wjj") {
            var $parent = $chooseDir.parent();
            var str = '<input type="text" name="dir_name" value="'+dirname+'">';
            var id  = $chooseDir.attr('index-id');
            //删除当前右击元素
            $chooseDir.remove();
            $parent.append(str);
            $('input[name=dir_name]').select();
            //失去焦点
            $('input[name=dir_name]').blur(function () {
                var name = $('input[name=dir_name]').val();
                //id 名字发给服务器
                sendPost('',{'dirId':id,'dirName':name},function (msg) {
                    if (!msg.res) {
                        //删除文本框
                        $('input[name=dir_name]').remove();
                        //生成新目录
                        $parent.append('<a class="js-wjj js-btn" index-id="'+id+'"><img src="${ctx}/images/wjj4.png">'+name+'</a>');
                        initUI();
                        return true;
                    } else {
                        toastr.error("重命名文件夹失败！");
                        return false;
                    }
                },function (error) {
                    toastr.error("出错了！");
                    return false;
                });
            });
        } else if(classname == "wj"){   //文件重命名
            var $parent = $chooseDir.parent();
            var notename = $chooseDir.text();
            var str = '<input type="text" name="note_name" value="'+notename+'">';
            var id  = $chooseDir.attr('index-id');
            //删除当前右击元素
            $chooseDir.remove();
            $parent.append(str);
            $('input[name=note_name]').select();
            //失去焦点
            $('input[name=note_name]').blur(function () {
                var name = $('input[name=note_name]').val();
                //名字发给服务器
                sendPost('',{'dirId':id,'dirName':name},function (msg) {
                    if (!msg.res) {
                        //删除文本框
                        $('input[name=note_name]').remove();
                        //生成文件的新名字
                        $parent.append('<a class="js-wj js-btn " index-id="'+id+'"><img src="${ctx}/images/file.png">'+name+'</a>');
                        initUI();
                        return true;
                    } else {
                        toastr.error("重命名文件夹失败！");
                        return false;
                    }
                },function (error) {
                    toastr.error("出错了！");
                    return false;
                });
            });
        }
    }

    //删除事件
    function del() {
        //找到当前右击元素的父亲
        var $parent = $chooseDir.parent();
        //当前元素的id
        var id = $chooseDir.attr('index-id');
        //id发送给服务器
        sendPost('',{'deleteId':id},function (msg) {
            if (!msg.res) {
                //删除父亲
                $parent.remove();
                initUI();
                return true;
            } else {
                toastr.error("删除失败");
                return false;
            }
        },function (error) {
            toastr.error("出错了！");
            return false;
        })
    }

    //新建文件夹事件
    $('#xj-wjj-btn').on('click',function () {
        //获取父目录的id  就是最后一个面包屑的id
        var parentid = $('.breadcrumb').last().find('a').attr('index-id');
        //在content的开头追加一个文本框
        var dirTPL1 = '<div class="wjj">\n' +
            '                <input type="text" name="dir_name" value="新建文件夹">\n' +
            '            </div>';
        $('.neirong').prepend(dirTPL1);
        //获取文本框的父亲
        var $parent = $('input[name=dir_name]').parent();
        //对文本框的处理
        $('input[name=dir_name]').select();
        //获取名字
        $('input[name=dir_name]').blur(function() {
            var name = $('input[name=dir_name]').val();
            //把名字传给服务器   同时获取新建文件夹的id
            sendPost('',{'parentId':parentid,'dirName':name},function (msg) {
                if (!msg.res) {
                    //删除文本框
                    $('input[name=dir_name]').remove();
                    //生成新的文件夹
                    $parent.append('<a class="js-wjj js-btn" index-id=""><img src="${ctx}/images/wjj4.png">' + name + '</a>');
                    initUI();
                    return true;
                } else {
                    toastr.erro("新建文件夹失败！");
                    return false;
                }
            },function (error) {
                toastr.error("出错了！");
                return false;
            })
        });
    })

    //上传文件
    $('#upload').on('click',function () {
        //从服务器获取文件名和id
        sendGet('',function (msg) {
            if (msg.res) {
                //在当前的包裹里追加
                $('.neirong').append('<div class="wj">\n' +
                    '                    <a class="js-wj js-btn " index-id="'+msg.id+'"><img src="${ctx}/images/file.png">'+msg.noteName+'/a>\n' +
                    '                </div>');
                return true;
            } else {
                toastr.error("上传文件失败！");
                return false;
            }
        },function (error) {
            toastr.error("出错了！");
            return false;
        })
    })
</script>
</body>
</html>

<%--<div class="box1" >--%>
    <%--<h4 style="margin-left: 40px">我的网盘</h4>--%>
<%--</div>--%>

<%--<div class="box2">--%>
    <%--<h4> 空间</h4>--%>
    <%--<hr>--%>
    <%--<div class="progress progress-striped active">--%>
        <%--<div class="progress-bar progress-bar-success" role="progressbar"--%>
             <%--aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"--%>
             <%--style="width: 20%;">--%>
            <%--<span class="sr-only">20% 完成</span>--%>
        <%--</div>--%>
    <%--</div>--%>
<%--</div>--%>