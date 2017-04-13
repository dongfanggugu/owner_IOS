//
//  ElevatorSellController.m
//  owner
//
//  Created by 长浩 张 on 2017/3/28.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "ElevatorSellController.h"

@interface ElevatorSellController ()

@end

@implementation ElevatorSellController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"整体销售"];
    [self initView];
}


- (void)initView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    
    imageView.image = [UIImage imageNamed:@"icon_sell"];
    
    imageView.userInteractionEnabled = YES;
    
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detail)]];
    
    [self.view addSubview:imageView];
}

- (void)detail
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
