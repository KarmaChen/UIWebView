//
//  ViewController.m
//  UIWebView
//
//  Created by Karma on 16/5/17.
//  Copyright © 2016年 陈昆涛. All rights reserved.
//

#import "ViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface ViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
{
    UIWebView *webView;
    UIButton *button;
}
@property (nonatomic,strong) NJKWebViewProgressView *_progressView;
@property (nonatomic,strong) NJKWebViewProgress *_progressProxy;
@end

@implementation ViewController
@synthesize _progressProxy,_progressView;
BOOL flag;
- (void)viewDidLoad {
    [super viewDidLoad];
    //创建
    webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //网络资源
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];//创建url（统一资源定位符，互联网标准资源的地址）
    NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:url];//创建NSURLRequest
    [webView loadRequest:urlRequest];//加载
    
    
    //设置属性
    webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    [webView setUserInteractionEnabled:YES];//是否支持交互
    [self.view addSubview:webView];
    webView.delegate=self;
    
    //回退
    UIButton *goBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0, 40, 30)];
    goBackBtn.backgroundColor = [UIColor redColor];
    [goBackBtn setTitle:@"回退" forState:UIControlStateNormal];
    [goBackBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBackBtn];
    goBackBtn.enabled = webView.canGoBack;
    //前进
    UIButton *goForwardBtn = [[UIButton alloc]initWithFrame:CGRectMake(50,20, 40,30)];
    goForwardBtn.backgroundColor = [UIColor grayColor];
    [goForwardBtn setTitle:@"前进" forState:UIControlStateNormal];
    [goForwardBtn addTarget:self action:@selector(goForward:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:goForwardBtn];
    //设置刷新和取消载入按钮
    UIButton *reLoadBtn = [[UIButton alloc]initWithFrame:CGRectMake(90, 0, 40, 30)];
    reLoadBtn.backgroundColor = [UIColor grayColor];
    [reLoadBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [reLoadBtn addTarget:self action:@selector(reLoad:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *stopLoadingBtn = [[UIButton alloc]initWithFrame:CGRectMake(150, 0, 40, 30)];
    stopLoadingBtn.backgroundColor = [UIColor grayColor];
    [stopLoadingBtn setTitle:@"取消" forState:UIControlStateNormal];
    [stopLoadingBtn addTarget:self action:@selector(stopLoading:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:reLoadBtn];
    [self.view addSubview:stopLoadingBtn];
    
    //切换本地和网络
    flag =NO;
    button = [[UIButton alloc]initWithFrame:CGRectMake(150, 0, 40, 30)];
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:@"网络" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //设置代理
    webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
}
//用NJKWebViewProgress中的代理方法实现进度条的加载动画
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self._progressView setProgress:progress animated:YES];
}
//在viewWillAppear方法中将进度条添加到父视图
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:_progressView];
}
//在viewWillDisappear方法中将进度条从父视图中移除
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self._progressView removeFromSuperview];
}



//是否允许UIWebView加载请求的方法
//当返回值为NO，表示不允许加载此请求
//可以用作询问是否加载网页
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
//当WebView已经开始加载一个请求后，得到通知。
- (void)webViewDidStartLoad:(UIWebView *)webView;{
    NSLog(@"开始加载");
}
//当WebView完成加载一个请求之后，得到通知。
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"加载完成");
}
//当WebView在请求加载中发生错误时，得到通知。提供一个NSSError对象，以标识所发生错误类型。
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    NSLog(@"error:%@",error);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//返回功能实现
-(void)goBack: (NSString *) goBackbtn{
    [webView goBack];
}
//前进功能实现
-(void)goForward: (NSString *) goForwardbtn{
    
    [webView goForward];
    
}
//刷新功能实现
-(void)reLoad: (NSString *) reLoadbtn{
    
    [webView reload];
    
}
//停止加载功能实现
-(void)stopLoading: (NSString *) stopLoadingbtn{
    
    [webView stopLoading];
    
}
//button用来切换本地资源和网络资源
-(void)change{
    if (flag) {
        flag = NO;
        [button setTitle:@"网络" forState:UIControlStateNormal];
        [button setTitle:@"本地" forState:UIControlStateHighlighted];
        
        //网络资源
        NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];//创建url（统一资源定位符，互联网标准资源的地址）
        NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:url];//创建NSURLRequest
        [webView loadRequest:urlRequest];//加载
    }else{
        flag = YES;
        [button setTitle:@"本地" forState:UIControlStateNormal];
        [button setTitle:@"网络" forState:UIControlStateHighlighted];
        
        //本地资源
        NSString* filePath = [[NSBundle mainBundle]pathForResource:@"1" ofType:@"jpg"];//本地资源路径
        NSURL* localUrl = [NSURL fileURLWithPath:filePath];//创建本地资源URL
        NSURLRequest* request = [NSURLRequest requestWithURL:localUrl];//创建NSURLRequest
        [webView loadRequest:request];//加载
        
    }
    
}

@end
