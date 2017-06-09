//
//  ServiceHistoryController.m
//  owner
//
//  Created by 长浩 张 on 2017/4/28.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "ServiceHistoryController.h"
#import "ServiceHistoryCell.h"
#import "MainListResponse.h"
#import "ServiceTaskController.h"

@interface ServiceHistoryController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *arrayService;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ServiceHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"服务历史"];
    [self getHistory];
}

- (NSMutableArray *)arrayService {
    if (!_arrayService) {
        _arrayService = [NSMutableArray array];
    }

    return _arrayService;
}

- (void)initTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _tableView.delegate = self;

    _tableView.dataSource = self;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [_tableView showCopyWrite];

    [self.view addSubview:_tableView];
}

- (void)initNoHistoryView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, self.screenWidth, 40)];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;

    label.text = @"您还没有服务订购历史!";

    [self.view addSubview:label];

    return;
}

#pragma mark - 网络请求

- (void)getHistory {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[@"villaId"] = _houseId;

    [[HttpClient shareClient] post:@"getMaintOrderHistoryList" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {

        MainListResponse *response = [[MainListResponse alloc] initWithDictionary:responseObject];

        [self.arrayService removeAllObjects];
        [self.arrayService addObjectsFromArray:[response getOrderList]];

        if (0 == self.arrayService.count) {
            [self initNoHistoryView];

        } else {
            [self initTableView];
        }


    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayService.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ServiceHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:[ServiceHistoryCell identifier]];

    if (!cell) {
        cell = [ServiceHistoryCell cellFromNib];
    }

    MainOrderInfo *info = self.arrayService[indexPath.row];

    cell.lbName.text = info.maintypeInfo.name;

    cell.lbContent.text = info.maintypeInfo.content;

    cell.lbDate.text = info.createTime;

    NSInteger type = info.mainttypeId.integerValue;

    switch (type) {
        case 1:
            cell.image = [UIImage imageNamed:@"icon_level_3"];
            break;

        case 2:
            cell.image = [UIImage imageNamed:@"icon_level_2"];
            break;

        case 3:
            cell.image = [UIImage imageNamed:@"icon_level_1"];

        default:
            break;
    }

    __weak typeof(self) weakSelf = self;

    [cell addOnClickBtnListener:^{
        ServiceTaskController *controller = [[ServiceTaskController alloc] init];
        controller.serviceId = info.orderId;

        [weakSelf.navigationController pushViewController:controller animated:YES];

    }];

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ServiceHistoryCell cellHeight];
}

@end
