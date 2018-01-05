<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<style>
    .fileinput-button {
        position: relative;
        display: inline-block;
        overflow: hidden;
    }

    .fileinput-button input{
        position:absolute;
        right: 0px;
        top: 0px;
        opacity: 0;
        -ms-filter: 'alpha(opacity=0)';
        font-size: 200px;
    }
</style>
<div class="modal fade" id="importNoteModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="myModalLabel">导入文件</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="importNoteForm" role="form" action="${ctx}/user/saveImportNote"
                      method="post" enctype="multipart/form-data">
                    <input type="hidden" id="userId" name="id">
                    <div class="form-group">
                        <label for="importNote" class="col-sm-2 control-label">上传文件</label>
                        <div class="col-sm-7">
                            <span class="btn btn-success fileinput-button">
                                <span>浏览...</span>
                                <input type="file" id="importNote" name="importNote">
                            </span><br><br>
                            <label id="fileName"></label>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">导入</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>
