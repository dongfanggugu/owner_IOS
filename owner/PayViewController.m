//
//  PayViewController.m
//  owner
//
//  Created by 长浩 张 on 2017/5/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "PayViewController.h"

@interface PayViewController ()

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation PayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"订单支付"];
    [self initView];
}


- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 64)];
    navView.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];

    btn.center = CGPointMake(30, 42);

    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

    [navView addSubview:btn];

    //标题
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];

    label.text = @"订单支付";

    label.font = [UIFont systemFontOfSize:17];

    label.textColor = [UIColor whiteColor];

    label.textAlignment = NSTextAlignmentCenter;

    label.center = CGPointMake(self.screenWidth / 2, 42);

    [navView addSubview:label];


    [self.view addSubview:navView];

    //webview
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    [self.view addSubview:_webView];

    NSURL *url = [NSURL URLWithString:_urlStr];

    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)back
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickBack)])
    {
        [_delegate clickBack];
    }

    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

@end
