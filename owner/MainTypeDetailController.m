//
//  MainTypeDetailController.m
//  owner
//
//  Created by 长浩 张 on 2017/3/6.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainTypeDetailController.h"

@implementation MainTypeDetailController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"服务详情"];
    [self initView];
}


- (void)initView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 70, self.self.screenWidth - 32, 0)];

    label.font = [UIFont systemFontOfSize:14];

    label.lineBreakMode = NSLineBreakByWordWrapping;

    label.text = _detail;

    label.numberOfLines = 0;

    [label sizeToFit];

    [self.view addSubview:label];
}

@end
