//
//  MaintOrderController.m
//  owner
//
//  Created by 长浩 张 on 2017/4/26.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "MaintOrderController.h"
#import "OrderListRequest.h"
#import "MainListResponse.h"
#import "OrderInfoCell.h"
#import "MainInfoController.h"

@interface MaintOrderController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayMainOrder;

@end

@implementation MaintOrderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维保订单"];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMaint];
}

- (NSMutableArray *)arrayMainOrder
{
    if (!_arrayMainOrder) {
        _arrayMainOrder = [NSMutableArray array];
    }
    
    return _arrayMainOrder;
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


#pragma mark - Network Request

- (void)getMaint
{
    OrderListRequest *request = [[OrderListRequest alloc] init];
    
    [[HttpClient shareClient] post:URL_MAIN_LIST parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        MainListResponse *response = [[MainListResponse alloc] initWithDictionary:responseObject];
        [self.arrayMainOrder removeAllObjects];
        [self.arrayMainOrder addObjectsFromArray:[response getOrderList]];
        [self.tableView reloadData];
        
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
  
    return self.arrayMainOrder.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderInfoCell identifier]];
    
    if (!cell) {
        cell = [OrderInfoCell cellFromNib];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MainOrderInfo *info = _arrayMainOrder[indexPath.row];
    
    cell.lbIndex.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    
    cell.lbTitle.text = info.maintypeName;
    
    cell.lbState.text = info.createTime;
    
    NSInteger type = info.mainttypeId.integerValue;
    
    if (1 == type) {
        cell.lbContent.text = [NSString stringWithFormat:@"剩余次数:%ld", info.frequency];
    
    } else {
        cell.lbContent.text = [NSString stringWithFormat:@"到期日期:%@", info.expireTime];
    
    }
        
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OrderInfoCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainInfoController *controller = [[MainInfoController alloc] init];
    controller.orderInfo = _arrayMainOrder[indexPath.row];
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}



@end
