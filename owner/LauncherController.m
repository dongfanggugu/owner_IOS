//
//  LauncherController.m
//  owner
//
//  Created by 长浩 张 on 17/1/9.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LauncherController.h"
#import "CDPGifScrollView.h"
#import "AppDelegate.h"

@interface LauncherController ()

@end

@implementation LauncherController


- (void)viewDidLoad
{
    [super viewDidLoad];


    NSMutableArray *dataArr = [[NSMutableArray alloc] init];

    NSString *file = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"gif_welcome"] ofType:@"gif"];

    [dataArr addObject:file];

    CDPGifScrollView *gifScrollView = [[CDPGifScrollView alloc] initWithGifImageArr:dataArr
                                                                           andFrame:CGRectMake(0, 0,
                                                                                   self.view.bounds.size.width, self.view.bounds.size.height)];

    [self.view addSubview:gifScrollView];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];


    [NSTimer scheduledTimerWithTimeInterval:4.5 target:self
                                   selector:@selector(login) userInfo:nil repeats:NO];

}

- (void)login
{

    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    window.rootViewController = [board instantiateViewControllerWithIdentifier:@"main_tab_bar_controller"];

}


@end
