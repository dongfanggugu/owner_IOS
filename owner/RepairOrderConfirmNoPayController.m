//
// Created by changhaozhang on 2017/6/12.
// Copyright (c) 2017 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "RepairOrderConfirmNoPayController.h"
#import "RepairOrderConfirmNoPayCell.h"
#import "RepairAddRequest.h"#import "BMKPoiSearchType.h"

@interface RepairOrderConfirmNoPayController () <UITableViewDelegate, UITableViewDataSource, RepairOrderConfirmNoPayCellDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation RepairOrderConfirmNoPayController
{

}

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
    RepairOrderConfirmNoPayCell *cell = [RepairOrderConfirmNoPayCell cellFromNib];

    NSString *company = _serviceInfo[@"branchInfo"][@"name"];

    NSString *maintName = [_serviceInfo[@"maintypeInfo"] objectForKey:@"name"];

    cell.lbIntroduce.text = [NSString stringWithFormat:@"  由于您已经在平台订购了%@的%@服务,将由%@为您提供免费上门服务",
                    company, maintName, company];

    cell.lbCompany.text = company;

    cell.delegate = self;

    return cell;
}

- (void)submit
{

    _request.type = @"0";
    _request.branchId = _serviceInfo[@"branchInfo"][@"id"];

    [[HttpClient shareClient] post:URL_REPAIR_ADD parameters:[_request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithText:@"快修单提交成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RepairOrderConfirmNoPayCell cellHeight];
}

#pragma mark - MainOrderConfirmCellDelegate

- (void)onClickSubmit
{
    [self submit];
}


- (void)onClickAgreement
{

}

@end