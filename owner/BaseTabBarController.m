//
//  BaseTabBarController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/23.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTabBarController.h"

@implementation BaseTabBarController


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

#pragma mark -- 设置状态栏字体为白色

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
