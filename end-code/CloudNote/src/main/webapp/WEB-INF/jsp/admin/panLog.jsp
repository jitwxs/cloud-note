<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<jsp:include page="left.jsp"/>

<body>
<!--主体-->
<div class="container" style="height: 1000px;width: 100%; text-align: center;">
    <h2 style="margin-bottom: 30px;">网盘日志</h2>
    <div id="toolbar" style="margin-right: 20px;">

        <button id="btn_delete" type="button" class="btn btn-default" onclick="delect_more()">
            <span class="glyphicon glyphicon-remove" aria-hidden="true">删除</span>
        </button>

    </div>
    <div style="width: 80%;float: right;margin-right: 50px;">
        <table id="panLogTable" class="table table-responsive table-bordered tab-content table-hover" style="margin-right: 10%;">
        </table>
    </div>
</div>

<script>
    //    注册事件
    window.operateEvents = {
        'click .detail': function (e, value, row, index) {
            var logId = row.id;
            showLog(logId);
        },
        'click .del': function (e, value, row, index) {
            var logId = row.id;
            var url = 'panLog';
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
        sendGet('${ctx}/admin/preparePanLog',{},false,function (value) {
            $table = $('#panLogTable').bootstrapTable(
                {
                    data: value,   //最终的JSON数据放在这里
                    striped: true,
                    cache: false,
                    height:700,
                    toolbar:'#toolbar',
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
                    clickToSelect:true,
                    showToggle:true,
                    cardView: false,    //是否显示详细视图
                    detaView:false,
                    showExport: true,//显示导出按钮
                    exportTypes:  ['excel','json', 'xml', 'txt', 'sql'],
                    columns: [
                        {
                            field:"checked",
                            checkbox:true
                        },
                        {
                            field: 'title',
                            title: 'title',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'ip',
                            title: 'ip',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'userName',
                            title: 'userName',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'requestUrl',
                            title: 'requestUrl',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'createDate',
                            title: 'createDate',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'params',
                            title: 'params',
                            width: 200,
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'method',
                            title: 'method',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field:"button",
                            title:"operate",
                            align: 'center',
                            formatter:AddFunctionAlty,
                            events:operateEvents
                        }
                    ]
                })
        },function (error) {
            toastr.error("系统错误");
            return false;
        });
    })

    function delect_more() {
        var row = $(panLogTable).bootstrapTable('getSelections');
        var url = 'panLog';
        deleteLog(row, url);
    }

</script>
</body>

</html>