//
//  PayOrderController.m
//  owner
//
//  Created by 长浩 张 on 2017/4/27.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "PayOrderController.h"
#import "PayInfoCell.h"

@interface PayOrderController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayOrder;

@end

@implementation PayOrderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"我的订单"];
    
    [self  initView];
    [self getOrders];
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

- (NSMutableArray *)arrayOrder
{
    if (!_arrayOrder) {
        _arrayOrder = [NSMutableArray array];
    }
    
    return _arrayOrder;
}


/**
 id  支付ID
 type 1维保2维修3一元保障
 frequency 购买次数
 payMoney 付款金额
 payTime 付款时间
 smallOwnerId 业主ID
 mainttypeId 维保类型ID 1.按次服务 2.智能小管家服务 3.全能大管家服务
 isPay 0未付1已付
 createTime 创建时间
 code 支付编号
 name 名称
 tel 电话
 address 地址
 */
- (void)getOrders
{
    [[HttpClient shareClient] post:@"getPaymentBySmallOwner" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.arrayOrder removeAllObjects];
        
        [self.arrayOrder addObjectsFromArray:[responseObject objectForKey:@"body"]];
        
        if (0 == self.arrayOrder) {
            
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (NSString *)getPayType:(NSInteger)type
{
    switch (type) {
        case 1:
            return @"按次服务";
            
        case 2:
            return @"智能小管家服务";
            
        case 3:
            return @"全能大管家服务";
            
        default:
            return @"按次服务";
    }
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
    PayInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[PayInfoCell identifier]];
    
    if (!cell) {
        cell = [PayInfoCell cellFromNib];
    }
    
    NSDictionary *info = self.arrayOrder[indexPath.row];
    
    cell.lbCode.text = info[@"code"];
    
    cell.lbDate.text = info[@"createTime"];
    
    NSString *payType = [self getPayType:[info[@"mainttypeId"] integerValue]];
    
    cell.lbPayType.text = [NSString stringWithFormat:@"支付类型:%@", payType];
    
    cell.lbSum.text = [NSString stringWithFormat:@"支付金额:%ld", [info[@"payMoney"] integerValue]];
    
    NSInteger state = [info[@"isPay"] integerValue];
    
    if (0 == state) {
        cell.lbState.text = [NSString stringWithFormat:@"支付状态:未支付"];
        
        cell.payHiden = NO;
        
        cell.lbPayTime.text = [NSString stringWithFormat:@"支付时间:暂未支付"];
        
        [cell addOnPayClickListener:^{
            
        }];
        
    } else {
        cell.lbState.text = [NSString stringWithFormat:@"支付状态:已支付"];
        
        cell.payHiden = YES;
        
        cell.lbPayTime.text = [NSString stringWithFormat:@"支付时间:%@", info[@"payTime"]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PayInfoCell cellHeight];
}

@end
