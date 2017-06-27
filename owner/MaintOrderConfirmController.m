//
//  MaintOrderConfirmController.m
//  owner
//
//  Created by 长浩 张 on 2017/6/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "MaintOrderConfirmController.h"
#import "MainOrderConfirmCell.h"
#import "MainOrderAddRequest.h"
#import "PayViewController.h"
#import "CompanyListController.h"
#import "CouponViewController.h"
#import "ThirdProtocolController.h"


@interface MaintOrderConfirmController () <UITableViewDelegate, UITableViewDataSource, MainOrderConfirmCellDelegate,
        CompanyListControllerDelegate, CouponViewControllerDelegate>;

@property (strong, nonatomic) UITableView *tableView;

@property (weak, nonatomic) MainOrderConfirmCell *cell;

@property (copy, nonatomic) NSString *couponId;

@property (strong, nonatomic) NSMutableArray *arrayBranch;

@property (copy, nonatomic) NSString *branchId;

@end

@implementation MaintOrderConfirmController

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

#pragma mark - UITableView

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
    MainOrderConfirmCell *cell = [MainOrderConfirmCell cellFromNib];

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

    cell.lbPrice.text = @"";

    //优惠券
    cell.lbCoupon.text = @"未使用";

    cell.lbPrice.text = [NSString stringWithFormat:@"￥%.2lf", _request.payMoney];

    cell.lbDiscount.text = @"￥-0.00";

    cell.lbPay.text = [NSString stringWithFormat:@"￥%.2lf", _request.payMoney];

    return cell;
}

- (void)submit
{
    _request.branchId = _branchId;
    _request.couponRecordId = _couponId;

    __weak typeof(self) weakSelf = self;

    [[HttpClient shareClient] post:URL_MAIN_ADD parameters:[_request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {

//        CGFloat fee = weakSelf.cell.lbPay.text.floatValue;
//        if (fee <= 0)
//        {
//            [weakSelf showMsgAlert:@"您的订单已经生成,您可以到订单中查看详细信息"];
//            return;
//        }

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
    return [MainOrderConfirmCell cellHeight];
}

#pragma mark - MainOrderConfirmCellDelegate


- (void)onClickPay
{
    [self submit];
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
    ThirdProtocolController *controller = [[ThirdProtocolController alloc] init];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickCoupon
{
    CouponViewController *controller = [[CouponViewController alloc] init];
    controller.branchId = _branchId;
    controller.payAmount = _request.payMoney;
    controller.delegate = self;

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
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

    _cell.lbPay.text = [NSString stringWithFormat:@"￥%.2lf", _request.payMoney - [couponInfo[@"couponMoney"] floatValue]];

    _couponId = couponInfo[@"id"];
}

- (void)onMsgAlertDismiss
{
    NSArray *array = self.navigationController.viewControllers;

    [self.navigationController popToViewController:array[array.count - 3] animated:YES];
}

@end
