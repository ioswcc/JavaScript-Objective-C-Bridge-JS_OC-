//
//  ViewController.m
//  JS-OC通信
//
//  Created by wuchangcai on 16/5/27.
//  Copyright © 2016年 www.wuchangcai.com. All rights reserved.

//作者QQ： 835848450

// 史上最简单的 JS-OC 通信方法，Android 同理可用
// 不需要依赖任或导入何框架，只需要预定参数格式即可

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic, weak) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addWebView];
}
/**
 *  创建 webView
 */
- (void)addWebView
{
    self.webView.delegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    // 伸缩页面至填充整个webView
    _webView.scalesPageToFit = YES;
    
    //    //加载mainBundle 拖入工程里的 html）
    //   NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];//加载mainBundle
    //    NSURL *baseURL1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@SalaryBaoH/modules/salary/html/",baseURL]];
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"salary" ofType:@"html" inDirectory:@"SalaryBaoH/modules/salary/html"];
    //    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //     [_webView loadHTMLString:html baseURL:baseURL1];
    //    [self.view addSubview:_webView];
    
    //加载mainBundle 拖入工程里的 html）2
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];//加载mainBundle
    NSURL *baseURL1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",baseURL]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index2" ofType:@"html" inDirectory:@""];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:html baseURL:baseURL1];
    [self.view addSubview:_webView];
    
    //   //加载deskTop 在电脑硬盘上的 html
    //    NSURLRequest *deskTop = [NSURLRequest requestWithURL:[NSURL URLWithString:@"/Users/admin/Desktop/SalaryBaoH/modules/salary/html/salary.html"]];
    //    [_webView loadRequest:deskTop];
    //    [self.view addSubview:_webView];
    
    //    //加载 互联网网上的 html
    //    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    //    [_webView loadRequest:req];
    //    [self.view addSubview:_webView];
    //
    //
    
}


#pragma mark -----------  UIWebViewDelegate   ----------------------------------
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSLog(@"request.URL: %@",request.URL);
    NSRange range = [url rangeOfString:@"wfy://"];
    NSUInteger loc = range.location;
    if (loc != NSNotFound) {
        NSString *jsonstr_utf8 = [url substringFromIndex:loc + range.length];
        NSString *jsonstr = [jsonstr_utf8 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"jsonstr: %@",jsonstr);
         NSData *jsondata = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
//        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:json? options:0 error:nil];
        
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsondata options:0 error:nil];
//         NSString* jsonstr2 = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
//         NSLog(@"jsonstr2: %@", jsonstr2);
         NSLog(@"dic%@",dic);
        
        NSString *method = dic[@"invokeName"];
        SEL sel = NSSelectorFromString(method);
        NSLog(@"需要OC执行的方法： %@",method);
        [self performSelector:sel withObject:nil afterDelay:0.01];
    }
    return YES;
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError:%@", error);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *htmltitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title;"];
    self.title = htmltitle;
    //解决webView内存泄露
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark -----------  H5页面（invokeName）想调用的 方法   ----------------------------------
/**
 *   示例2 获取token （需要给 H5页面 回传参数）
 */
- (void)openCalendar
{
    NSLog(@"openCalendar");
    NSMutableDictionary *resuleDic = [NSMutableDictionary dictionary];
    [resuleDic setObject:@"xiaoqiang" forKey:@"name"];
    [resuleDic setObject:@"17" forKey:@"age"];
    [resuleDic setObject:@"women" forKey:@"sex"];
    
    NSMutableDictionary *MuDic = [NSMutableDictionary dictionary];
    [MuDic setObject:@"calendarFn" forKey:@"callbackName"];
    [MuDic setObject:resuleDic forKey:@"result"];
    
    NSLog(@"MuDic%@", MuDic);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:MuDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr%@", jsonStr);
    //('%@')  参数要加 ‘’  ！！！
    NSString *JSONStr_utf8 = [jsonStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//UTF8 加工
    NSLog(@"JSONStr_utf8: %@", JSONStr_utf8);
    NSString *js = [NSString stringWithFormat:@"javascript:window.bridge.communication('%@')",JSONStr_utf8];
    NSString *result = [_webView stringByEvaluatingJavaScriptFromString:js];//注意线程阻塞
//    NSLog(@"_webView'result%@", result);
}
/**
 *   示例1 获取token （需要给 H5页面 回传参数）
 */
- (void)getToken
{
    
    NSMutableDictionary *resuleDic = [NSMutableDictionary dictionary];
    [resuleDic setObject:@"userToken" forKey:@"userToken"];
    [resuleDic setObject:@"userCacheKey" forKey:@"userCacheKey"];
    [resuleDic setObject:@"1378888888" forKey:@"userPnoneNum"];
    [resuleDic setObject:@"userName" forKey:@"userName"];
    [resuleDic setObject:@"userCompanyNum" forKey:@"userCompanyNum"];
    [resuleDic setObject:@"userID" forKey:@"userID"];
    
    NSMutableDictionary *MuDic = [NSMutableDictionary dictionary];
    [MuDic setObject:@"tokenFn" forKey:@"callbackName"];
    [MuDic setObject:resuleDic forKey:@"result"];
    
    
    NSLog(@"MuDic: %@", MuDic);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:MuDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     NSLog(@"jsonStr: %@", jsonStr);
    NSString *JSONStr_utf8 = [jsonStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//UTF8 加工
     NSLog(@"JSONStr_utf8: %@", JSONStr_utf8);
    //('%@')  参数要加 ‘’  ！！！
    NSString *js = [NSString stringWithFormat:@"javascript:window.bridge.communication('%@')",JSONStr_utf8];
    NSString *result = [_webView stringByEvaluatingJavaScriptFromString:js];//注意线程阻塞
//    NSLog(@"_webView'result%@", result);

}


/**
 *  返回主页 （不需要给 H5页面 回传参数）
 */
- (void)goBackToHomePage
{
     NSLog(@"返回主页");
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/**
 *  返回登录页面（不需要给 H5页面 回传参数）
 */
- (void)goBackToLogin
{
     NSLog(@"返回登录页面");
}

/**
 *   示例 （不需要给 H5页面 回传参数）
 */
- (void)call
{
    NSLog(@"call");
}
/**
 *   示例 （不需要给 H5页面 回传参数）
 */
- (void)openCamera
{
    NSLog(@"openCamera");
}



#pragma mark -----------  getter   ----------------------------------

- (UIWebView *)webView
{
    if (!_webView) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        self.webView = webView;
    }
    return _webView;
}

- (void)dealloc
{
    self.webView = nil;
    self.webView.delegate = nil;
    //    NSLog(@"dealloc");
    
}



#pragma mark -----------  其他说明   ----------------------------------
/*
 iOS中对字符串进行UTF-8编码：输出str字符串的UTF-8格式
 
 [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 
 
 解码：把str字符串以UTF-8规则进行解码
 
 [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 
 */


@end

