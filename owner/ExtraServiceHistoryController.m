//
//  ExtraServiceHistoryController.m
//  owner
//
//  Created by 长浩 张 on 2017/5/5.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "ExtraServiceHistoryController.h"
#import "ServiceHistoryCell.h"
#import "MainListResponse.h"
#import "ExtraPayOrderController.h"

@interface ExtraServiceHistoryController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *arrayService;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ExtraServiceHistoryController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"增值服务历史"];
    [self getHistory];
}

- (NSMutableArray *)arrayService
{
    if (!_arrayService) {
        _arrayService = [NSMutableArray array];
    }
    
    return _arrayService;
}

- (void)initTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

- (void)initNoHistoryView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, self.screenWidth, 40)];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    
    label.text = @"您还没有增值服务订购历史!";
    
    [self.view addSubview:label];
    
    return;
}

#pragma mark - 网络请求

- (void)getHistory
{
    [[HttpClient shareClient] post:@"getIncrementHistoryListByOwner" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        [self.arrayService removeAllObjects];
        [self.arrayService addObjectsFromArray:responseObject[@"body"]];
        
        if (0 == self.arrayService.count) {
            [self initNoHistoryView];
            
        } else {
            [self initTableView];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayService.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:[ServiceHistoryCell identifier]];
    
    if (!cell) {
        cell = [ServiceHistoryCell cellFromNib];
    }
    
    NSDictionary *info = self.arrayService[indexPath.row];
    
    cell.lbName.text = [info[@"incrementTypeInfo"] objectForKey:@"name"];
    
    cell.lbContent.text = [info[@"incrementTypeInfo"] objectForKey:@"content"];
    
    cell.lbDate.text = info[@"createTime"];
    
    NSString *url = [info[@"incrementTypeInfo"] objectForKey:@"logo"];
    
    [cell.ivBg setImageWithURL:[NSURL URLWithString:url]];
    
    [cell.btn setTitle:@"查看订单" forState:UIControlStateNormal];
    
    __weak typeof (self) weakSelf = self;
    
    [cell addOnClickBtnListener:^{
        ExtraPayOrderController *controller = [[ExtraPayOrderController alloc] init];
        controller.serviceInfo = [[MainTypeInfo alloc] initWithDictionary:info[@"incrementTypeInfo"]];
        
        [weakSelf.navigationController pushViewController:controller animated:YES];
        
    }];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ServiceHistoryCell cellHeight];
}


@end
