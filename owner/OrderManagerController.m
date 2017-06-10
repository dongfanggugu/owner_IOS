//
// Created by changhaozhang on 2017/6/10.
// Copyright (c) 2017 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "OrderManagerController.h"
#import "OrderCategoryCell.h"
#import "OrderMaintListController.h"

@interface OrderManagerController () <UITableViewDelegate, UITableViewDataSource>


@end

@implementation OrderManagerController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"订单"];
    [self initView];
}

- (void)initView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight - 64)];

    tableView.delegate = self;

    tableView.dataSource = self;

    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:tableView];

    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenWidth / 3)];

    iv.image = [UIImage imageNamed:@"icon_other_banner.png"];

    tableView.tableHeaderView = iv;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderCategoryCell identifier]];

    if (!cell)
    {
        cell = [OrderCategoryCell cellFromNib];
    }

    switch (indexPath.row)
    {
        case 0:
            cell.ivCategory.image = [UIImage imageNamed:@"icon_maint_order.png"];
            cell.lbItem.text = @"维保订单";
            break;

        case 1:
            cell.ivCategory.image = [UIImage imageNamed:@"icon_repair_order.png"];
            cell.lbItem.text = @"快修订单";
            break;

        case 2:
            cell.ivCategory.image = [UIImage imageNamed:@"icon_other_order.png"];
            cell.lbItem.text = @"增值服务订单";
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OrderCategoryCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            OrderMaintListController *controller = [[OrderMaintListController alloc] init];

            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;

        case 1:
        {
            OrderMaintListController *controller = [[OrderMaintListController alloc] init];

            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;

        case 2:
        {
            OrderMaintListController *controller = [[OrderMaintListController alloc] init];

            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
    }

}

@end