<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<jsp:include page="left.jsp"/>

<body class="admin_body">

<!--主体-->
<div class="admin_container">
    <h2 class="admin_table_title">分享审核</h2>
    <div id="toolbar" style="margin-right: 20px;">
        <button id="btn_delete" type="button" class="btn btn-default" onclick="delete_more()">
            <span class="glyphicon glyphicon-remove" aria-hidden="true">删除</span>
        </button>
    </div>
    <div class="admin_table_div2">
        <table id="shareAuditTable" class="table table-responsive table-bordered tab-content table-hover"
               style="margin-right: 10%;">
        </table>
    </div>
</div>

<script>
    window.operateEvents = {
        'click .detail': function (e, value, row, index) {
            var url = row.shareUrl;
            window.open(url);
        },
        'click .cancel': function (e, value, row, index) {
            var msg = "确定要取消该分享吗？";
            if (confirm(msg)) {
                var id = row.id;
                window.location.href = '${ctx}/admin/cancelShare?id=' + id;
            } else {
                return false;
            }
        },
        'click .del': function (e, value, row, index) {
            var id = row.id;
            deleteArticle(id);
        }
    };

    function AddFunctionAlty(value, row, index) {
        return ['  <button id="btn_detail" type="button" class="btn btn-default detail">\n' +
        '            <span class="glyphicon glyphicon-search" aria-hidden="true" >查看</span>\n' +
        '        </button>',
            '  <button id="btn_cancel" type="button" class="btn btn-default cancel">\n' +
            '            <span class="glyphicon glyphicon-remove" aria-hidden="true" >取消</span>\n' +
            '        </button>',
            '  <button id="btn_delect" type="button" class="btn btn-default del">\n' +
            '            <span class="glyphicon glyphicon-trash" aria-hidden="true" >删除</span>\n' +
            '        </button>'].join("")
    }

    $(function () {
        sendGet('${ctx}/admin/prepareShareAudit', {}, false, function (value) {
            $table = $('#shareAuditTable').bootstrapTable(
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
                            field: 'authorTel',
                            title: '手机号',
                            align: 'center',
                            valign: 'center',
                            sortable: false
                        },
                        {
                            field: 'authorName',
                            title: '用户名称',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'title',
                            title: '笔记标题',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'star',
                            title: 'Star数',
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

    function delete_more() {
        var row = $(shareAuditTable).bootstrapTable('getSelections');
        deleteArticle(row);
    }

    function deleteArticle(obj) {
        var msg = "删除后将不进入用户回收站，确定删除吗？";
        if (confirm(msg)) {
            var ids = new Array();
            if (typeof (obj) == "string") {
                ids.push(obj);
            } else if (typeof (obj) == "object") {
                for (var i = 0; i < obj.length; i++) {
                    ids.push(obj[i].id);
                }
            }
            window.location.href = '${ctx}/admin/deleteArticle?ids=' + ids;
        } else {
            return false;
        }
    }

</script>
</body>
</html>