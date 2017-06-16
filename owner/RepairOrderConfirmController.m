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
        CouponViewControllerDelegate, CompanyListControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (copy, nonatomic) NSString *branchId;

@property (copy, nonatomic) NSString *couponId;

@property (weak, nonatomic) RepairOrderConfirmCell *cell;

@property (strong, nonatomic) NSMutableArray *arrayBranch;

@end

@implementation RepairOrderConfirmController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"订单确认"];

    [self getBranch];
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

- (NSMutableArray *)arrayBranch
{
    if (!_arrayBranch)
    {
        _arrayBranch = [NSMutableArray array];
    }

    return _arrayBranch;
}

- (void)getBranch
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"villaId"] = _request.villaId;

    [[HttpClient shareClient] post:@"getBranchsByVillaId" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {

        [self.arrayBranch removeAllObjects];
        [self.arrayBranch addObjectsFromArray:responseObject[@"body"]];
        [self initView];

    } failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
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

    if (self.arrayBranch.count >= 1)
    {
        cell.lbCom1.text = self.arrayBranch[0][@"name"];

        cell.lbCom2.userInteractionEnabled = NO;
        cell.lbCom3.userInteractionEnabled = NO;
    }

    if (self.arrayBranch.count >= 2)
    {
        cell.lbCom2.text = self.arrayBranch[1][@"name"];
        cell.lbCom2.userInteractionEnabled = YES;
        cell.lbCom3.userInteractionEnabled = NO;
    }

    if (self.arrayBranch.count >= 3)
    {
        cell.lbCom3.text = self.arrayBranch[2][@"name"];
        cell.lbCom3.userInteractionEnabled = YES;
    }

    _cell = cell;

    cell.delegate = self;

    [cell selCom1];

    return cell;
}

- (void)submit
{
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
    controller.arrayBranch = _arrayBranch;
    controller.delegate = self;

    controller.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:controller animated:YES];

}

- (void)onClickAgreement
{

}

- (void)onChooseCompany:(NSInteger)index name:(NSString *)name
{
    NSDictionary *info = self.arrayBranch[index];
    _branchId = info[@"id"];
}

#pragma mark - CompanyListControllerDelegate

- (void)onChoose:(NSInteger)index name:(NSString *)name
{
    switch (index)
    {
        case 0:
            [_cell selCom1];
            break;

        case 1:
            [_cell selCom2];
            break;

        case 2:
            [_cell selCom3];
            break;

        default:
            [_cell resetSel];
            _branchId = self.arrayBranch[index][@"id"];
            _cell.lbCompany.text = name;
    }
}


#pragma mark - CouponViewControllerDelegate

- (void)onChooseCoupon:(NSDictionary *)couponInfo
{
    _cell.lbCoupon.text = [NSString stringWithFormat:@"满%.2lf可用", [couponInfo[@"startMoney"] floatValue]];

    _cell.lbDiscount.text = [NSString stringWithFormat:@"￥-%.2lf", [couponInfo[@"couponMoney"] floatValue]];

    _cell.lbPay.text = [NSString stringWithFormat:@"￥%.2lf", 100 - [couponInfo[@"couponMoney"] floatValue]];
}

@end
