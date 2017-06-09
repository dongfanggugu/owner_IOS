//
//  HelpWebViewController.m
//  owner
//
//  Created by 长浩 张 on 2017/5/11.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "HelpWebViewController.h"

@interface HelpWebViewController () <UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation HelpWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"电梯常识"];
    [self initView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)popup {
    if ([self.webView canGoBack]) {
        [self.webView goBack];

    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)initView {
    self.automaticallyAdjustsScrollViewInsets = NO;

    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight)];

    _webView.scrollView.bounces = NO;

    _webView.delegate = self;

    [self.view addSubview:_webView];

    NSString *urlString = [NSString stringWithFormat:@"%@static/h5/nous.html", [Utils getIp]];

    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *url = webView.request.URL.absoluteString;
    NSLog(@"url:%@", url);

    if ([url containsString:@"indexPage"]) {
        [self setNavTitle:@"整梯销售"];

    } else if ([url containsString:@"message"]) {
        [self setNavTitle:@"留言"];

    } else if ([url containsString:@"elevatorInfoPage"]
            || [url containsString:@"elevatorDetailPage"]) {
        [self setNavTitle:@"详情"];

    } else if ([url containsString:@"indexelevatorDecorationPage"]) {
        [self setNavTitle:@"电梯装潢"];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.webView canGoBack]) {
        [self.webView goBack];

    } else {
        [self.navigationController popViewControllerAnimated:YES];

    }
    return NO;
}


@end
