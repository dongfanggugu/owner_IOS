//
//  PersonController.m
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonController.h"
#import "KeyValueCell.h"
#import "MyOrderController.h"
#import "PersonInfoView.h"
#import "PersonItemCell.h"
#import "JPUSHService.h"
#import "MaintOrderController.h"
#import "RepairOrderController.h"
#import "MainInfoController.h"
#import "OrderListRequest.h"
#import "MainListResponse.h"
#import "ExtraServiceController.h"
#import "CouponViewController.h"


@interface PersonController () <UITableViewDelegate, UITableViewDataSource, PersonInfoViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) PersonInfoView *infoView;

@end

@implementation PersonController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

    [self setUserView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight - 49)];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;

    _infoView = [PersonInfoView viewFromNib];

    _infoView.lbTitle.text = @"怡墅";

    _infoView.frame = CGRectMake(0, 0, self.screenWidth, 144);

    _tableView.tableHeaderView = _infoView;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    _infoView.delegate = self;

    [self.view addSubview:_tableView];
}

- (void)setUserView
{
    NSString *userId = [[Config shareConfig] getUserId];

    if (0 == userId.length)
    {
        _infoView.lbName.text = @"登录/注册";

    }
    else
    {
        _infoView.lbName.text = [[Config shareConfig] getName];
    }

}


#pragma mark - PersonInfoViewDelegate

- (void)onClickView
{
    NSString *userId = [[Config shareConfig] getUserId];

    if (0 == userId.length)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"login_controller"];

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];

    }
    else
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Person" bundle:nil];

        UIViewController *destinationVC = [board instantiateViewControllerWithIdentifier:@"basicInfo"];

        destinationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:destinationVC animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        PersonItemCell *cell = [PersonItemCell cellFromNib];
        cell.lbItem.text = @"维保服务";
        cell.ivIcon.image = [UIImage imageNamed:@"icon_person_maint.png"];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;

    }
    else if (1 == indexPath.row)
    {
        PersonItemCell *cell = [PersonItemCell cellFromNib];
        cell.lbItem.text = @"快修订单";
        cell.ivIcon.image = [UIImage imageNamed:@"icon_person_repair.png"];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;

    }
    else if (2 == indexPath.row)
    {
        PersonItemCell *cell = [PersonItemCell cellFromNib];
        cell.lbItem.text = @"增值服务";
        cell.ivIcon.image = [UIImage imageNamed:@"icon_person_extra.png"];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;

    }
    else if (3 == indexPath.row)
    {
        PersonItemCell *cell = [PersonItemCell cellFromNib];
        cell.lbItem.text = @"我的优惠券";
        cell.ivIcon.image = [UIImage imageNamed:@"icon_person_coupon.png"];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;

    }
    else if (4 == indexPath.row)
    {

        PersonItemCell *cell = [PersonItemCell cellFromNib];
        cell.lbItem.text = @"设置";
        cell.ivIcon.image = [UIImage imageNamed:@"icon_person_settings.png"];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }

    return [PersonItemCell cellFromNib];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PersonItemCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (0 == indexPath.row)
    {

        if (!self.login)
        {
            [HUDClass showHUDWithText:@"请您先登录"];
            return;
        }

        MainInfoController *controller = [[MainInfoController alloc] init];

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];

    }
    else if (1 == indexPath.row)
    {
        if (!self.login)
        {
            [HUDClass showHUDWithText:@"请您先登录"];
            return;
        }

        RepairOrderController *controller = [[RepairOrderController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:controller animated:YES];

    }
    else if (2 == indexPath.row)
    {
        if (!self.login)
        {
            [HUDClass showHUDWithText:@"请您先登录"];
            return;
        }

        ExtraServiceController *controller = [[ExtraServiceController alloc] init];

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];

    }
    else if (3 == indexPath.row)
    {

        if (!self.login)
        {
            [HUDClass showHUDWithText:@"请您先登录"];
            return;
        }
        CouponViewController *controller = [[CouponViewController alloc] init];

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];

    }
    else if (4 == indexPath.row)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"settings_controller"];

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }

}

@end
