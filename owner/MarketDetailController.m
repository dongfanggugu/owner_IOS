//
//  MarketDetailController.m
//  owner
//
//  Created by 长浩 张 on 2017/1/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MarketDetailController.h"
#import "MarketCell.h"
#import "ElevatorSellController.h"
#import "ElevatorPartsController.h"
#import "ElevatorDecorateController.h"
#import "WebViewController.h"

@interface MarketDetailContrller()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MarketDetailContrller

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"电梯商城"];
    [self initView];
}


- (void)initView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenWidth / 2)];
    
    imageView.image = [UIImage imageNamed:@"icon_market_bottom"];
        
    _tableView.tableFooterView = imageView;
    
    [_tableView showCopyWrite];
    
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
    MarketCell *cell = [tableView dequeueReusableCellWithIdentifier:[MarketCell identifier]];
    
    
    if (!cell) {
        cell = [MarketCell cellFromNib];
    }
    
    
    if (0 == indexPath.row) {
        cell.ivIcon.image = [UIImage imageNamed:@"market_1"];
        cell.lbTitle.text = @"整梯销售";
        cell.lbTitle.backgroundColor = [Utils getColorByRGB:@"#36b0f3"];
        
    } else if (1 == indexPath.row) {
        cell.ivIcon.image = [UIImage imageNamed:@"market_2"];
        cell.lbTitle.text = @"电梯配件";
        cell.lbTitle.backgroundColor = [Utils getColorByRGB:@"#c7ac00"];
        
    } else if (2 == indexPath.row) {
        cell.ivIcon.image = [UIImage imageNamed:@"market_3"];
        cell.lbTitle.text = @"电梯装潢";
        cell.lbTitle.backgroundColor = [Utils getColorByRGB:@"#339900"];
    }
    
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MarketCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.row) {
        
        WebViewController *controller = [[WebViewController alloc] init];
        controller.marketType = Market_Lift;
        
        NSString *url = [NSString stringWithFormat:@"%@h5/indexPage", [Utils getIp]];
        
        controller.urlStr = url;
        
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    } else if (1 == indexPath.row) {
        UIViewController *controller = [[ElevatorPartsController alloc] init];
        
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    } else if (2 == indexPath.row) {
        WebViewController *controller = [[WebViewController alloc] init];
        controller.marketType = Market_Decorate;
        
        NSString *url = [NSString stringWithFormat:@"%@h5/indexelevatorDecorationPage", [Utils getIp]];
        
        controller.urlStr = url;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    }

}
@end
