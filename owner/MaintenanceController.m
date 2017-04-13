//
//  MaintenanceController.m
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MaintenanceController.h"
#import "MainTypeCell.h"
#import "MainTypeInfo.h"
#import "MainTypeListResponse.h"
#import "MainOrderController.h"
#import "MainTypeDetailController.h"


@interface MaintenanceController()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<MainTypeInfo *> *arrayType;

@end


@implementation MaintenanceController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维保服务"];
    
    [self initData];
    [self initView];
    [self getMainType];
}


- (void)initData
{
    _arrayType = [NSMutableArray array];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}


#pragma mark - Network Request

- (void)getMainType
{
    [[HttpClient shareClient] view:self.view post:URL_MAIN_TYPE parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        MainTypeListResponse *response = [[MainTypeListResponse alloc] initWithDictionary:responseObject];
        
        [_arrayType addObjectsFromArray:[response getMainTypeList]];
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayType.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:[MainTypeCell identifier]];
    
    if (!cell)
    {
        cell = [MainTypeCell cellFromNib];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MainTypeInfo *info = _arrayType[indexPath.row];
    
    cell.lbName.text = info.name;
    cell.lbPrice.text = [NSString stringWithFormat:@"(￥%.1lf)", info.price];
    cell.lbContent.text = info.content;
    
    [cell setOnClickListener:^{
        MainTypeDetailController *controller = [[MainTypeDetailController alloc] init];
        
        controller.detail = info.content;
        
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MainTypeCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MainTypeInfo *info = _arrayType[indexPath.row];
    MainOrderController *controller = [[MainOrderController alloc] init];
    controller.mainInfo = info;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
