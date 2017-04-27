//
//  MyOrderController.m
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyOrderController.h"
#import "PullTableView.h"
#import "OrderListRequest.h"
#import "MainListResponse.h"
#import "RepairListResponse.h"
#import "OrderInfoCell.h"
#import "MainInfoController.h"
#import "RepairInfoController.h"

#define MAIN 0

#define REPAIR 1

@interface MyOrderController () <UITableViewDelegate, UITableViewDataSource, PullTableViewDelegate>


@property (strong, nonatomic) UISegmentedControl *segment;

@property (strong, nonatomic) PullTableView *tableView;

@property (assign, nonatomic) NSInteger selIndex;

@property (strong, nonatomic) NSMutableArray *arrayMainOrder;

@property (strong, nonatomic) NSMutableArray *arrayRepairOrder;

@end

@implementation MyOrderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"我的订单"];
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
}

- (void)setSelIndex:(NSInteger)selIndex
{
    _selIndex = selIndex;
    
    if (MAIN == _selIndex)
    {
        [self getMain];
    }
    else
    {
        [self getRepair];
    }
}
- (void)initData
{
    _arrayMainOrder = [NSMutableArray array];
    
    _arrayRepairOrder = [NSMutableArray array];
}

- (void)initView
{    
    NSArray *array = [[NSArray alloc] initWithObjects:@"维保服务", @"快修服务", nil];
    _segment = [[UISegmentedControl alloc] initWithItems:array];
    _segment.frame = CGRectMake(0, 0, 160, 30);
    
    _segment.center = CGPointMake(self.screenWidth / 2, 70 + 30 / 2);
    _segment.tintColor = [Utils getColorByRGB:TITLE_COLOR];
    
    [_segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];

    _segment.selectedSegmentIndex = 0;
    
    self.selIndex = MAIN;
    
    [self.view addSubview:_segment];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 110, self.screenWidth, self.screenHeight - 114)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullDelegate = self;
    _tableView.bounces = NO;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
    
}

- (void)segmentChanged:(UISegmentedControl *)segment
{
    self.selIndex = segment.selectedSegmentIndex;
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
    else if (8 == state)
    {
        res = @"维修完成";
    }
    else if (9 == state)
    {
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
        [_arrayRepairOrder removeAllObjects];
        [_arrayRepairOrder addObjectsFromArray:[response getOrderList]];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)getMain
{
    OrderListRequest *request = [[OrderListRequest alloc] init];
    
    [[HttpClient shareClient] post:URL_MAIN_LIST parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        MainListResponse *response = [[MainListResponse alloc] initWithDictionary:responseObject];
        [_arrayMainOrder removeAllObjects];
        [_arrayMainOrder addObjectsFromArray:[response getOrderList]];
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
    if (MAIN == _selIndex)
    {
        return _arrayMainOrder.count;
    }
    else
    {
        return _arrayRepairOrder.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (MAIN == _selIndex)
    {
        OrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderInfoCell identifier]];
        
        if (!cell)
        {
            cell = [OrderInfoCell cellFromNib];
        }
        
        MainOrderInfo *info = _arrayMainOrder[indexPath.row];
        
        cell.lbIndex.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
        
        cell.lbTitle.text = info.maintypeName;
        
        cell.lbState.text = info.createTime;
        
        cell.lbContent.text = [NSString stringWithFormat:@"￥%.1lf", info.price];
        
        return cell;
    }
    else
    {
        OrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderInfoCell identifier]];
        
        if (!cell)
        {
            cell = [OrderInfoCell cellFromNib];
        }
        
        RepairOrderInfo *info = _arrayRepairOrder[indexPath.row];
        
        cell.lbIndex.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
        
        cell.lbTitle.text = info.createTime;
        
        cell.lbState.text = [self getStateDes:info.state.integerValue];
        
        cell.lbContent.text = info.phenomenon;
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OrderInfoCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (MAIN == _selIndex)
    {
        MainInfoController *controller = [[MainInfoController alloc] init];
        controller.serviceInfo = _arrayMainOrder[indexPath.row];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        RepairInfoController *controller = [[RepairInfoController alloc] init];
        controller.orderInfo = _arrayRepairOrder[indexPath.row];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    
}
@end
