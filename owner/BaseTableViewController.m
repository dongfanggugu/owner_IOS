//
//  BaseTableViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/7/7.
//
//

#import <Foundation/Foundation.h>
#import "BaseTableViewController.h"

@interface BaseTableViewController ()


@end


@implementation BaseTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];

}

- (CGFloat)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

- (BOOL)login {
    NSString *userId = [[Config shareConfig] getUserId];

    return userId.length;
}

- (CGFloat)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}


- (void)setNavTitle:(NSString *)title {
    if (!self.navigationController) {
        return;
    }

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    label.text = title;
    label.font = [UIFont fontWithName:@"System" size:17];
    label.textColor = [UIColor whiteColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.navigationItem setTitleView:label];
}

/**
 使用图片初始化导航栏右侧按钮
 **/
- (void)initNavRightWithImage:(UIImage *)image {
    if (!self.navigationController) {
        return;
    }

    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [btnRight setImage:image forState:UIControlStateNormal];

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:btnRight];

    self.navigationItem.rightBarButtonItem = rightButton;

    [btnRight addTarget:self action:@selector(onClickNavRight) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClickNavRight {
}


- (void)dealloc {
    NSLog(@"%@ dealloc", [self class]);
}

#pragma mark -- 设置状态栏字体为白色

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
