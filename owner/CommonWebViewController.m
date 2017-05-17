//
//  CommonWebViewController.m
//  owner
//
//  Created by 长浩 张 on 2017/5/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "CommonWebViewController.h"

@interface CommonWebViewController () <UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation CommonWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:_titleStr];
    [self initView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)popup
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    
    _webView.scrollView.bounces = NO;
    
    _webView.delegate = self;
    
    [self.view addSubview:_webView];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlLink]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebViewDelegate


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    return NO;
}

@end
