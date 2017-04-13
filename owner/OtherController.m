//
//  OtherController.m
//  owner
//
//  Created by 长浩 张 on 2017/1/18.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OtherController.h"

@interface OtherController()

@property (weak, nonatomic) IBOutlet UIView *viewOther1;

@property (weak, nonatomic) IBOutlet UIView *viewOther2;

@property (weak, nonatomic) IBOutlet UIView *viewOther3;

@property (weak, nonatomic) IBOutlet UIView *viewOther4;

@end

@implementation OtherController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"我要咨询"];
    [self initView];
}

- (void)initView
{
    _viewOther1.layer.masksToBounds = YES;
    _viewOther1.layer.cornerRadius = 30;
    
    _viewOther2.layer.masksToBounds = YES;
    _viewOther2.layer.cornerRadius = 30;
    
    _viewOther3.layer.masksToBounds = YES;
    _viewOther3.layer.cornerRadius = 30;
    
    _viewOther4.layer.masksToBounds = YES;
    _viewOther4.layer.cornerRadius = 30;
}

@end
