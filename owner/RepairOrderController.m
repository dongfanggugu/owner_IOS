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

@interface RepairOrderController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayOrder;

@end

@implementation RepairOrderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维修订单"];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getRepair];
}

- (NSMutableArray *)arrayOrder
{
    if (!_arrayOrder) {
        _arrayOrder = [NSMutableArray array];
    }
    
    return _arrayOrder;
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

- (NSString *)getStateDes:(NSInteger)state
{
    NSString *res = @"";
    
    if (1 == state) {
        res = @"待确认";
        
    } else if (2 == state) {
        res = @"已确认";
        
    } else if (4 == state) {
        res = @"已委派";
        
    } else if (6 == state) {
        res = @"维修中";
        
    } else if (8 == state) {
        res = @"维修完成";
        
    } else if (9 == state) {
        res = @"确认完成";
    }
    
    return res;
}


#pragma mark - Network Request

- (void)getRepair
{
    OrderListRequest *request = [[OrderListRequest alloc] init];
    
    [[HttpClient shareClient] post:URL_REPAIR_LIST parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        RepairListResponse *response = [[RepairListResponse alloc] initWithDictionary:responseObject];
        [self.arrayOrder removeAllObjects];
        [self.arrayOrder addObjectsFromArray:[response getOrderList]];
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
    
    return self.arrayOrder.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderInfoCell identifier]];
    
    if (!cell) {
        cell = [OrderInfoCell cellFromNib];
    }
    
    RepairOrderInfo *info = self.arrayOrder[indexPath.row];
    
    cell.lbIndex.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    
    cell.lbTitle.text = [self getStateDes:info.state.integerValue];
    
    cell.lbState.text = info.createTime;
    
    cell.lbContent.text = info.phenomenon;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OrderInfoCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepairInfoController *controller = [[RepairInfoController alloc] init];
    controller.orderInfo = self.arrayOrder[indexPath.row];
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}



@end
