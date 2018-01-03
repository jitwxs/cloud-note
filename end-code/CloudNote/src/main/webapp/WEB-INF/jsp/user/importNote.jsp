<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<div class="modal fade" id="importNoteModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="myModalLabel">导入文件</h4>
            </div>
            <div class="modal-body">
                <div class="file-box">
                    <form class="form-horizontal" id="importNoteForm" role="form" action="${ctx}/user/saveUserInfo"
                          method="post">
                        <div class="form-group ">
                          <label class="col-sm-2 control-label">上传文件</label>
                          <div class="col-sm-10">
                                <input type="file" style="margin-top: 7px" name="uploadFile" />
                          </div>
                        </div>
                    </form>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">导入</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>
