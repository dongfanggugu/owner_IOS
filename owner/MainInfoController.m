//
//  MainInfoController.m
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainInfoController.h"
#import "MainOrderInfoView.h"
#import "MainTaskInfo.h"
#import "MainTaskListResponse.h"
#import "MainTaskListRequest.h"
#import "RepairTaskCell.h"
#import "MainTaskDetailController.h"
#import "OrderListRequest.h"
#import "MainListResponse.h"
#import "PayOrderController.h"
#import "MainTypeDetailController.h"
#import "MainOrderController.h"
#import "ServiceHistoryController.h"

@interface MainInfoController() <UITableViewDelegate, UITableViewDataSource, MainOrderInfoViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) MainOrderInfoView *infoView;

@property (strong, nonatomic) NSMutableArray<MainTaskInfo *> *arrayTask;

@end

@implementation MainInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维保服务"];
    [self initNavRightWithText:@"查看历史"];
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getTask];
}

- (void)onClickNavRight
{
    ServiceHistoryController *controller = [[ServiceHistoryController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)initData
{
    _arrayTask = [NSMutableArray array];
}

- (Maint_Type)maintType
{
    return _serviceInfo.mainttypeId.integerValue;
}

- (void)initView
{
    if (!_serviceInfo) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 70, self.screenWidth - 32, 40)];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        
        label.numberOfLines = 0;
        
        label.text = @"您还没有订购有效的维保服务,请到服务->电梯管家中订制您的维保!";
        
        [self.view addSubview:label];
        
        return;
    }

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    
    //显示服务订单信息
    _infoView = [MainOrderInfoView viewFromNib];
    
    _tableView.tableHeaderView = _infoView;
    
    _infoView.delegate = self;
    
    _infoView.lbName.text = [_serviceInfo.maintypeInfo name];
    
    _infoView.lbPrice.text = [NSString stringWithFormat:@"￥%.2lf", [_serviceInfo.maintypeInfo price]];
    
    
    
    if (Maint_Low == self.maintType) {
        _infoView.lbInfo.text = [NSString stringWithFormat:@"剩余次数:%ld", _serviceInfo.frequency];
        
        _infoView.image = [UIImage imageNamed:@"icon_level_3"];
        
    } else if (Maint_Mid == self.maintType) {
        if (0 == _serviceInfo.expireTime) {
            _infoView.lbInfo.text = @"无效";
            
        } else {
            _infoView.lbInfo.text =  [NSString stringWithFormat:@"到期日期:%@", _serviceInfo.expireTime];
            
        }
        
        _infoView.image = [UIImage imageNamed:@"icon_level_2"];
        
    } else {
        if (0 == _serviceInfo.expireTime) {
            _infoView.lbInfo.text = @"无效";
            
        } else {
            _infoView.lbInfo.text =  [NSString stringWithFormat:@"到期日期:%@", _serviceInfo.expireTime];
            
        }
        
        _infoView.image = [UIImage imageNamed:@"icon_level_1"];
    }
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

#pragma mark - Network Request


- (void)getTask
{
    if (!_serviceInfo) {
        return;
    }
    MainTaskListRequest *request = [[MainTaskListRequest alloc] init];
    
    request.maintOrderId = _serviceInfo.orderId;
    
    [[HttpClient shareClient] post:URL_MAIN_TASK parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        MainTaskListResponse *response = [[MainTaskListResponse alloc] initWithDictionary:responseObject];
        
        [_arrayTask removeAllObjects];
        
        [_arrayTask addObjectsFromArray:[response getTaskList]];
        
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

//0待确认 1已确认 2已完成 3已评价
- (NSString *)getStateDes:(NSInteger)state
{
    NSString *res = @"";
    
    switch (state) {
        case 0:
            res = @"待确认";
            break;
        case 1:
            res = @"已确认";
            break;
        case 2:
            res = @"已完成";
            break;
        case 3:
            res = @"已评价";
            break;
            
        default:
            break;
    }
    
    return res;
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayTask.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepairTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:[RepairTaskCell identifier]];
    
    if (!cell) {
        cell = [RepairTaskCell cellFromNib];
    }
    
    MainTaskInfo *info = _arrayTask[indexPath.row];
    
    cell.lbCode.text = info.taskCode;
    
    cell.lbState.text = [self getStateDes:info.state.integerValue];
    
    cell.lbInfo.text = [NSString stringWithFormat:@"%@ %@", info.maintUserInfo.name, info.maintUserInfo.tel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RepairTaskCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MainTaskDetailController *controller = [[MainTaskDetailController alloc] init];
    controller.taskInfo = _arrayTask[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - MainOrderInfoViewDelegate

- (void)onClickPayButton
{
    MainOrderController *controller = [[MainOrderController alloc] init];
    controller.mainInfo =  _serviceInfo.maintypeInfo;
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickOrderButton
{
    PayOrderController *controller = [[PayOrderController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickDetailButton
{
    MainTypeDetailController *controller = [[MainTypeDetailController alloc] init];
    
    controller.detail = _serviceInfo.maintypeInfo.content;
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)onClickBackButton
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"maintOrderId"] = _serviceInfo.orderId;
    
    [[HttpClient shareClient] post:@"deleteMaintOrder" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithText:@"维保服务退订成功,您可以到服务->电梯管家中购买新的服务"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

@end
