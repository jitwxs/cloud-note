function sendGet(_url,_successCallback,_errorCallback) {
    $.ajax({
        type:'get',
        async:false,
        url:_url,
        success:function (msg) {
            _successCallback(msg.data);
        },
        error:function (error) {
            _errorCallback(error);
        }
    });
}

function sendPost(_url,_data,_successCallback,_errorCallback) {
    $.ajax({
        type:'post',
        async:false,
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


