<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<jsp:include page="settingHead.jsp"/>
<style>
    td{
        text-align: center;
    }
    .checked{
        background: grey;
        color: white;
    }
    .default{
        background: #eeeeee;
        color:#333333;
    }
</style>

<body>

<!--消息推送主体区域-->
<div  id="message_list_show" style="width: 100%;">

    <!--消息导航栏-->
    <div id="message_nav" >
        <a id="remove_all" class="btn" style="background: lightskyblue;color: white;">删除</a>
        <a class="btn" id="all_read" style="background: lightskyblue;color: white; margin-left: 10px">全部标记为已读</a>
        <a class="message_all checked" style="margin-left: 30px;">全部</a>
        <a class="message_safe default">系统消息</a>
        <a class="message_note default">笔记消息</a>
        <a class="message_other default">其他消息</a>
    </div>

    <!--消息区域-->
    <div id="message_main" >
        <table class="table" id="message_table" style="left:2%;">
            <thead>
            <tr>
                <th style="text-align: center"><input type="checkbox" id="main_checkbox"></th>
                <th style="text-align: center">消息</th>
                <th style="text-align: center">时间</th>
                <th style="text-align: center">消息类型</th>
                <th style="text-align: center">删除</th>
                <th style="text-align: center">操作</th>
            </tr>
            </thead>
            <tbody id="message_container">

            </tbody>
        </table>
    </div>
</div>

<!--消息展示主体区域-->
<div id="message_content_show" class="hidden" >
    <div id="message_content_main" >
        <!--消息标题栏-->
        <div id="message_content_nav" >
            <p id="message_content_title">
            </p>
        </div>

        <!--消息内容区域-->
        <div class="message_content_detail" >
            <p id="message_content_body">
            </p>
        </div>

        <div class="message_delete" >
            <a class="btn message_delete_btn" >删除</a>
            <a class="goback btn">返回</a>
        </div>

    </div>
</div>

<script>
    var message_id = null;

    function showMessage($item,data) {
        for(var i=0; i<data.length; i++) {
            var id = data[i].id;
            var title = data[i].title;
            var date = data[i].createDate;
            var type = data[i].type;

            var t;
            // data[i].status : 1已读，2未读
            if(data[i].status == 1) {
                t = t = '<tr>\n' +
                    '        <td><input type="checkbox" class="checkbox_message"></td>\n' +
                    '        <td><a class="message_title" index-type="1" index-id="'+id+'">' +
                    '        <img src="${ctx}/images/read_notify.png">'+title+'</a></td>\n' +
                    '        <td><span class="message_time" >'+date+'</span></td>\n' +
                    '        <td><span class="message_type" >'+type+'</span></td>\n' +
                    '        <td><img class="remove_btn" src="${ctx}/images/delete.png" ></td>\n' +
                    '        <td><a class="already_read" >已读</a></td>\n' +
                    '    </tr>';


            } else if(data[i].status == 2) {
                t = '<tr>\n' +
                    '        <td><input type="checkbox" class="checkbox_message"></td>\n' +
                    '        <td><a class="message_title" index-type="1" index-id="'+id+'">' +
                    '<img class="new_message" src="${ctx}/images/message.png">'+title+'</a></td>\n' +
                    '        <td><span class="message_time" >'+date+'</span></td>\n' +
                    '        <td><span class="message_type" >'+type+'</span></td>\n' +
                    '        <td><img class="remove_btn" src="${ctx}/images/delete.png" ></td>\n' +
                    '        <td><a class="read" >标记为已读</a></td>\n' +
                    '    </tr>';
            }
            $item.append(t);
        }
    }

    function getNotifyByType(type) {
        sendGet('${ctx}/user/prepareNotify',{"type":type},false,function (res) {
            //删除原来message_container里的内容
            $('#message_container').children().remove();
            showMessage($('#message_container'),res.notifies);
            initMessageUI();
        },function (error) {
            toastr.error("获取笔记消息出错！");
        })
    }

    // 初始化消息列表
    sendGet('${ctx}/user/prepareNotify',{},false,function (res) {
        //全部消息
        showMessage($('#message_container'),res.notifies);
    },function (error) {
        toastr.error("系统错误");
        return false;
    });

    initMessageUI();

    //笔记消息点击事件
    $('.message_note').off('click').on('click',function () {
        $('.message_all').removeClass('checked').addClass("default");
        $('.message_safe').removeClass('checked').addClass("default");
        $('.message_other').removeClass('checked').addClass("default");
        $(this).removeClass("default").addClass("checked");
        getNotifyByType("笔记消息");
    });

    //系统消息点击事件
    $('.message_safe').off('click').on('click',function () {
        $('.message_all').removeClass('checked').addClass("default");
        $('.message_other').removeClass('checked').addClass("default");
        $('.message_note').removeClass('checked').addClass("default");
        $(this).removeClass("default").addClass("checked");
        getNotifyByType("系统消息");
    });

    //其他消息点击事件
    $('.message_other').off('click').on('click',function () {
        $('.message_all').removeClass('checked').addClass("default");
        $('.message_note').removeClass('checked').addClass("default");
        $('.message_safe').removeClass('checked').addClass("default");
        $(this).removeClass("default").addClass("checked");
        getNotifyByType("其他消息");
    });

    //全部消息点击事件
    $('.message_all').off('click').on('click',function () {
        $('.message_other').removeClass('checked').addClass("default");
        $('.message_note').removeClass('checked').addClass("default");
        $('.message_safe').removeClass('checked').addClass("default");
        $(this).removeClass("default").addClass("checked");
        sendGet('${ctx}/user/prepareNotify',{},false,function (res) {
            //删除原来message_container里的内容
            $('#message_container').children().remove();
            showMessage($('#message_container'),res.notifies);
            initMessageUI();
        },function (error) {
            toastr.error("获取全部消息出错！");
        })
    })

    //        返回按钮事件
    $('.goback').on('click',function () {
        //向服务器发送请求，，获取数据
        $('#message_content_show').addClass('hidden');
        sendGet('${ctx}/user/prepareNotify',{},false,function (res) {
            //删除原来message_container里的内容
            $('#message_container').children().remove();
            showMessage($('#message_container'),res.notifies);
            initMessageUI();
        },function (error) {
            toastr.error("获取全部消息出错！");
        });
        $('#message_list_show').removeClass('hidden');
    });


    //全部标记为已读事件
    $('#all_read').off('click').on('click',function () {
        //获取当前消息类型
        var type = $('.checked').text();
        sendPost('${ctx}/user/readNotifyByType',{'type':type},false,function (res) {
            if(res.status) {
                toastr.success("标记成功");
                $('.read').css({"color":"gray"}).text("已读");
                $('.new_message').attr("src","${ctx}/images/read_notify.png");
            } else {
                toastr.error("标记失败");
            }
        },function (error) {
            toastr.error("系统错误");
        })
    });


    // 初始化事件
    function initMessageUI() {
        // 消息的点击事件
        $('.message_title').off('click').on('click',function () {
            //获取消息的id发送给服务器
            var name = $(this).text().trim();
            message_id = $(this).attr('index-id');
            //得到返回数据
            sendPost('${ctx}/user/getNotifyContent',{'id': message_id},false,function (res) {
                if(res.status) {
                    $("#message_content_title").text(name);
                    $("#message_content_body").text(res.info);
                } else {
                    toastr.error("获取消息内容错误");
                }
            },function (error) {
                toastr.error("系统错误");
            });

            //进入消息内容界面
            $('#message_list_show').addClass('hidden');
            $('#message_content_show').removeClass('hidden');
        });


        //标记为已读事件
        $('.read').off('click').on('click',function () {
            var $prev = $(this).parent().parent().find('.message_title');
            //把id发送给服务器
            var id = $prev.attr('index-id');
            var flag = false;
            sendPost('${ctx}/user/readNotify',{'id': id},false,function (res) {
                if(res.status) {
                    //改变css样式s
                    $prev.find('.message_title').css("color","gray");
                    $prev.find('.new_message').attr("src","${ctx}/images/read_notify.png");
                    flag = true;
                } else {
                    toastr.error("标记错误");
                }
            },function (error) {
                toastr.error("系统错误");
            });
            if(flag) {
                $(this).css({"color":"gray"});
                $(this).text("已读");
                initMessageUI();
            }
        });

        //列表页删除事件
        $('.remove_btn').off('click').on('click',function () {
            var $prev = $(this).parent().parent().find('.message_title');
            var $parent = $(this).parent().parent();
            //发送id给服务器
            var id = $prev.attr('index-id');
            sendPost('${ctx}/user/removeNotify',{'id': id},false,function (res) {
                if(res.status) {
                    toastr.success("删除成功");
                    initMessageUI();
                    $parent.remove();
                } else {
                    toastr.error("删除失败");
                }
            },function (error) {
                toastr.error("系统错误");
            });

        });

        //内容页删除事件
        $('.message_delete_btn').on('click',function () {
            sendPost('${ctx}/user/removeNotify',{'id': message_id},false,function (res) {
                if(res.status) {
                    toastr.success("删除成功");
                    //返回列表页 重新从服务器获取信息
                    $('#message_content_show').addClass('hidden');
                    $('#message_list_show').removeClass('hidden');
                    $('#message_container').children().remove();
                    sendGet('${ctx}/user/prepareNotify',{},false,function (res) {
                        var data = res.notifies;
                        for(var i=0; i<data.length; i++) {
                            var id = data[i].id;
                            var title = data[i].title;
                            var date = data[i].createDate;
                            var type = data[i].type;
                            var t;
                            // data[i].status : 1已读，2未读
                            if(data[i].status == 1) {
                                t = '<tr>\n' +
                                    '        <td><input type="checkbox" class="checkbox_message"></td>\n' +
                                    '        <td><a class="message_title" index-type="1" index-id="'+id+'">' +
                                    '        <img src="${ctx}/images/read_notify.png">'+title+'</a></td>\n' +
                                    '        <td><span class="message_time" >'+date+'</span></td>\n' +
                                    '        <td><span class="message_type" >'+type+'</span></td>\n' +
                                    '        <td><img class="remove_btn" src="${ctx}/images/delete.png" ></td>\n' +
                                    '        <td><a class="already_read" >已读</a></td>\n' +
                                    '    </tr>';


                            } else if(data[i].status == 2) {
                                t = '<tr>\n' +
                                    '        <td><input type="checkbox" class="checkbox_message"></td>\n' +
                                    '        <td><a class="message_title" index-type="1" index-id="'+id+'">' +
                                    '<img class="new_message" src="${ctx}/images/message.png">'+title+'</a></td>\n' +
                                    '        <td><span class="message_time" >'+date+'</span></td>\n' +
                                    '        <td><span class="message_type" >'+type+'</span></td>\n' +
                                    '        <td><img class="remove_btn" src="${ctx}/images/delete.png" ></td>\n' +
                                    '        <td><a class="read" >标记为已读</a></td>\n' +
                                    '    </tr>';
                            }
                            $("#message_container").append(t);
                            initMessageUI();
                        }
                    },function (error) {
                        toastr.error("系统错误");
                        return false;
                    });
                } else {
                    toastr.error("删除失败");
                }
            },function (error) {
                toastr.error("系统错误");
            });
        });
    }

    //checkbox 全选/取消全选
    var isCheckAll = false;
    $('#main_checkbox').off('click').on('click',function () {
        if (isCheckAll) {
            $("input[type='checkbox']").each(function() {
                this.checked = false;
            });
            isCheckAll = false;
        } else {
            $("input[type='checkbox']").each(function() {
                this.checked = true;
            });
            isCheckAll = true;
        }
    });


    //对选中的复选框所在的行删除
    $('#remove_all').off('click').on('click',function () {
        var id_array=new Array();
        $('input[class="checkbox_message"]:checked').each(function(){
            id_array.push($(this).parent().parent().find('.message_title').attr('index-id'));//向数组中添加元素
        });
        if(id_array.length > 0) {
            var msg = "确定要删除选中消息吗？";
            if(confirm(msg)) {
                window.location.href = '${ctx}/user/removeChoose?ids=' + id_array;
            }
        }
    })
</script>
</body>
</html>