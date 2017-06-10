//
// Created by changhaozhang on 2017/6/10.
// Copyright (c) 2017 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "MaintDetailController.h"
#import "MainOrderDetailCell.h"

@interface MaintDetailController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation MaintDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)initView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth,
            self.screenHeight - 118)];

    tableView.delegate = self;

    tableView.dataSource = self;

    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:tableView];
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
    MainOrderDetailCell *cell = [MainOrderDetailCell cellFromNib];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MainOrderDetailCell cellHeight];
}


@end