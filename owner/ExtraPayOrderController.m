//
//  ExtraPayOrderController.m
//  owner
//
//  Created by 长浩 张 on 2017/5/5.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "ExtraPayOrderController.h"
#import "PayInfoCell.h"
#import "PayViewController.h"
#import "MainTypeInfo.h"
#import "ExtraServiceOrderDetailController.h"

@interface ExtraPayOrderController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayOrder;

@end

@implementation ExtraPayOrderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"增值服务订单"];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self getOrders];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:_tableView];
}

- (NSMutableArray *)arrayOrder
{
    if (!_arrayOrder)
    {
        _arrayOrder = [NSMutableArray array];
    }

    return _arrayOrder;
}


/**
 id  支付ID
 type 1维保2维修3一元保障
 frequency 购买次数
 payMoney 付款金额
 payTime 付款时间
 smallOwnerId 业主ID
 mainttypeId 维保类型ID 1.按次服务 2.智能小管家服务 3.全能大管家服务
 isPay 0未付1已付
 createTime 创建时间
 code 支付编号
 name 名称
 tel 电话
 address 地址
 */
- (void)getOrders
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"incrementTypeId"] = _serviceInfo.typeId;

    [[HttpClient shareClient] post:@"getPaymentBySmallOwnerOnIncrement" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.arrayOrder removeAllObjects];

        [self.arrayOrder addObjectsFromArray:[responseObject objectForKey:@"body"]];

        if (0 == self.arrayOrder)
        {

        }

        [self.tableView reloadData];

    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}

- (void)payment:(NSString *)paymentId
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"paymentId"] = paymentId;

    [[HttpClient shareClient] post:@"continuePayment" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {

        NSString *url = [responseObject[@"body"] objectForKey:@"url"];

        if (url.length != 0)
        {
            PayViewController *controller = [[PayViewController alloc] init];
            controller.urlStr = url;

            [self presentViewController:controller animated:YES completion:^{
            }];
        }
    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOrder.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[PayInfoCell identifier]];

    if (!cell)
    {
        cell = [PayInfoCell cellFromNib];
    }

    NSDictionary *info = self.arrayOrder[indexPath.row];

    cell.lbCode.text = info[@"code"];

    cell.lbDate.text = info[@"createTime"];

    NSString *payType = _serviceInfo.name;

    cell.lbPayType.text = [NSString stringWithFormat:@"服务类型:%@", payType];


    NSInteger state = [info[@"isPay"] integerValue];

    //支付单是否有效
    NSInteger delete = [[info[@"maintOrderInfo"] objectForKey:@"isDelete"] integerValue];

    if (0 == state)
    {

        if (0 == delete)
        {
            cell.lbState.text = @"未支付";

        }
        else
        {
            cell.lbState.text = @"已过期";
        }

    }
    else
    {
        cell.lbState.text = @"已支付";
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PayInfoCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExtraServiceOrderDetailController *controller = [[ExtraServiceOrderDetailController alloc] init];
    controller.orderInfo = self.arrayOrder[indexPath.row];
    controller.houseInfo = _houseInfo;

    [self.navigationController pushViewController:controller animated:YES];
}

@end
