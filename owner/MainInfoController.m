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

@interface MainInfoController()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) MainOrderInfoView *infoView;

@property (strong, nonatomic) NSMutableArray<MainTaskInfo *> *arrayTask;

@end

@implementation MainInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维保任务"];
    [self initData];
    [self initView];
    [self getTask];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getTask];
}


- (void)initData
{
    _arrayTask = [NSMutableArray array];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.bounces = NO;
    
    _infoView = [MainOrderInfoView viewFromNib];
    
    _tableView.tableHeaderView = _infoView;
    
    _infoView.lbCode.text = _orderInfo.code;
    
    _infoView.lbDate.text = _orderInfo.createTime;
    
    _infoView.lbPay.text = [_orderInfo.isPay isEqualToString:@"1"] ? @"是" : @"否";
    
    _infoView.lbName.text = _orderInfo.maintypeName;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

#pragma mark - Network Request

- (void)getTask
{
    MainTaskListRequest *request = [[MainTaskListRequest alloc] init];
    
    request.maintOrderId = _orderInfo.orderId;
    
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
    
    if (!cell)
    {
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

@end
