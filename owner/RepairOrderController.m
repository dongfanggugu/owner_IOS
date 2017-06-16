//
//  RepairOrderController.m
//  owner
//
//  Created by 长浩 张 on 2017/4/26.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "RepairOrderController.h"
#import "OrderListRequest.h"
#import "OrderInfoCell.h"
#import "RepairListResponse.h"
#import "RepairInfoController.h"
#import "DialogEditView.h"
#import "HouseChangeView.h"
#import "ListDialogData.h"
#import "ListDialogView.h"
#import "OrderMaintCell.h"

@interface RepairOrderController () <UITableViewDelegate, UITableViewDataSource, HouseChangeViewDelegate, ListDialogViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayOrder;

@property (strong, nonatomic) IBOutlet HouseChangeView *headView;

@property (strong, nonatomic) NSDictionary *houseInfo;

@property (strong, nonatomic) NSMutableArray *arrayHouse;

@end

@implementation RepairOrderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"快修订单"];
    [self initView];
    [self getHouses];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (NSMutableArray *)arrayOrder
{
    if (!_arrayOrder)
    {
        _arrayOrder = [NSMutableArray array];
    }

    return _arrayOrder;
}

- (NSMutableArray *)arrayHouse
{
    if (!_arrayHouse)
    {
        _arrayHouse = [NSMutableArray array];
    }

    return _arrayHouse;
}

/**
 设置别墅信息
 
  */
- (void)setHouseInfo:(NSDictionary *)houseInfo
{
    _houseInfo = houseInfo;

    if (_headView)
    {
        _headView.lbContent.text = houseInfo[@"cellName"];
    }
    [self getRepair];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _tableView.delegate = self;
    _tableView.dataSource = self;


    _headView = [HouseChangeView viewFromNib];

    _headView.delegate = self;

    _tableView.tableHeaderView = _headView;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:_tableView];

}

- (NSString *)getStateDes:(NSInteger)state
{
    NSString *res = @"";

    if (1 == state)
    {
        res = @"待确认";

    }
    else if (2 == state)
    {
        res = @"已确认";

    }
    else if (4 == state)
    {
        res = @"已委派";

    }
    else if (6 == state)
    {
        res = @"维修中";

    }
    else if (7 == state)
    {
        res = @"待完成";
    }
    else if (8 == state)
    {
        res = @"待评价";

    }
    else if (9 == state)
    {
        res = @"已评价";
    }

    return res;
}


#pragma mark - Network Request

/**
 villaId
 brand
 model
 cellName
 address
 lng
 lat
 weight
 layerAmount
 contacts
 contactsTel
 */
- (void)getHouses
{
    [[HttpClient shareClient] post:URL_GET_HOUSE parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.arrayHouse removeAllObjects];
        [self.arrayHouse addObjectsFromArray:responseObject[@"body"]];
        [self showHouselist];

    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}

- (void)showHouselist
{
    if (0 == self.arrayHouse.count)
    {
        return;
    }

    if (1 == self.arrayHouse.count)
    {

        self.houseInfo = self.arrayHouse[0];
        _headView.btnHidden = YES;
        return;
    }

    if (!self.houseInfo)
    {
        self.houseInfo = self.arrayHouse[0];
    }

    NSMutableArray *array = [NSMutableArray array];

    for (NSDictionary *info in self.arrayHouse)
    {
        ListDialogData *data = [[ListDialogData alloc] initWithKey:info[@"id"] content:info[@"cellName"]];
        [array addObject:data];
    }

    ListDialogView *dialog = [ListDialogView viewFromNib];
    dialog.delegate = self;
    [dialog setData:array];
    [dialog show];
}

#pragma mark - LisDialogViewDelegate

- (void)onSelectItem:(NSString *)key content:(NSString *)content
{
    for (NSDictionary *info in self.arrayHouse)
    {
        if ([key isEqualToString:info[@"id"]])
        {
            self.houseInfo = info;
            break;
        }
    }
}

- (void)getRepair
{
    if (!_houseInfo)
    {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"villaId"] = _houseInfo[@"id"];

    [[HttpClient shareClient] post:URL_REPAIR_LIST parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        RepairListResponse *response = [[RepairListResponse alloc] initWithDictionary:responseObject];
        [self.arrayOrder removeAllObjects];
        [self.arrayOrder addObjectsFromArray:[response getOrderList]];
        [_tableView reloadData];
    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayOrder.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderMaintCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderMaintCell identifier]];

    if (!cell)
    {
        cell = [OrderMaintCell cellFromNib];
    }

    RepairOrderInfo *orderInfo = self.arrayOrder[indexPath.section];

    cell.lbCode.text = [NSString stringWithFormat:@"编号: %@", orderInfo.code];
    cell.lbTime.text = orderInfo.createTime;
    cell.lbName.text = orderInfo.villaInfo[@"cellName"];

    NSString *fault = orderInfo.repairTypeInfo[@"name"];
    cell.lbType.text = [NSString stringWithFormat:@"故障类型: %@", fault];

    cell.lbState.text = [self getStateDes:orderInfo.state.integerValue];

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OrderMaintCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepairInfoController *controller = [[RepairInfoController alloc] init];
    controller.orderInfo = self.arrayOrder[indexPath.section];
    controller.houseInfo = _houseInfo;

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - HouseInfoViewDelegate

- (void)onClickBtn:(HouseChangeView *)view
{
    if (0 == self.arrayHouse.count)
    {
        [HUDClass showHUDWithText:@"您需要先添加别墅"];
        return;
    }

    if (1 == self.arrayHouse.count)
    {
        [HUDClass showHUDWithText:@"您当前有一栋别墅,暂不需要切换别墅"];
        return;
    }

    [self showHouselist];
}


@end
