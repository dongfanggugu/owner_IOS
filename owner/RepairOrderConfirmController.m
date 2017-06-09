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

@interface RepairOrderConfirmController () <UITableViewDelegate, UITableViewDataSource, RepairOrderConfirmCellDelegate>

@property (strong, nonatomic) UITableView *tableView;


@end

@implementation RepairOrderConfirmController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"订单确认"];

    [self initView];
}

- (void)initView {
    self.automaticallyAdjustsScrollViewInsets = NO;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RepairOrderConfirmCell *cell = [RepairOrderConfirmCell cellFromNib];

    cell.delegate = self;

    return cell;
}

- (void)submit {
    [[HttpClient shareClient] post:URL_REPAIR_ADD parameters:[_request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithText:@"快修单提交成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [RepairOrderConfirmCell cellHeight];
}

#pragma mark - MainOrderConfirmCellDelegate

- (void)onClickPay {
    [self submit];
}

- (void)onClickMoreCompany {

}

- (void)onClickAgreement {

}

- (void)onChooseCompany:(NSInteger)index name:(NSString *)name {

}

@end
