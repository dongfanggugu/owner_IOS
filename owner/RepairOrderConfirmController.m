//
//  RepairOrderConfirmController.m
//  owner
//
//  Created by 长浩 张 on 2017/6/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "RepairOrderConfirmController.h"
#import "RepairOrderConfirmCell.h"
#import "RepairAddRequest.h"
#import "PayViewController.h"
#import "CouponViewController.h"
#import "CompanyListController.h"

@interface RepairOrderConfirmController () <UITableViewDelegate, UITableViewDataSource, RepairOrderConfirmCellDelegate,
        CouponViewControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (copy, nonatomic) NSString *branchId;

@property (copy, nonatomic) NSString *couponId;

@property (weak, nonatomic) RepairOrderConfirmCell *cell;

@end

@implementation RepairOrderConfirmController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"订单确认"];

    [self initView];
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
    RepairOrderConfirmCell *cell = [RepairOrderConfirmCell cellFromNib];

    _cell = cell;

    cell.delegate = self;

    return cell;
}

- (void)submit
{
    _branchId = @"30584de5-4871-460e-86df-6ae15de01334";
    _request.type = @"1";
    _request.branchId = _branchId;
    _request.couponRecordId = _couponId;

    [[HttpClient shareClient] post:URL_REPAIR_ADD parameters:[_request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *url = [responseObject[@"body"] objectForKey:@"url"];

        if (url.length != 0)
        {
            PayViewController *controller = [[PayViewController alloc] init];
            controller.urlStr = url;

            __weak typeof(self) weakSelf = self;

            [self presentViewController:controller animated:YES completion:^{

                NSArray *array = weakSelf.navigationController.viewControllers;
                [weakSelf.navigationController popToViewController:array[1] animated:NO];
            }];
        }
    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RepairOrderConfirmCell cellHeight];
}

#pragma mark - MainOrderConfirmCellDelegate

- (void)onClickPay
{
    [self submit];
}

- (void)onClickCoupon
{
    CouponViewController *controller = [[CouponViewController alloc] init];
    controller.payAmount = 100;
    controller.delegate = self;

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)onClickMoreCompany
{
    CompanyListController *controller = [[CompanyListController alloc] init];
    controller.delegate = self;

    controller.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:controller animated:YES];

}

- (void)onClickAgreement
{

}

- (void)onChooseCompany:(NSInteger)index name:(NSString *)name
{

}
#pragma mark - CouponViewControllerDelegate

- (void)onChooseCoupon:(NSDictionary *)couponInfo
{
    _cell.lbCoupon.text = [NSString stringWithFormat:@"满%.2lf可用", [couponInfo[@"startMoney"] floatValue]];

    _cell.lbDiscount.text = [NSString stringWithFormat:@"￥-%.2lf", [couponInfo[@"couponMoney"] floatValue]];

    _cell.lbPay.text = [NSString stringWithFormat:@"￥%.2lf", 100 - [couponInfo[@"couponMoney"] floatValue]];
}

@end
