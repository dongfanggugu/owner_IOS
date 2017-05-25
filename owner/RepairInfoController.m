//
//  RepairInfoController.m
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RepairInfoController.h"
#import "RepairTaskRequest.h"
#import "RepairTaskResponse.h"
#import "RepairInfoView.h"
#import "EvaluateView.h"
#import "RepairTaskCell.h"
#import "RepairTaskDetailController.h"
#import "RepairEvaluateRequest.h"


@interface RepairInfoController()<UITableViewDelegate, UITableViewDataSource, EvaluateViewDelegate>


@property (strong, nonatomic) UITableView *tableView;

//@property (strong, nonatomic) RepairInfoView *infoView;

@property (strong, nonatomic) EvaluteView *evaluateView;

@property (strong, nonatomic) NSMutableArray<RepairTaskInfo *> *arrayTask;

@end


@implementation RepairInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维修任务"];
    [self initData];
    [self initView];
    [self getTask];
}

- (void)initData
{
    _arrayTask = [NSMutableArray array];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
     _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    RepairInfoView *infoView = [RepairInfoView viewFromNib];
    
    
    infoView.lbCode.text = [NSString stringWithFormat:@"订单编号: %@", _orderInfo.code];
    
    infoView.lbDate.text = [NSString stringWithFormat:@"订单时间: %@", _orderInfo.createTime];
    
    infoView.lbAppoint.text = [NSString stringWithFormat:@"预约时间: %@", _orderInfo.repairTime];
    
    infoView.lbFault.text = [NSString stringWithFormat:@"故障类型: %@", _orderInfo.repairTypeInfo[@"name"]];
    
    infoView.lbFaultDes.text = _orderInfo.phenomenon;
    
    [infoView.ivFault setImageWithURL:[NSURL URLWithString:_orderInfo.picture]];
    
    infoView.lbAddress.text = [NSString stringWithFormat:@"别墅地址: %@", _houseInfo[@"cellName"]];
    
    infoView.lbBrand.text = [NSString stringWithFormat:@"电梯品牌: %@", _houseInfo[@"brand"]];
    
     infoView.lbWeight.text = [NSString stringWithFormat:@"电梯载重量: %.0lfkg    层站:%ld层", [_houseInfo[@"weight"] floatValue], [_houseInfo[@"layerAmount"] integerValue]];
    
    _tableView.tableHeaderView = infoView;
    
    
    
//    NSInteger state = _orderInfo.state.integerValue;
//    
//    if (8 == state) {
//        _evaluateView = [EvaluteView viewFromNib];
//        _evaluateView.frame = CGRectMake(0, 124 + labelHeight, self.screenWidth, 240);
//        
//        _evaluateView.delegate = self;
//        
//        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 124 + labelHeight + 240)];
//        
//        [headerView addSubview:infoView];
//        [headerView addSubview:desKey];
//        [headerView addSubview:desLabel];
//        [headerView addSubview:_evaluateView];
//        
//        _tableView.tableHeaderView = headerView;
//        
//    } else if (9 == state) {
//        _evaluateView = [EvaluteView viewFromNib];
//        [_evaluateView setModeShow];
//        [_evaluateView setStar:_orderInfo.evaluate.integerValue];
//        [_evaluateView setContent:_orderInfo.evaluateInfo];
//        _evaluateView.frame = CGRectMake(0, 124 + labelHeight, self.screenWidth, 240);
//        
//        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 124 + labelHeight + 240)];
//        
//        [headerView addSubview:infoView];
//        [headerView addSubview:desKey];
//        [headerView addSubview:desLabel];
//        [headerView addSubview:_evaluateView];
//        
//        _tableView.tableHeaderView = headerView;
//
//    } else {
//        
//        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 124 + labelHeight)];
//        
//        [headerView addSubview:infoView];
//        [headerView addSubview:desKey];
//        [headerView addSubview:desLabel];
//        
//        _tableView.tableHeaderView = headerView;
//    }
    
    [self.view addSubview:_tableView];
}


//1待出发 2已出发 3工作中 5检修完成 6维修完成
- (NSString *)getStateDes:(NSInteger)state
{
    NSString *res = @"";
    
    switch (state) {
        case 1:
            res = @"待出发";
            break;
        case 2:
            res = @"已出发";
            break;
        case 3:
            res = @"工作中";
            break;
        case 5:
            res = @"检修完成";
            break;
        case 6:
            res = @"维修完成";
            break;
            
        default:
            break;
    }
    
    return res;
}

#pragma mark - Network Request

- (void)getTask
{
    RepairTaskRequest *request = [[RepairTaskRequest alloc] init];
    
    request.repairOrderId = _orderInfo.orderId;
    
    [[HttpClient shareClient] post:URL_REPAIR_TASK parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        RepairTaskResponse *response = [[RepairTaskResponse alloc] initWithDictionary:responseObject];
        
        [_arrayTask removeAllObjects];
        
        [_arrayTask addObjectsFromArray:[response getTaskList]];
        
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
    return _arrayTask.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepairTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:[RepairTaskCell identifier]];
    
    if (!cell) {
        cell = [RepairTaskCell cellFromNib];
    }
    
    RepairTaskInfo *info = _arrayTask[indexPath.row];
    
    cell.lbCode.text = info.code;
    
    cell.lbState.text = [self getStateDes:info.state.integerValue];
    
    cell.lbWorker.text = [NSString stringWithFormat:@"维修人员:%@", info.workerName];
    
    cell.lbTel.text = [NSString stringWithFormat:@"联系电话:%@", info.workerTel];
    
    cell.lbDate.text = [NSString stringWithFormat:@"维修时间:%@", info.createTime];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RepairTaskCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    RepairTaskDetailController *controller = [[RepairTaskDetailController alloc] init];
//    controller.taskInfo = _arrayTask[indexPath.row];
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark - EvaluateViewDelegate

- (void)onSubmit:(NSInteger)star content:(NSString *)content
{
    RepairEvaluateRequest *request = [[RepairEvaluateRequest alloc] init];
    request.repairOrderId = _orderInfo.orderId;
    request.evaluate = [NSString stringWithFormat:@"%ld", star];
    request.evaluateInfo = content;
    
    [[HttpClient shareClient] post:URL_REPAIR_EVALUATE parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithText:@"评价已经提交"];
        [self performSelector:@selector(back) withObject:nil afterDelay:1.0f];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
