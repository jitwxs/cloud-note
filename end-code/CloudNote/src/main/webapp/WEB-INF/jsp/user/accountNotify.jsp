<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<jsp:include page="settingHead.jsp"/>

<body style="background: #ededed">

<!--消息推送主体区域-->
<div  id="message_list_show" >

    <!--消息导航栏-->
    <div id="message_nav" >
        <a class="message_all">全部</a>
        <a class="message_safe">系统消息</a>
        <a class="message_note">笔记消息</a>
        <a class="message_other">其他消息</a>
    </div>

    <!--消息区域-->
    <div id="message_main" >
        <div id="message_main_nav" >
            <p style="margin-left: 20px">消息</p>
            <p style="margin-left: 700px">时间</p>
            <p style="margin-left: 150px;">消息类型</p>
            <p style="margin-left: 100px">操作</p>
        </div>
        <!--消息列表-->
        <div id="message_container">
        </div>
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
                t = '<div class="message">\n' +
                    '                        <a class="message_title" index-type="1" index-id="'+id+'" >\n' +
                    '                        <img src="${ctx}/images/alreadread.png">'+title+'</a>\n' +
                    '                        <a class="already_read" >已读</a>\n' +
                    '                        <img class="remove_btn" src="${ctx}/images/delete.png">\n' +
                    '                        <span class="message_type" >'+type+'</span>\n' +
                    '                        <span class="message_time" >'+date+'</span>\n' +
                    '                        </div>';


            } else if(data[i].status == 2) {
                t = '<div class="message" >\n' +
                    '                <a class="message_title" index-type="2" index-id="'+id+'" >\n' +
                    '                    <img class="new_message" src="${ctx}/images/message.png">'+title+'</a>\n' +
                    '                <a class="read" >标记为已读</a>\n' +
                    '                <img class="remove_btn" src="${ctx}/images/delete.png" >\n' +
                    '                <span class="message_type" >'+type+'</span>\n' +
                    '                <span class="message_time" >'+date+'</span>\n' +
                    '            </div>';
            }
            $item.append(t);
        }
    }

    function getNotifyByType(type) {
        sendGet('${ctx}/user/prepareNotifyByType',{"dataType":type},false,function (data) {
            //删除原来message_container里的内容
            $('#message_container').children().remove();
            showMessage($('#message_container'),data);
            initmessageUI();
        },function (error) {
            toastr.error("获取笔记消息出错！");
        })
    }

    // 初始化消息列表
    sendGet('${ctx}/user/prepareNotify',{},false,function (data) {
        //全部消息
        showMessage($('#message_container'),data);
    },function (error) {
        toastr.error("系统错误");
        return false;
    });

    initmessageUI();

    //笔记消息点击事件
    $('.message_note').off('click').on('click',function () {
        getNotifyByType("笔记消息");
    });

    //系统消息点击事件
    $('.message_safe').off('click').on('click',function () {
        getNotifyByType("系统消息");
    });

    //其他消息点击事件
    $('.message_other').off('click').on('click',function () {
        getNotifyByType("其他消息");
    });

    //全部消息点击事件
    $('.message_all').off('click').on('click',function () {
        sendGet('${ctx}/user/prepareNotify',{},false,function (data) {
            //删除原来message_container里的内容
            $('#message_container').children().remove();
            showMessage($('#message_container'),data);
            initmessageUI();
        },function (error) {
            toastr.error("获取全部消息出错！");
        })
    })

    //        返回按钮事件
    $('.goback').on('click',function () {
        //向服务器发送请求，，获取数据
        $('#message_content_show').addClass('hidden');
        $('#message_list_show').removeClass('hidden');
    });

    //初始化事件
    function initmessageUI() {


        //消息的点击事件
        $('.message_title').off('click').on('click',function () {
            //获取消息的id发送给服务器
            var name = $(this).text().trim();
            message_id = $(this).attr('index-id');
            //得到返回数据
            sendPost('${ctx}/user/getNotifyContent',{'id': message_id},false,function (res) {
                $("#message_content_title").text(name);
                $("#message_content_body").text(res);
            },function (error) {
                toastr.error("系统错误");
            });

            //进入消息内容界面
            $('#message_list_show').addClass('hidden');
            $('#message_content_show').removeClass('hidden');
        });


        //标记为已读事件
        $('.read').off('click').on('click',function () {
            var $prev = $(this).prev();
            //把id发送给服务器
            var id = $prev.attr('index-id');
            var flag = false;
            sendPost('${ctx}/user/readNotify',{'id': id},false,function (res) {
                if(res.status) {
                    //改变css样式s
                    $prev.find('.message_title').css("color","gray");
                    $prev.find('.new_message').attr("src","${ctx}/images/alreadread.png");
                    flag = true;
                } else {
                    toastr.error("标记错误");
                }
            },function (error) {
                toastr.error("系统错误");
            });
            if(flag) {
                $(this).css({"color":"gray","margin-right":"142px"});
                $(this).text("已读");
            }
        });

        //列表页删除事件
        $('.remove_btn').off('click').on('click',function () {
            var $prev = $(this).prev().prev();
            var $parent = $(this).parent();
            //发送id给服务器
            var id = $prev.attr('index-id');
            sendPost('${ctx}/user/removeNotify',{'id': id},false,function (res) {
                if(res.status) {
                    toastr.success("删除成功");
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
                    sendGet('${ctx}/user/prepareNotify',{},false,function (data) {
                        for(var i=0; i<data.length; i++) {
                            var id = data[i].id;
                            var title = data[i].title;
                            var date = data[i].createDate;
                            var type = data[i].type;
                            var t;
                            // data[i].status : 1已读，2未读
                            if(data[i].status == 1) {
                                t = '<div class="message">\n' +
                                    '                        <a class="message_title" index-type="1" index-id="'+id+'" >\n' +
                                    '                        <img src="${ctx}/images/alreadread.png">'+title+'</a>\n' +
                                    '                        <a class="already_read" >已读</a>\n' +
                                    '                        <img class="remove_btn" src="${ctx}/images/delete.png">\n' +
                                    '                        <span class="message_type" >'+type+'</span>\n' +
                                    '                        <span class="message_time" >'+date+'</span>\n' +
                                    '                        </div>';


                            } else if(data[i].status == 2) {
                                t = '<div class="message" >\n' +
                                    '                <a class="message_title" index-type="2" index-id="'+id+'" >\n' +
                                    '                    <img class="new_message" src="${ctx}/images/message.png">'+title+'</a>\n' +
                                    '                <a class="read" >标记为已读</a>\n' +
                                    '                <img class="remove_btn" src="${ctx}/images/delete.png" >\n' +
                                    '                <span class="message_type" >'+type+'</span>\n' +
                                    '                <span class="message_time" >'+date+'</span>\n' +
                                    '            </div>';
                            }
                            $("#message_container").append(t);
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
</script>
</body>
</html>