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

@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    _tableView.bounces = NO;
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
        
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    
    
    if (!cell)
    {
        cell = [MarketCell cellFromNib];
    }
    
    
    if (0 == indexPath.row)
    {
        cell.ivIcon.image = [UIImage imageNamed:@"icon_market1"];
        cell.viewBg.backgroundColor = [Utils getColorByRGB:@"#809900"];
        cell.lbTile.text = @"我要安装电梯";
        cell.lbTel.text = @"整梯销售";
    }
    else if (1 == indexPath.row)
    {
        cell.ivIcon.image = [UIImage imageNamed:@"icon_market2"];
        cell.viewBg.backgroundColor = [Utils getColorByRGB:@"#008099"];
        cell.lbTile.text = @"我要换配件";
        cell.lbTel.text = @"电梯配件";
    }
    else if (2 == indexPath.row)
    {
        cell.ivIcon.image = [UIImage imageNamed:@"icon_markt3"];
        cell.viewBg.backgroundColor = [Utils getColorByRGB:@"#c7ac00"];
        cell.lbTile.text = @"我要装修电梯";
        cell.lbTel.text = @"电梯装潢";
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
