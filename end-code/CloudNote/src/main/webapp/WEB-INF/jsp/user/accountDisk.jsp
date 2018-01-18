<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<%-- 引入头部 --%>
<jsp:include page="settingHead.jsp"/>
<jsp:include page="uploadPanModel.jsp"/>

<body>
<div class="container">
    <div id="wangpan">
        <!--头部导航-->
        <div id="head" >
            <a class="upload" onclick="uploadPan()">
                <img src="${ctx}/images/uploadfile.png">
                上传文件
            </a>
            <a class="btn" id="xj-wjj-btn" ><img src="${ctx}/images/newfile.png"> 新建文件夹</a>
            <input id="search_key" style="width: 245px;height: 35px;float: left;margin-left: 240px;margin-top:7px;" type="text" class="form-control"placeholder="搜索您的文件" />
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

            </div>
        </div>
    </div>
</div>

<script>
    //    全局变量
    var dirAttr = [];

    var dirTPL1 = '<div class="wjj">\n' +
        '                        <a class="wenjianjia" index-id="_id"><img src="${ctx}/images/wjj4.png">_replace</a>\n' +
        '                        <a  class="delete"><img src="${ctx}/images/delete.png"></a>\n' +
        '                        <a  class="rename_dir"><img src="${ctx}/images/rename.png"></a>\n' +
        '                    </div>';

    var dirTPL2 ='<div class="wj">\n' +
        '                        <a class="wenjian" index-id="_id"><img src="${ctx}/images/file.png">_replace</a>\n' +
        '                        <a  class="delete"><img src="${ctx}/images/delete.png"></a>\n' +
        '                        <a  class="rename_note"><img src="${ctx}/images/rename.png"></a>\n' +
        '                        <a class="download"><img src="${ctx}/images/download.png"></a>\n' +
        '                    </div>';


    //页面初始化时，，从服务器接收数据
    sendGet("${ctx}/user/initUserPanDir", {'dirId':"root"}, false, function (msg) {
        if (msg){
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
        //当前左击的元素
        $('.wenjianjia').off('click').on('click',function () {
            //包裹目录的div
            var $parent = $(this).parent();
            //左击文件夹的id和name
            var id = $(this).attr('index-id');
            var dirname = $(this).text();
            //把左击文件夹的id发给服务器
            sendGet("${ctx}/user/initUserPanDir", {'dirId':id}, false, function (msg) {
                if (msg) {
                    //删除原包裹的div
                    $('#content').children().remove();
                    //在面包屑导航上加入左击文件夹的名字的面包屑
                    $('.breadcrumb').append('<li ><a class="breadcrumb_middle" index-id="'+id+'">'+dirname+'</a></li>');
                    //在content区域传入数据
                    dirAttr = msg.data;
                    //在content里面新加一个包裹
                    $('#content').append('<div class="neirong">\n' +
                        '                </div>');
                    showDir($('.neirong'),dirAttr);
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

        //最大的面包屑事件
        $('#mainbread').on('click',function () {
            //获取当前面包屑的id，，即最上层文件夹的id
            var id = $(this).attr('index-id');
            //删除当前content下级的div的内容
            $('.neirong').children().remove();
            //删除当前面包屑的后面所有的面包屑
            $(this).parent().nextAll().remove();
//        获取该id所属的data数据即文件数据
            sendGet("${ctx}/user/initUserPanDir", {'dirId':id}, false, function (msg) {
                if (msg) {
                    //在获取数据放入dirAttr
                    dirAttr = msg.data;
                    //在content里面新加一个包裹
                    showDir($('.neirong'),dirAttr);
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
        $('.breadcrumb_middle').off("click").on('click',function () {
            //删除当前面包屑的后面所有的面包屑
            $(this).parent().nextAll().remove();
            //获取当前面包屑的id，，即上层文件夹的id
            var id = $(this).attr('index-id');
            var name = $(this).text();
            //删除当前content下级的div的内容
            $('.neirong').children().remove();
//        获取该id所属的data数据即文件数据
            sendGet('${ctx}/user/initUserPanDir',{'dirId':id}, false, function (msg) {
                if (msg) {
                    //在获取数据放入dirAttr
                    dirAttr = msg.data;
                    //在content里面新加一个包裹
                    showDir($('.neirong'),dirAttr);
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

        //重命名文件夹事件
        $('.rename_dir').off('click').on('click',function () {
            //获取文件夹的id和名字
            var $parent = $(this).parent();
            var id= $(this).prev().prev().attr('index-id');
            var dirName = $(this).prev().prev().text();
            var str = '<input class="shuru" type="text" name="dir_name" value="'+dirName+'">';
            //删除文件夹所在的a标签
            $(this).prev().prev().remove();
            $parent.prepend(str);
            $('input[name=dir_name]').select();
            //失去焦点
            $('input[name=dir_name]').blur(function () {
                var name = $('input[name=dir_name]').val();
                if (name == null || name == "") {
                    toastr.warning("文件夹名不能为空!");
                } else {
                    //id 名字发给服务器
                    sendPost('${ctx}/user/renamePanDir',{'dirId':id,'dirName':name},false, function (msg) {
                        if (msg.status) {
                            //删除文本框
                            $('input[name=dir_name]').remove();
                            //生成新目录
                            $parent.prepend('<a class="wenjianjia" index-id="'+id+'"><img src="${ctx}/images/wjj4.png">'+name+'</a>');
                            initUI();
                            return true;
                        } else {
                            toastr.warning(msg.info);
                            return false;
                        }
                    },function (error) {
                        toastr.error("出错了！");
                        return false;
                    });
                }
            });
        });

        //重命名文件事件
        $('.rename_note').off('click').on('click',function () {
            //获取文件的id和名字
            var $parent = $(this).parent();
            var id= $(this).prev().prev().attr('index-id');
            var name = $(this).prev().prev().text();
            var str = '<input class="shuru" type="text" name="note_name" value="'+name+'">';
            //删除文件所在的a标签
            $(this).prev().prev().remove();
            $parent.prepend(str);
            $('input[name=note_name]').select();
            //失去焦点
            $('input[name=note_name]').blur(function () {
                var name = $('input[name=note_name]').val();
                if (name == null || name == "") {
                    toastr.warning("文件名不能为空!");
                } else {
                    //名字发给服务器
                    sendPost('${ctx}/user/renamePan',{'panId':id,'panName':name},false, function (msg) {
                        if (msg.status) {
                            //删除文本框
                            $('input[name=note_name]').remove();
                            //生成文件的新名字
                            $parent.prepend('<a class="js-wj js-btn " index-id="'+id+'"><img src="${ctx}/images/file.png">'+msg.name+'</a>');
                            initUI();
                            return true;
                        } else {
                            toastr.warning(msg.info);
                            return false;
                        }
                    },function (error) {
                        toastr.error("出错了！");
                        return false;
                    });
                }
            });
        });

        //下载事件
        $('.download').off('click').on('click',function () {
            var id = $(this).prev().prev().prev().attr('index-id');
            var name = $(this).prev().prev().prev().text();

            var url = "${ctx}/user/downloadUserPan?panId=" + id + "&panName=" + name;
            window.location.href = url;
            initUI();
        });

        //删除事件
        $('.delete').off('click').on('click',function () {
            //找到当前元素的父亲
            var $parent = $(this).parent();
            //当前元素的id
            var id = $(this).prev().attr('index-id');
            var msg = "确定要删除吗？";
            if(confirm(msg)) {
                //id发送给服务器
                sendPost('${ctx}/user/removePan', {'deleteId':id}, false, function (msg) {
                    if (msg.status) {
                        //删除父亲
                        $parent.remove();
                        initUI();
                        toastr.success("删除成功");
                        return true;
                    } else {
                        toastr.error("删除失败");
                        return false;
                    }
                },function (error) {
                    toastr.error("出错了！");
                    return false;
                })
            } else {
                return false;
            }
        });
    }

    //新建文件夹事件
    $('#xj-wjj-btn').on('click',function () {
        //获取父目录的id  就是最后一个面包屑的id
        var parentid = $('.breadcrumb a').last().attr('index-id');
        console.log(parentid);
        var parentname = $('.breadcrumb a').last().text();
        console.log(parentname);
        //在content的开头追加一个文本框
        var dirTPL1 = ' <div class="wjj">\n' +
            '        <input class="shuru" type="text" name="dir_name" value="新建文件夹">\n' +
            '        <a  class="delete"><img src="${ctx}/images/delete.png"></a>\n' +
            '        <a  class="rename_dir"><img src="${ctx}/images/rename.png"></a>\n' +
            '        </div>';
        $('.neirong').prepend(dirTPL1);
        //获取文本框的爹
        var $parent = $('input[name=dir_name]').parent();
        //对文本框的处理
        $('input[name=dir_name]').select();
        //获取名字
        $('input[name=dir_name]').blur(function() {
            var name = $('input[name=dir_name]').val();
            if (name == null || name == "") {
                toastr.warning("文件夹名不能为空!");
                initUI();
                return false;
            } else {
                //把名字传给服务器   同时获取新建文件夹的id
                sendPost('${ctx}/user/createPanDir',{'parentId':parentid,'dirName':name},false, function (msg) {
                    if (msg.status) {
                        //删除文本框
                        $('input[name=dir_name]').remove();
                        //生成新的文件夹
                        $parent.prepend('<a class="wenjianjia" index-id="'+msg.dirId+'"><img src="${ctx}/images/wjj4.png">'+name+'</a>');
                        initUI();
                        return true;
                    } else {
                        toastr.warning(msg.info);
                        return false;
                    }
                },function (error) {
                    toastr.error("出错了！");
                    return false;
                })
            }
        });
    });

    //上传文件
    function uploadPan() {
        //找当前父目录，，就是面包屑的最后一个的id
        var parent = $('.breadcrumb a').last().attr('index-id');
        //赋值给input
        $('#uploadNote_parent').val(parent);
        console.log($('#uploadNote_parent').val());
        $("#uploadPanName").html("当前未选择文件!");
        $('#uploadPanModal').modal('show');
    }

    //查找事件
    $('.btn-search').on('click',function () {
        //删除最大的面包屑后面所有的面包屑
        $('#mainbread').parent().nextAll().remove();
        var key = $('#search_key').val();
        $('.breadcrumb').append('<li class="active">>搜索:\"'+key+'\"</a></li>');
        sendPost('${ctx}/user/panSearch', {'searchKey': key}, false, function (msg) {
            if (msg.status) {
                $('.neirong').children().remove();
                var dirAttr1 = msg.directoryTrees;
                showDir($('.neirong'),dirAttr1);
                var dirAttr2 = msg.userFiles;
                showDir($('.neirong'),dirAttr2);
                initUI();
                return true;
            } else {
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
