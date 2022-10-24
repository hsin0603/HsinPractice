var Request = {
    Post: function (_url, _data, _success, _error, _async) {
        _async = _async ? _async : true; 
        $.ajax({
            type: 'POST',
            url: _url,
            data: JSON.stringify(_data),
            dataType: 'json',
            success: function (result) {
                $('#Loading').hide();
                if (typeof (_success) === "function") {
                    _success(result);
                }
            },
            beforeSend: function () {
                $('#Loading').show();
            },
            error: function (result) {
                $('#Loading').hide();
                if (typeof (_error) === "function") {
                    _error(result);
                }
            }
        });
    },
    Get: function (_url, _data, _success, _error, _async) {
        _async = _async ? _async : true;
        $.ajax({
            type: 'GET',
            url: _url,
            data: _data,
            dataType: 'text',
            success: function (result) {
                $('#Loading').hide();
                if (typeof (_success) === "function") {
                    _success(result);
                }
            },
            beforeSend: function () {
                $('#Loading').show();
            },
            error: function (result) {
                $('#Loading').hide();
                if (typeof (_error) === "function") {
                    _error(result);
                }
            }
        });
    }
}