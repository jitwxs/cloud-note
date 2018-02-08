<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<%-- 引入头部 --%>
<jsp:include page="settingHead.jsp"/>

<body>
<div class="container">
    <div class="row" style="margin-top: 20px">
        <div class="col-md-offset-3 col-md-6">
            <h5 class="progressbar-title" style="text-align: center;margin-bottom: 70px;">网盘总大小：<span id="totalSize"></span>MB</h5>
            <div class="progress">
                <div id="process" class="progress-bar" style="width: 80%; background:#005394;">
                    <span id="spans"></span>
                </div>
            </div>

        </div>
    </div>

    <div id="wangpan">
        <!--头部导航-->
        <div id="head">
            <a class="upload">
                <input type="file" id="uploadFile">
                <img src="${ctx}/images/upload_file.png">
                上传文件
            </a>
            <a class="btn" id="xj-wjj-btn"><img src="${ctx}/images/new_file.png"> 新建文件夹</a>
            <span class="input-group-btn" style="float: right">
               <button class="btn btn-info btn-search"
                       style="float:right;margin-right: 15px;margin-top:7px;">查找</button>
            </span>
            <input id="search_key" style="width: 245px;height: 35px;float: right;margin-right: 10px;margin-top:7px;"
                   type="text" class="form-control" placeholder="搜索您的文件"/>

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

    <!-- 过度动画区域 -->
    <div class="spinner hidden">
        <div class="rect1"></div>
        <div class="rect2"></div>
        <div class="rect3"></div>
        <div class="rect4"></div>
        <div class="rect5"></div>
    </div>
</div>

<script>
    var dirAttr = [];

    var dirTPL1 = '<div class="wjj">\n' +
        '                        <a class="wenjianjia" index-id="_id"><img src="${ctx}/images/wjj4.png">_replace</a>\n' +
        '                        <a  class="delete"><img src="${ctx}/images/delete.png"></a>\n' +
        '                        <a  class="rename_dir"><img src="${ctx}/images/rename.png"></a>\n' +
        '                    </div>';

    var dirTPL2 = '<div class="wj">\n' +
        '                        <a class="wenjian" index-id="_id"><img src="${ctx}/images/file.png">_replace</a>\n' +
        '                        <a  class="delete"><img src="${ctx}/images/delete.png"></a>\n' +
        '                        <a  class="rename_note"><img src="${ctx}/images/rename.png"></a>\n' +
        '                        <a class="download"><img src="${ctx}/images/download.png"></a>\n' +
        '                        <a class="yulan"><img src="${ctx}/images/preview.png"></a>\n' +
        '                    </div>';

    // 页面初始化时，从服务器接收数据
    sendGet("${ctx}/user/initUserPanDir", {'dirId': "root"}, false, function (msg) {
        if (msg) {
            // 获取数据放入dirAttr
            dirAttr = msg.data;
            // 新建一个最大的面包屑，id为主文件夹的id
            $('.breadcrumb').append('<li><a id="mainbread" index-id="' + msg.id + '" >全部文件</a></li>');
        }
        else {
            toastr.error("页面初始化失败");
            return false;
        }
    }, function (error) {
        toastr.error("系统错误");
        return false;
    });
    //页面初始化的数据展示在屏幕上
    showDir($('.neirong'), dirAttr);

    function showDir($item, dir) {
        for (var i = 0; i < dir.length; i++) {
            var name = dir[i].name;
            var _id = dir[i].id;
            //如果为目录
            if (dir[i].data != null) {
                var tempTPL = dirTPL1.replace(/_replace/, name);
                tempTPL = tempTPL.replace(/_id/, _id);
                $item.append(tempTPL);
            } else {// 如果为笔记
                var tempTPL = dirTPL2.replace(/_replace/, name);
                tempTPL = tempTPL.replace(/_id/, _id);
                $item.append(tempTPL);
            }
        }
    }

    initUI();

    function initUI() {
        // 初始化网盘大小
        initSize();

        //当前左击的元素
        $('.wenjianjia').off('click').on('click', function () {
            //包裹目录的div
            var $parent = $(this).parent();
            //左击文件夹的id和name
            var id = $(this).attr('index-id');
            var dirname = $(this).text();
            //把左击文件夹的id发给服务器
            sendGet("${ctx}/user/initUserPanDir", {'dirId': id}, false, function (msg) {
                if (msg) {
                    //删除原包裹的div
                    $('#content').children().remove();
                    //在面包屑导航上加入左击文件夹的名字的面包屑
                    $('.breadcrumb').append('<li ><a class="breadcrumb_middle" index-id="' + id + '">' + dirname + '</a></li>');
                    //在content区域传入数据
                    dirAttr = msg.data;
                    //在content里面新加一个包裹
                    $('#content').append('<div class="neirong">\n' +
                        '                </div>');
                    showDir($('.neirong'), dirAttr);
                    initUI();
                    return true;
                } else {
                    toastr.error("打开目录失败");
                    return false;
                }
            }, function (error) {
                toastr.error("系统错误");
                return false;
            });
        });

        //最大的面包屑事件
        $('#mainbread').off('click').on('click', function () {
            // 获取当前面包屑的id，，即最上层文件夹的id
            var id = $(this).attr('index-id');
            // 删除当前content下级的div的内容
            $('.neirong').children().remove();
            // 删除当前面包屑的后面所有的面包屑
            $(this).parent().nextAll().remove();
            // 获取该id所属的data数据即文件数据
            sendGet("${ctx}/user/initUserPanDir", {'dirId': id}, false, function (msg) {
                if (msg) {
                    //在获取数据放入dirAttr
                    dirAttr = msg.data;
                    //在content里面新加一个包裹
                    showDir($('.neirong'), dirAttr);
                    initUI();
                } else {
                    toastr.error("跳转失败");
                }
            }, function (error) {
                toastr.error("系统错误");
                return false;
            });
        });

        // 中间的面包屑事件
        $('.breadcrumb_middle').off("click").on('click', function () {
            // 删除当前面包屑的后面所有的面包屑
            $(this).parent().nextAll().remove();
            // 获取当前面包屑的id，，即上层文件夹的id
            var id = $(this).attr('index-id');
            var name = $(this).text();
            // 删除当前content下级的div的内容
            $('.neirong').children().remove();
            // 获取该id所属的data数据即文件数据
            sendGet('${ctx}/user/initUserPanDir', {'dirId': id}, false, function (msg) {
                if (msg) {
                    //在获取数据放入dirAttr
                    dirAttr = msg.data;
                    //在content里面新加一个包裹
                    showDir($('.neirong'), dirAttr);
                    initUI();
                    return true;
                } else {
                    toastr.error("跳转失败");
                    return false;
                }
            }, function (error) {
                toastr.error("系统错误");
                return false;
            });
        });

        //重命名文件夹事件
        $('.rename_dir').off('click').on('click', function () {
            //获取文件夹的id和名字
            var $parent = $(this).parent();
            var id = $(this).prev().prev().attr('index-id');
            var dirName = $(this).prev().prev().text();
            var str = '<input class="shuru" type="text" name="dir_name" value="' + dirName + '">';
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
                    sendPost('${ctx}/user/renamePanDir', {'dirId': id, 'dirName': name}, false, function (msg) {
                        if (msg.status) {
                            //删除文本框
                            $('input[name=dir_name]').remove();
                            //生成新目录
                            $parent.prepend('<a class="wenjianjia" index-id="' + id + '"><img src="${ctx}/images/wjj4.png">' + name + '</a>');
                            initUI();
                            return true;
                        } else {
                            toastr.warning(msg.info);
                            return false;
                        }
                    }, function (error) {
                        toastr.error("系统错误");
                        return false;
                    });
                }
            });
        });

        //重命名文件事件
        $('.rename_note').off('click').on('click', function () {
            //获取文件的id和名字
            var $parent = $(this).parent();
            var id = $(this).prev().prev().attr('index-id');
            var name = $(this).prev().prev().text();
            var str = '<input class="shuru" type="text" name="note_name" value="' + name + '">';
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
                    sendPost('${ctx}/user/renamePan', {'panId': id, 'panName': name}, false, function (msg) {
                        if (msg.status) {
                            //删除文本框
                            $('input[name=note_name]').remove();
                            //生成文件的新名字
                            $parent.prepend('<a class="js-wj js-btn " index-id="' + id + '"><img src="${ctx}/images/file.png">' + msg.name + '</a>');
                            initUI();
                            return true;
                        } else {
                            toastr.warning(msg.info);
                            return false;
                        }
                    }, function (error) {
                        toastr.error("系统错误");
                        return false;
                    });
                }
            });
        });

        //下载事件
        $('.download').off('click').on('click', function () {
            var id = $(this).prev().prev().prev().attr('index-id');
            var name = $(this).prev().prev().prev().text();

            window.location.href = "${ctx}/user/downloadUserPan?panId=" + id + "&panName=" + name;
            initUI();
        });

        //删除事件
        $('.delete').off('click').on('click', function () {
            //找到当前元素的父亲
            var $parent = $(this).parent();
            //当前元素的id
            var id = $(this).prev().attr('index-id');
            var dblChoseAlert = simpleAlert({
                "content": "确定要删除吗？",
                "buttons": {
                    "确定": function () {
                        //id发送给服务器
                        sendPost('${ctx}/user/removePan', {'deleteId': id}, false, function (msg) {
                            if (msg.status) {
                                //删除父亲
                                $parent.remove();
                                initUI();
                                toastr.success("删除成功");
                            } else {
                                toastr.error("删除失败");
                            }
                        }, function (error) {
                            toastr.error("系统错误");
                        });
                        dblChoseAlert.close();
                    },
                    "取消": function () {
                        dblChoseAlert.close();
                    }
                }
            })
        });

        //预览事件
        $('.yulan').off('click').on('click',function () {
            var noteId = $(this).prev().prev().prev().prev().attr('index-id');
            var previewArray = new Array("pdf","bmp", "png", "jpg", "jpeg", "gif", "htm", "html");
            var convertArray=new Array("doc","docx","xls","xlsx","ppt","pptx");

            if(noteId == null || noteId == "") {
                toastr.error("系统错误");
            } else {
                var tmpName =$(this).prev().prev().prev().prev().text();
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
                    sendPost('${ctx}/user/previewDisk',{'panId':noteId},true,function (res) {
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
                    sendPost('${ctx}/user/convertDiskFile',{'panId':noteId},true,function (res) {
                        if(!$(".spinner").hasClass("hidden")) {
                            $(".spinner").addClass("hidden");
                        }
                        if(!res.status) {
                            toastr.error(res.info);
                        } else {
                            // 转换成功后。预览文件
                            sendPost('${ctx}/user/previewDisk',{'panId':noteId},true,function (res) {
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
                        if(!$(".spinner").hasClass("hidden")) {
                            $(".spinner").addClass("hidden");
                        }
                        toastr.error("系统错误");
                        return false;
                    });
                } else {
                    toastr.warning("该格式不支持预览");
                }
            }
        })
    }

    //新建文件夹事件
    $('#xj-wjj-btn').on('click', function () {
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
        $('input[name=dir_name]').blur(function () {
            var name = $('input[name=dir_name]').val();
            if (name == null || name == "") {
                toastr.warning("文件夹名不能为空!");
                initUI();
                return false;
            } else {
                //把名字传给服务器   同时获取新建文件夹的id
                sendPost('${ctx}/user/createPanDir', {'parentId': parentid, 'dirName': name}, false, function (msg) {
                    if (msg.status) {
                        //删除文本框
                        $('input[name=dir_name]').remove();
                        //生成新的文件夹
                        $parent.prepend('<a class="wenjianjia" index-id="' + msg.dirId + '"><img src="${ctx}/images/wjj4.png">' + name + '</a>');
                        initUI();
                        return true;
                    } else {
                        toastr.warning(msg.info);
                        return false;
                    }
                }, function (error) {
                    toastr.error("系统错误");
                    return false;
                })
            }
        });
    });

    // 上传文件
    $("input[type='file']").change(function () {
        //找当前父目录，，就是面包屑的最后一个的id
        var parent = $('.breadcrumb a').last().attr('index-id');
        var file = this.files[0];
        var fileSize = file.size;
        var usedSize = parseInt($("#spans").text());
        var totalSize = parseInt($("#totalSize").text());

        if ((fileSize / 1024 / 1024 + usedSize) > totalSize) {
            toastr.warning("超出容量限制");
        } else {
            var formData = new FormData();
            formData.append("dirId", parent);
            formData.append("file", file);
            $.ajax({
                url: "${ctx}/user/uploadPan",
                type: 'post',
                data: formData,
                async: true,
                dataType: 'json',
                // 告诉jQuery不要去处理发送的数据
                processData: false,
                // 告诉jQuery不要去设置Content-Type请求头
                contentType: false,
                success: function (msg) {
                    $('#uploadPanModal').modal('hide');
                    if (msg.status) {
                        $('.neirong').append('<div class="wj">\n' +
                            '                        <a class="wenjian" index-id="' + msg.info + '"><img src="${ctx}/images/file.png">' + msg.name + '</a>\n' +
                            '                        <a  class="delete"><img src="${ctx}/images/delete.png"></a>\n' +
                            '                        <a  class="rename_note"><img src="${ctx}/images/rename.png"></a>\n' +
                            '                        <a class="download"><img src="${ctx}/images/download.png"></a>\n' +
                            '                        <a class="yulan"><img src="${ctx}/images/preview.png"></a>\n' +
                            '                    </div>');
                        initUI();
                    } else {
                        toastr.error("上传文件失败");
                    }
                    if(!$(".spinner").hasClass("hidden")) {
                        $(".spinner").addClass("hidden");
                    }
                },
                error: function (msg) {
                    toastr.error("系统错误");
                    return false;
                }
            });
        }
    });

    // 绑定回车事件
    $('#search_key').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            $(".btn-search").click();
        }
    });

    $('.btn-search').on('click', function () {
        //删除最大的面包屑后面所有的面包屑
        $('#mainbread').parent().nextAll().remove();
        var key = $('#search_key').val();
        $('.breadcrumb').append('<li class="active">>搜索:\"' + key + '\"</a></li>');
        sendPost('${ctx}/user/panSearch', {'searchKey': key}, false, function (msg) {
            if (msg.status) {
                $('.neirong').children().remove();
                var dirAttr1 = msg.directoryTrees;
                showDir($('.neirong'), dirAttr1);
                var dirAttr2 = msg.userFiles;
                showDir($('.neirong'), dirAttr2);
                initUI();
                return true;
            } else {
                return false;
            }
        }, function (error) {
            toastr.error("系统错误");
            return false;
        })
    });

    function initSize() {
        sendGet("${ctx}/user/initUserPanSize", {}, false, function (msg) {
            var pro = document.getElementById("process");

            var percent = parseInt(msg.usedPerfect);
            var totalSize = parseInt(msg.size) / 1024 / 1024;

            if (percent <= 60) {
                pro.style.background = 'green';
            } else if (percent <= 90) {
                pro.style.background = 'yellow';
            } else {
                pro.style.background = 'red';
            }

            pro.style.width = percent + '%';
            $("#totalSize").text(totalSize);
            $("#spans").text(percent + '%');
        }, function (error) {
            toastr.error("系统错误");
            return false;
        });
    }
</script>
</body>
</html>
