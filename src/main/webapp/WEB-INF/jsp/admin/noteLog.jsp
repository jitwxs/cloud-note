<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<jsp:include page="left.jsp"/>

<body class="admin_body">
<!--主体-->
<div class="admin_container">
    <h2 class="admin_table_title">笔记日志</h2>
    <div id="toolbar" style="margin-right: 20px;">

        <button id="btn_delete" type="button" class="btn btn-default" onclick="delect_more()">
            <span class="glyphicon glyphicon-remove" aria-hidden="true">删除</span>
        </button>

    </div>
    <div class="admin_table_div2">
        <table id="noteTable" class="table table-responsive table-bordered tab-content table-hover"
               style="margin-right: 10%;">
        </table>
    </div>
</div>

<script>
    window.operateEvents = {
        'click .detail': function (e, value, row, index) {
            var logId = row.id;
            showLog(logId);
        },
        'click .del': function (e, value, row, index) {
            var logId = row.id;
            var url = 'noteLog';
            deleteLog(logId, url);
        }
    };

    function AddFunctionAlty(value, row, index) {
        return ['  <button id="btn_detail" type="button" class="btn btn-default detail">\n' +
        '            <span class="glyphicon glyphicon-search" aria-hidden="true" ></span>\n' +
        '        </button>',
            '  <button id="btn_delect" type="button" class="btn btn-default del">\n' +
            '            <span class="glyphicon glyphicon-remove" aria-hidden="true" ></span>\n' +
            '        </button>'].join("")
    }

    $(function () {
        sendGet('${ctx}/admin/prepareNoteLog', {}, false, function (value) {
            $table = $('#noteTable').bootstrapTable(
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
                            field: 'title',
                            title: '标题',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'ip',
                            title: 'IP',
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
                            field: 'requestUrl',
                            title: '请求路径',
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
                            field: 'params',
                            title: '参数',
                            width: 200,
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'method',
                            title: '方法',
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
        var row = $(noteTable).bootstrapTable('getSelections');
        var url = 'noteLog';
        deleteLog(row, url);
    }

</script>
</body>

</html>