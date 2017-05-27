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
#import "EvaluateController.h"
#import "RepairPaymentController.h"


@interface RepairInfoController () <UITableViewDelegate, UITableViewDataSource, RepairInfoViewDelegate>


@property (strong, nonatomic) UITableView *tableView;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
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
    
    infoView.delegate = self;
    
    infoView.lbCode.text = [NSString stringWithFormat:@"订单编号: %@", _orderInfo.code];
    
    infoView.lbDate.text = [NSString stringWithFormat:@"订单时间: %@", _orderInfo.createTime];
    
    infoView.lbAppoint.text = [NSString stringWithFormat:@"预约时间: %@", _orderInfo.repairTime];
    
    infoView.lbFault.text = [NSString stringWithFormat:@"故障类型: %@", _orderInfo.repairTypeInfo[@"name"]];
    
    infoView.lbFaultDes.text = _orderInfo.phenomenon;
    
    [infoView.ivFault setImageWithURL:[NSURL URLWithString:_orderInfo.picture]];
    
    infoView.lbAddress.text = [NSString stringWithFormat:@"别墅地址: %@", _houseInfo[@"cellName"]];
    
    infoView.lbBrand.text = [NSString stringWithFormat:@"电梯品牌: %@", _houseInfo[@"brand"]];
    
    infoView.lbWeight.text = [NSString stringWithFormat:@"电梯载重量: %.0lfkg    层站:%ld层", [_houseInfo[@"weight"] floatValue], [_houseInfo[@"layerAmount"] integerValue]];
    
    NSInteger state = _orderInfo.state.integerValue;
    
    if (9 == state) {
        [infoView.btnEvaluate setTitle:@"查看评价" forState:UIControlStateNormal];
    }
    
    NSInteger isPay = _orderInfo.isPayment.integerValue;
    
    if (1 == isPay) {
        [infoView.btnOrder setTitle:@"查看支付" forState:UIControlStateNormal];
    }
    
    
    _tableView.tableHeaderView = infoView;
    
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


- (void)onClickEvaluate
{
    EvaluateController *controller = [[EvaluateController alloc] init];
    
    NSInteger state = _orderInfo.state.integerValue;
    
    if (9 == state) {
        controller.enterType = Show;
        controller.content = _orderInfo.evaluateInfo;
        controller.star = _orderInfo.evaluate.integerValue;
        
    } else {
        controller.enterType = Repair_Submit;
        controller.repairOrderInfo = _orderInfo;
    }
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickPay
{
    NSInteger isPay = _orderInfo.isPayment.integerValue;
    
    RepairPaymentController *controller = [[RepairPaymentController alloc] init];
    
    if (1 == isPay) {
        controller.enterType = Repair_Show;
        controller.payTime = _orderInfo.payTime;
        
    } else {
        controller.enterType = Repair_Pay;
        controller.orderId = _orderInfo.orderId;
    }
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
