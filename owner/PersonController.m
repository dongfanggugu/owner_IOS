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
    
    if (0 == userId.length)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"login_controller"];
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    else
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
//        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"person_center"];
//        
//        self.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:controller animated:YES];
//        self.hidesBottomBarWhenPushed = NO;
        
        UIViewController *destinationVC = [board instantiateViewControllerWithIdentifier:@"basicInfo"];
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:destinationVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
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
    if (0 == indexPath.row)
    {
        PersonItemCell *cell = [PersonItemCell cellFromNib];
        cell.lbItem.text = @"我的订单";
        cell.ivIcon.image = [UIImage imageNamed:@"icon_my_order"];
        
        return cell;
    }
    else if (1 == indexPath.row)
    {
        PersonItemCell *cell = [PersonItemCell cellFromNib];
        cell.lbItem.text = @"我的账户";
        cell.ivIcon.image = [UIImage imageNamed:@"icon_my_account"];
        
        return cell;
    }
    else if (2 == indexPath.row)
    {
        PersonItemCell *cell = [PersonItemCell cellFromNib];
        cell.lbItem.text = @"设置";
        cell.ivIcon.image = [UIImage imageNamed:@"icon_settings_new"];
        
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *userId = [[Config shareConfig] getUserId];
    
    if (0 == userId.length)
    {
        [HUDClass showHUDWithLabel:@"请您先登录" view:self.view];
        return;
    }
 
    if (0 == indexPath.row)
    {
        MyOrderController *controller = [[MyOrderController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    else if (1 == indexPath.row)
    {
        [HUDClass showHUDWithLabel:@"功能开发中,请稍后" view:self.view];
        return;
    }
    else if (2 == indexPath.row)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"settings_controller"];
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    
}

@end
