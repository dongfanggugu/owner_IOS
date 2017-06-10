//
// Created by changhaozhang on 2017/6/10.
// Copyright (c) 2017 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "OrderMaintListController.h"
#import "OrderMaintCell.h"
#import "OrderMaintDetailController.h"

@interface OrderMaintListController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayOrder;

@end

@implementation OrderMaintListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维保订单"];
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

- (NSMutableArray *)arrayOrder
{
    if (!_arrayOrder)
    {
        _arrayOrder = [NSMutableArray array];
    }

    return _arrayOrder;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.arrayOrder.count;
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderMaintCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderMaintCell identifier]];

    if (!cell)
    {
        cell = [OrderMaintCell cellFromNib];
    }

//    NSDictionary *orderInfo = self.arrayOrder[indexPath.row];

    cell.lbCode.text = [NSString stringWithFormat:@"编号: %@", @"PO2302242924224"];
    cell.lbTime.text = @"2014-09-12 12:23:32";
    cell.lbName.text = @"北京望京soho";
    cell.lbType.text = @"服务类型:全能大管家";

    cell.lbState.text = @"未支付";

    BOOL isPay = NO;

    if (isPay)
    {
        cell.lbState.text = @"已支付";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OrderMaintCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *info = self.arrayOrder[indexPath.row];

    NSDictionary *info = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"isPay"];

    OrderMaintDetailController *controller = [[OrderMaintDetailController alloc] init];
    controller.orderInfo = info;

    [self.navigationController pushViewController:controller animated:YES];
}

@end