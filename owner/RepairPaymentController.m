//
//  RepairPaymentController.m
//  owner
//
//  Created by 长浩 张 on 2017/5/27.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "RepairPaymentController.h"
#import "RepairPayInfoCell.h"
#import "PayViewController.h"
#import "RepairCouponCell.h"
#import "CouponViewController.h"

@interface RepairPaymentController () <UITableViewDelegate, UITableViewDataSource, CouponViewControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayPay;

@property (copy, nonatomic) NSString *paymentId;

@property (weak, nonatomic) RepairCouponCell *couponCell;

@property (weak, nonatomic) RepairPayInfoCell *totalCell;

@property (copy, nonatomic) NSString *couponId;

@end

@implementation RepairPaymentController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维修支付"];
    [self initView];

    [self getPayment];
}

- (NSMutableArray *)arrayPay
{
    if (!_arrayPay)
    {
        _arrayPay = [NSMutableArray array];
    }

    return _arrayPay;
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64) style:UITableViewStyleGrouped];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [_tableView showCopyWrite];

    [self.view addSubview:_tableView];

    if (Repair_Pay == _enterType)
    {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 80)];

        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];

        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5;

        btn.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
        [btn setTitle:@"确认并支付" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(payment) forControlEvents:UIControlEventTouchUpInside];

        btn.center = CGPointMake(self.screenWidth / 2, 40);
        [footView addSubview:btn];

        _tableView.tableFooterView = footView;

    }
    else
    {
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
}

- (void)payment
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"paymentId"] = _paymentId;
    params[@"couponRecordId"] = _couponId;

    [[HttpClient shareClient] post:@"continuePayment" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {

        NSString *url = [responseObject[@"body"] objectForKey:@"url"];

        if (url.length != 0)
        {
            PayViewController *controller = [[PayViewController alloc] init];
            controller.urlStr = url;

            [self presentViewController:controller animated:YES completion:^{
                [self.navigationController popViewControllerAnimated:NO];
            }];
        }

    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}

- (void)getPayment
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"repairOrderId"] = _orderId;

    [[HttpClient shareClient] post:@"getPriceDetailsByRepairOrder" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.arrayPay removeAllObjects];
        [self.arrayPay addObjectsFromArray:responseObject[@"body"][@"pList"]];

        _paymentId = responseObject[@"body"][@"list"][0][@"id"];

        [self dealWithPayments];

    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}

- (void)dealWithPayments
{
    if (0 == self.arrayPay.count)
    {
        return;
    }

    [self.tableView reloadData];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (Repair_Pay == _enterType)
    {
        return 2;

    }
    else
    {
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
        return self.arrayPay.count;

    }
    else if (1 == section)
    {
        return 1;

    }
    else
    {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {

        NSDictionary *info = self.arrayPay[indexPath.row];

        if (indexPath.row == self.arrayPay.count - 1)
        {
            RepairCouponCell *cell = [RepairCouponCell cellFromNib];
            cell.lbName.text = @"优惠券";

            CGFloat discount = [info[@"price"] floatValue];

            if (discount < 0 || Repair_Show == _enterType)
            {
                cell.btnCoupon.hidden = YES;
                cell.lbPrice.text = [NSString stringWithFormat:@"￥%.2lf", discount];
            }
            else
            {
                cell.btnCoupon.hidden = NO;
                [cell.btnCoupon addTarget:self action:@selector(coupon) forControlEvents:UIControlEventTouchUpInside];

                cell.lbPrice.text = @"￥-0.00";
            }

            return cell;

        }
        else
        {
            RepairPayInfoCell *cell = [RepairPayInfoCell cellFromNib];


            cell.lbName.text = info[@"name"];

            cell.lbPrice.text = [NSString stringWithFormat:@"￥%.2lf", [info[@"price"] floatValue]];


            return cell;
        }

    }
    else if (1 == indexPath.section)
    {

        RepairPayInfoCell *cell = [RepairPayInfoCell cellFromNib];

        cell.lbName.text = @"实际支付";

        cell.lbPrice.textColor = [Utils getColorByRGB:@"#03cd99"];

        CGFloat payMoney = 0;

        if (self.arrayPay.count > 0)
        {
            payMoney = [[[self.arrayPay[0] objectForKey:@"repairOrderInfo"] objectForKey:@"payMoney"] floatValue];
        }

        cell.lbPrice.text = [NSString stringWithFormat:@"￥%.2lf", payMoney];

        return cell;

    }
    else
    {
        if (0 == indexPath.row)
        {
            RepairPayInfoCell *cell = [RepairPayInfoCell cellFromNib];

            cell.lbName.text = @"支付时间";

            cell.lbPrice.textColor = [Utils getColorByRGB:@"#03cd99"];

            cell.lbPrice.text = _payTime;

            return cell;

        }
        else
        {
            RepairPayInfoCell *cell = [RepairPayInfoCell cellFromNib];

            cell.lbName.text = @"支付方式";

            cell.lbPrice.textColor = [Utils getColorByRGB:@"#03cd99"];

            cell.lbPrice.text = @"在线支付";

            return cell;

        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RepairPayInfoCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3;
}

- (void)coupon
{
    CouponViewController *controller = [[CouponViewController alloc] init];
    controller.delegate = self;

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onChooseCoupon:(NSDictionary *)couponInfo
{
    _couponCell.lbContent.text = [NSString stringWithFormat:@"满%.2lf可用", [couponInfo[@"startMoney"] floatValue]];

    _couponCell.lbPrice.text = [NSString stringWithFormat:@"￥-%.2lf", [couponInfo[@"couponMoney"] floatValue]];

    CGFloat newPay = [_totalCell.lbPrice.text floatValue] - [couponInfo[@"couponMoney"] floatValue];
    _totalCell.lbPrice.text = [NSString stringWithFormat:@"%.2lf", newPay];

    _couponId = couponInfo[@"id"];
}

@end
