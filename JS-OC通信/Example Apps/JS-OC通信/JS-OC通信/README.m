
//作者QQ： 835848450

// 史上最简单的 JS-OC 通信方法 （不需要依赖任或导入何框架，只需要预定参数格式即可）， Android 同理可用


/*

           调用Native参数及回参约定
 
PS：所有传参和回参都使用JSON来作为媒介并进行编码或解码。
Web调用native
Web 调用native 参数:
invokeName：执行native的action 名称。
callbackName:回调函数名称
parameter：参数对象
请求的url规格：
wfy://%7B"invokeName":"calendar","parameter":%7B%7D%7D
当前参数进行过编码转换。

未转码之前：
wfy:// {invokeName:"calendar",parameter:{},callbackName:””}


native响应 web
native 调用 web 公共js函数communication，参数：
result：返回json结果集。(必须为JSON格式数据)
callbackName：回调函数方法名。
格式如下：{ callbackName :’test’, result{} }

result结果根据前端需求而自定义。

请对当前JSON进行转码操作之后以字符串形式传入communicationhan函数里。

示例：

// 获取token

window.onload = function(){
    bridge.invoke({invokeName:"getToken",callbackName:"tokenFn",parameter:{}},function(data){
        alert(data.userToken); //返回值里面的关键字段名
        alert(data.userCacheKey);
        alert(data.userGuid);
        alert(data.userPnoneNum);
        alert(data.userName);
        alert(data.userCompanyNum);
    });
}


//  返回主页（清除webview）

invokeName:" goBackToHomePage"


//  返回登录（服务器 500 错误）

invokeName:" goBackToLogin"


注：在iOS8时 带有//协议头（wfy：//{****}）可能不会被识别;解决方案：（wfy:{*****}）

*/
