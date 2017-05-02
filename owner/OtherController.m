//
//  OtherController.m
//  owner
//
//  Created by 长浩 张 on 2017/1/18.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OtherController.h"
#import "MainTypeCell.h"
#import "MainTypeDetailController.h"
#import "MainTypeInfo.h"
#import "MainOrderController.h"

@interface OtherController() <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation OtherController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"增值服务"];
    [self initView];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    
    //headview
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenWidth / 2)];
    
    _tableView.tableHeaderView = headView;
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenWidth / 2)];
    
    iv.image = [UIImage imageNamed:@"icon_other_banner.png"];
    
    [headView addSubview:iv];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:[MainTypeCell identifier]];
    
    if (!cell) {
        cell = [MainTypeCell cellFromNib];
    }
    
    cell.lbName.text = @"智能小助手";
    
    cell.lbContent.text = @"智能监控信息";
    
    cell.lbPrice.text = @"￥2000.0";
    
    __weak typeof (self) weakSelf = self;
    [cell setOnClickListener:^{
        MainTypeDetailController *controller = [[MainTypeDetailController alloc] init];
        
        controller.detail = @"智能监控信息";
        
        controller.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MainTypeCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTypeInfo *info = [[MainTypeInfo alloc] init];
    info.name = @"智能小助手";
    info.content = @"智能监控电梯运行";
    info.price = 2000.0f;
    info.typeId = @"4";
    
    MainOrderController *controller = [[MainOrderController alloc] init];
    controller.mainInfo = info;
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
