<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html>

<jsp:include page="left.jsp"/>

<body class="admin_body">
<div class="admin_container">
    <div class="row" style="margin-bottom: 50px;">
            <form class="form-horizontal" id="notify_form">
                <div class="form-group">
                    <label class="col-sm-2 control-label">消息类型</label>
                    <div class="col-sm-10">
                        <label class="radio-inline">
                            <input type="radio" name="notifyTypeRadio" value="系统消息" checked> 系统消息
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="notifyTypeRadio" value="笔记消息"> 笔记消息
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="notifyTypeRadio" value="其他消息"> 其他消息
                        </label>
                    </div>
                </div>
                <div class="form-group">
                    <label for="inputTitle" class="col-sm-2 control-label">标题</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="inputTitle" name="title" maxlength="64">
                    </div>
                </div>
                <div class="form-group">
                    <label for="inputContent" class="col-sm-2 control-label">消息内容</label>
                    <div class="col-sm-10">
                        <textarea class="form-control" id="inputContent" name="content" rows="3" maxlength="255"></textarea>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">接收用户</label>
                    <div class="col-sm-10">
                        <div class="radio">
                            <label>
                                <input type="radio" id="allUserRadio" name="nameTypeRadios" value="所有用户">
                                所有用户
                            </label>
                        </div>
                        <div class="radio">
                            <label>
                                <input type="radio" name="nameTypeRadios" value="指定用户">
                                指定用户
                            </label>
                        </div>
                        <input type="text" class="form-control" id="user_choose" name="tel" list="itemList" disabled>
                        <datalist id="itemList">
                        </datalist>
                    </div>
                </div>
                    <div class="col-sm-offset-2 col-sm-10">
                        <button type="reset" class="btn btn-default">重置</button>
                        <button type="button" class="btn btn-default" onclick="sendNotify()">提交</button>
                    </div>
            </form>
        </div>
    <hr />
    <div  style="margin-top: 0px;height: 500px;">
        <div id="toolbar" style="margin-right: 20px;">
            <button id="btn_delete" type="button" class="btn btn-default" onclick="delete_more()">
                <span class="glyphicon glyphicon-remove" aria-hidden="true">删除</span>
            </button>
        </div>
        <div class="admin_table_div2">
            <table id="systemNotifyTable" class="table table-responsive table-bordered tab-content" style="margin-right: 10%;">
            </table>
        </div>
    </div>
</div>
</body>

<script type="text/javascript">
    $('input[type=radio][name=nameTypeRadios]').change(function() {
        if (this.value == '所有用户') {
            $("#user_choose").val("");
            $("#user_choose").attr("disabled","disabled");
        }
        else if (this.value == '指定用户') {
            $("#user_choose").removeAttr("disabled");
        }
    });

    $("#user_choose").bind('input propertychange', function() {
        var tel = $("#user_choose").val();
        sendPost('${ctx}/admin/listTels',{'tel':tel},true,function (res) {
            if(res.status) {
                $('#itemList').html('');

                for (var i= 0;i<res.list.length;i++) {
                    $('#itemList').append('<option>'+res.list[i]+'</option>')
                }
            }
        },function (error) {
            toastr.error("获取用户出错！");
        });
    });

    function sendNotify() {
        var tel;
        var type = $('input:radio[name="notifyTypeRadio"]:checked').val();
        var title = $("#inputTitle").val();
        var content = $("#inputContent").val();

        if(title == null || title == "") {
            toastr.warning("标题不能为空");
            return false;
        } else if(content == null || content == "") {
            toastr.warning("内容不能为空");
            return false;
        }

        var val=$('input:radio[name="nameTypeRadios"]:checked').val();
        if(val == "所有用户") {
            tel = "EveryBody";
        } else if(val == "指定用户") {
            tel = $('#user_choose').val();
            if(tel == null || tel == "") {
                toastr.warning("接收用户不能为空");
                return false;
            }
        }

        sendPost('${ctx}/admin/sendNotify',{'type': type, 'title':title,'content':content, 'tel':tel},false,function (msg) {
            if (msg.status) {
                toastr.success("发送成功！");
                location.reload(true);
            } else {
                toastr.warning("发送失败！");
            }
        },function (error) {
            toastr.error("系统错误");
        });
    }

    window.operateEvents = {
        'click .del': function (e, value, row, index) {
            var id = row.id;
            deleteNotify(id);
        }
    };

    function AddFunctionAlty(value, row, index) {
        return ['  <button id="btn_delect" type="button" class="btn btn-default del">\n' +
            '            <span class="glyphicon glyphicon-remove" aria-hidden="true" ></span>\n' +
            '        </button>'].join("")
    }

    function delete_more() {
        var row = $(systemNotifyTable).bootstrapTable('getSelections');
        deleteNotify(row);
    }

    function deleteNotify (obj) {
        var dblChoseAlert = simpleAlert({
            "content": "确定要删除选中信息吗？",
            "buttons": {
                "确定": function () {
                    var ids = new Array();
                    if (typeof (obj) == "string") {
                        ids.push(obj);
                    } else if (typeof (obj) == "object") {
                        for (var i = 0; i < obj.length; i++) {
                            ids.push(obj[i].id);
                        }
                    }
                    window.location.href = "${ctx}/admin/deleteNotify?ids=" + ids;
                    dblChoseAlert.close();
                },
                "取消": function () {
                    dblChoseAlert.close();
                }
            }
        })
    }

    $(function () {
        var val=$('input:radio[name="nameTypeRadios"]:checked').val();
        if(val == "所有用户") {
            $("#user_choose").val("");
            $("#user_choose").attr("disabled","disabled");
        } else if(val == "指定用户") {
            $("#user_choose").removeAttr("disabled");
        }

        sendGet('${ctx}/admin/prepareSystemNotify', {}, false, function (value) {
            $table = $('#systemNotifyTable').bootstrapTable(
                {
                    data: value,   //最终的JSON数据放在这里
                    striped: true,
                    cache: false,
                    height: 400,
                    toolbar: '#toolbar',
                    pagination: true,
                    sidePagination: "client",
                    pageNumber: 1,
                    pageSize: 5,
                    pageList: [5, 10, 20],
                    showColumns: true,
                    minimunCountColumns: 2,
                    sort: false,
                    sortOrder: "asc",
                    search: true,
                    showRefresh: true,
                    clickToSelect: true,
                    showToggle: true,
                    cardView: false,    //是否显示详细视图
                    detaView: false,
                    showExport: true,//显示导出按钮
                    exportTypes: ['excel', 'json', 'xml', 'txt', 'sql'],
                    columns: [
                        {
                            field: "checked",
                            checkbox: true
                        },
                        {
                            field: 'type',
                            title: '类型',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'sendUserType',
                            title: '发送者权限',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'sendUser',
                            title: '发送者',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'recvUser',
                            title: '接收者',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'title',
                            title: '标题',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'content',
                            title: '内容',
                            width: 200,
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'createDate',
                            title: '创建时间',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'statusName',
                            title: '状态',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: "button",
                            title: "操作",
                            align: 'center',
                            formatter: AddFunctionAlty,
                            events: operateEvents
                        }
                    ]
                })
        }, function (error) {
            toastr.error("系统错误");
            return false;
        });
    });
</script>
</html>