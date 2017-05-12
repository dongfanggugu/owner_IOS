//
//  BaseViewController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/22.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@interface BaseViewController() <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UILabel *lbTitle;

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavIcon];
    [self initNaviTitle];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.navigationController) {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (CGFloat)screenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

- (CGFloat)screenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

- (BOOL)login
{
    NSString *userId = [[Config shareConfig] getUserId];
    
    return userId.length;
}

- (void)setNavTitle:(NSString *)title
{
    if (!self.navigationController) {
        return;
    }
    
    _lbTitle.text = title;
}

- (void)initNaviTitle
{
    if (!self.navigationController) {
        return;
    }
    
    _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    
    _lbTitle.font = [UIFont systemFontOfSize:17];
    _lbTitle.textColor = [UIColor whiteColor];
    [_lbTitle setTextAlignment:NSTextAlignmentCenter];
    [self.navigationItem setTitleView:_lbTitle];
}

/**
 使用文字初始化导航栏右侧按钮
 **/
- (void)initNavRightWithText:(NSString *)text
{
    if (!self.navigationController) {
        return;
    }
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 60, 60)];
    [btnRight setTitle:text forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:13];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    if ([self respondsToSelector:@selector(onClickNavRight)]) {
        [btnRight addTarget:self action:@selector(onClickNavRight) forControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 使用文字初始化导航栏右侧按钮
 **/
- (void)initNavRightWithImage:(UIImage *)image
{
    if (!self.navigationController) {
        return;
    }
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btnRight setImage:image forState:UIControlStateNormal];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    if ([self respondsToSelector:@selector(onClickNavRight)]) {
        [btnRight addTarget:self action:@selector(onClickNavRight) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (void)onClickNavRight
{
    
}

- (void)popup
{
//    if ([self.webView canGoBack]) {
//        [self.webView goBack];
//        
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNavIcon
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    imageView.image = [UIImage imageNamed:@"back_normal"];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popup)]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    self.navigationItem.leftBarButtonItem = item;
}


- (void)dealloc
{
    NSLog(@"%@ dealloc", [self class]);
}

#pragma mark -- 设置状态栏字体为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
