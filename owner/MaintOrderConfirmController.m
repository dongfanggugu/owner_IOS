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

@interface MaintOrderConfirmController () <UITableViewDelegate, UITableViewDataSource, MainOrderConfirmCellDelegate, CompanyListControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (weak, nonatomic) MainOrderConfirmCell *cell;

@end

@implementation MaintOrderConfirmController

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
    MainOrderConfirmCell *cell = [MainOrderConfirmCell cellFromNib];
    
    _cell = cell;
    
    cell.delegate = self;
        
    cell.lbPrice.text = @"";
    
    //优惠券
    cell.lbCoupon.text = @"未使用";
    
    cell.lbPrice.text = [NSString stringWithFormat:@"￥%.2lf", _request.payMoney];
    
    cell.lbDiscount.text = @"-￥0";
    
    cell.lbPay.text = [NSString stringWithFormat:@"￥%.2lf", _request.payMoney];
    
    return cell;
}

- (void)submit
{
    [[HttpClient shareClient] post:URL_MAIN_ADD parameters:[_request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *url = [responseObject[@"body"] objectForKey:@"url"];
        
        if (url.length != 0) {
            PayViewController *controller = [[PayViewController alloc] init];
            controller.urlStr = url;
            
            __weak typeof (self) weakSelf = self;
            
            [self presentViewController:controller animated:YES completion:^{
                
                NSArray *array = weakSelf.navigationController.viewControllers;
                [weakSelf.navigationController popToViewController:array[1] animated:NO];
            }];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
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
    controller.delegate = self;
    
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickAgreement
{
    
}

- (void)onClickCoupon
{
    
}

- (void)onChooseCompany:(NSInteger)index name:(NSString *)name
{
    
}

#pragma mark - CompanyListControllerDelegate

- (void)onChoose:(NSInteger)index name:(NSString *)name
{
    [_cell resetSel];
    
    _cell.lbCompany.text = name;
}

@end
