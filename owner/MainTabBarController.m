//
//  MainTabBarController.m
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainTabBarController.h"
#import "PersonController.h"
#import "BaseNavigationController.h"

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initItem];
    [self initTabBar];
}

- (void)initItem {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];


    UIViewController *service = [board instantiateViewControllerWithIdentifier:@"main_page"];


    UIViewController *person = [[PersonController alloc] init];

    BaseNavigationController *nav = [[BaseNavigationController alloc] init];

    [nav pushViewController:person animated:YES];

    self.viewControllers = [NSArray arrayWithObjects:service, nav, nil];
}

- (void)initTabBar {
    UITabBar *tabBar = self.tabBar;

    tabBar.tintColor = [Utils getColorByRGB:TITLE_COLOR];
    [[tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"icon_service_bottom"]];
    [[tabBar.items objectAtIndex:0] setTitle:@"服务"];

    [[tabBar.items objectAtIndex:1] setImage:[UIImage imageNamed:@"icon_person_bottom"]];
    [[tabBar.items objectAtIndex:1] setTitle:@"我的"];
}


@end
