((function () {
    //注册桥接对象
    var bridge = {};

    /*
     *  数据仓库
     * */
    var dataStorage = ((function () {

        var _callbacks = {};

        var _userAgent = navigator.userAgent;

        var _url = "wfy://";

        return {
            /*
             * 增加回调函数
             * @callbackName:key
             * fn:执行方法
             * */
            addCallBack: function (callbackName, fn) {
                _callbacks[callbackName] = fn;
            },
            /*
             * 获得回调函数对象
             * */
            getAllCallbacks: function () {
                return _callbacks;
            },
            /*
            *
            * 删除回调函数
            *
            * */
            deleteCallbakcs:function(key){
                delete _callbacks[key];
            },
            /*
             * 获取版本信息
             *
             * */
            getUserAgent: function () {
                return _userAgent;
            },
            /*
             *
             * 获得跟Native通信的URL
             *
             * */
            getUrl: function () {
                return _url;
            },
            /*
             *
             * 设置url
             *
             * */
            setUrl: function (url) {
                _url = url;
            }
        }
    }))();


    /*
     *
     * 调用Native
     * @param:{
     *   invokeName:调用名,
     *   parameter:传递参数,
     *   callBackName:回调函数名称
     * }
     * callback:回调函数
     *
     * */
    var invoke = function (param, callback) {
        if (!param) {
            console.error("This is an empty object!");
            return;
        }

        if (!param.invokeName) {
            console.error("There is no invokeName in the current object");
            return;
        }

        if(!param.Parameter){
            param.Parameter ={};
        }

        if (callback) {
            //对回调函数进行存储
            dataStorage.addCallBack(param.callbackName, callback);
        }

        //开始调用请求
        window.location.href = generateUrl(dataStorage.getUrl(), param);
    };

    /*
     * 根据指定的请求头和参数拼成一个完整的请求链接并且对参数进行转码操作
     * url:请求头
     * parameter:参数
     * invokeName:调用名
     * */
    var generateUrl = function (url, param) {
        var paramStr = JSON.stringify(param);
        var fullUrl = url + encodeURI(paramStr);
        return fullUrl;
    };


        /*
         *
         * Native和web之间的通信
         * opt:{
         *   callbackName:回调函数名称
         *   result:JSON结果集
         * }
         *
         * */
    var communication = function (opt) {
        if (opt) {
            if (typeof opt === "string") {
                try {
                   // opt = JSON.parse(decodeURI(opt));
                    opt=JSON.parse(decodeURIComponent(opt));
                } catch (e) {
                    alert("communication Method: opt is not a JSON object");
                    console.log("communication Method: opt is not a JSON object");
                    return;
                }
            }
  
            //调用相对应的回调函数
            var callback = dataStorage.getAllCallbacks()[opt.callbackName ? opt.callbackName : ""];
            var result = opt.result ? opt.result : {};
            //Native自主调用web函数并自调
            if (callback) {
                try {
                    //执行回调函数并给与结果集
                    if (typeof result === "string") {
                        try {
                            result = JSON.parse(decodeURIComponent(result));
                        } catch (e) {
                            alert("communication Method: result is not a JSON object");
                            console.log("communication Method: result is not a JSON object");
                            return;
                        }
                    }
                    callback(result);
                    delete callback;
                } catch (e) {
                    console.log("The error message:" + e.message);
                    return;
                }
            } else {
                console.error("Current there is no this function");
                return;
            }
        }
    };

        /*
         * 对象深拷贝并且不拷贝原型链上的属性
         * */
    var deepCopy = function (source) {
        var result = {};
        for (var key in source) {
            if (source.hasOwnProperty(key)) {
                result[key] = typeof source[key] === 'object' ? deepCopy(source[key]) : source[key];
            }

        }
        return result;
    };

    //Web调用Native操作
    bridge.invoke = invoke;
    //Native和web之间的通信方法
    bridge.communication = communication;
    //提供开发数据
    bridge.dataStorage = dataStorage;

    window.bridge = bridge;

}))();


