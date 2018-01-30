<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<jsp:include page="left.jsp"/>

<body class="admin_body">

<!--主体-->
<div class="admin_container">
    <h2 class="admin_table_title">小黑屋</h2>
    <div id="toolbar" style="margin-right: 20px;">

        <button id="btn_delete" type="button" class="btn btn-default" onclick="delect_more()">
            <span class="glyphicon glyphicon-remove" aria-hidden="true">删除</span>
        </button>

    </div>
    <div class="admin_table_div">
        <table id="blackHomeTable" class="table table-responsive table-bordered tab-content table-hover"
               style="margin-right: 10%;">
        </table>
    </div>
</div>

<script>
    // 注册事件
    window.operateEvents = {
        'click .cancelBlacklist': function (e, value, row, index) {
            var id = row.id;
            var dblChoseAlert = simpleAlert({
                "content": "确定要解禁该用户吗？",
                "buttons": {
                    "确定": function () {
                        window.location.href = '${ctx}/admin/cancelBlacklist?id=' + id;
                        dblChoseAlert.close();
                    },
                    "取消": function () {
                        dblChoseAlert.close();
                    }
                }
            })
        },
        'click .delBlacklist': function (e, value, row, index) {
            var id = row.id;
            removeBlackList(id);
        }
    };

    function AddFunctionAlty(value, row, index) {
        if (row.status == "有效") {
            return ['  <button id="btn_detail" type="button" class="btn btn-default cancelBlacklist">\n' +
            '            <span class="glyphicon glyphicon-eye-open" aria-hidden="true" >解禁</span>\n' +
            '        </button>'].join("");
        } else if (row.status == "失效") {
            return ['  <button id="btn_delect" type="button" class="btn btn-default delBlacklist">\n' +
            '            <span class="glyphicon glyphicon-remove" aria-hidden="true" >删除</span>\n' +
            '        </button>'].join("");
        }
    }

    $(function () {
        sendGet('${ctx}/admin/prepareBlackHome', {}, false, function (value) {
            $table = $('#blackHomeTable').bootstrapTable(
                {
                    data: value,   //最终的JSON数据放在这里
                    striped: true,
                    cache: false,
                    height: 700,
                    toolbar: '#toolbar',
                    pagination: true,
                    sidePagination: "client",
                    pageNumber: 1,
                    pageSize: 10,
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
                            field: 'tel',
                            title: '账户',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'userName',
                            title: '用户名',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'illegalName',
                            title: '封禁原因',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'createDate',
                            title: '开始时间',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'endDate',
                            title: '结束时间',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'status',
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

    function delect_more() {
        var row = $(blackHomeTable).bootstrapTable('getSelections');
        removeBlackList(row);
    }

    function removeBlackList(obj) {
        var dblChoseAlert = simpleAlert({
            "content": "确定要删除该条记录吗？",
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
                    window.location.href = "${ctx}/admin/removeBlacklistRecord?ids=" + ids;
                    dblChoseAlert.close();
                },
                "取消": function () {
                    dblChoseAlert.close();
                }
            }
        })
    }
</script>
</body>
</html>