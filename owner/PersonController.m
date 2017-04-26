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


@interface PersonController()<UITableViewDelegate, UITableViewDataSource, PersonInfoViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) PersonInfoView *infoView;

@end

@implementation PersonController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"我的"];
    [self initView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUserView];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    
    _infoView = [PersonInfoView viewFromNib];
    
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
    
    if (0 == userId.length) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"login_controller"];
        
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    } else {
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        PersonItemCell *cell = [PersonItemCell cellFromNib];
        cell.lbItem.text = @"维保订单";
        cell.ivIcon.image = [UIImage imageNamed:@"icon_my_order"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    } else if (1 == indexPath.row) {
        PersonItemCell *cell = [PersonItemCell cellFromNib];
        cell.lbItem.text = @"快修订单";
        cell.ivIcon.image = [UIImage imageNamed:@"icon_my_account"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    } else if (2 == indexPath.row) {
        PersonItemCell *cell = [PersonItemCell cellFromNib];
        cell.lbItem.text = @"设置";
        cell.ivIcon.image = [UIImage imageNamed:@"icon_settings_new"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PersonItemCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!self.login) {
        [HUDClass showHUDWithText:@"请您先登录"];
        return;
    }
 
    if (0 == indexPath.row)
    {
        MaintOrderController *controller = [[MaintOrderController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:controller animated:YES];
        
    } else if (1 == indexPath.row) {
        RepairOrderController *controller = [[RepairOrderController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:controller animated:YES];
        
    } else if (2 == indexPath.row) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"settings_controller"];
        
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

@end
