function sendGet(_url,_data,_async,_successCallback,_errorCallback) {
    $.ajax({
        type:'get',
        async:_async,
        url:_url,
        dataType:'json',
        data:_data,
        success:function (msg) {
            _successCallback(msg);
        },
        error:function (error) {
            _errorCallback(error);
        }
    });
}

function sendPost(_url,_data,_async,_successCallback,_errorCallback) {
    $.ajax({
        type:'post',
        async:_async,
        url:_url,
        dataType:'json',
        data:_data,
        success:function (msg) {
            _successCallback(msg);
        },
        error:function (error) {
            _errorCallback(error);
        }
    });
}

function sendPostByText(_url,_data,_async,_successCallback,_errorCallback) {
    $.ajax({
        type:'post',
        async:_async,
        url:_url,
        dataType:'text',
        data:_data,
        success:function (msg) {
            _successCallback(msg);
        },
        error:function (error) {
            _errorCallback(error);
        }
    });
}


