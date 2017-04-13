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
        cell.lbTile.text = @"我要装电梯";
        //cell.lbTel.text = @"业务联系电话"
    }
    else if (1 == indexPath.row)
    {
        cell.ivIcon.image = [UIImage imageNamed:@"icon_market2"];
        cell.viewBg.backgroundColor = [Utils getColorByRGB:@"#008099"];
        cell.lbTile.text = @"我要换配件";
        //cell.lbTel.text = @"业务联系电话"
    }
    else if (2 == indexPath.row)
    {
        cell.ivIcon.image = [UIImage imageNamed:@"icon_markt3"];
        cell.viewBg.backgroundColor = [Utils getColorByRGB:@"#c7ac00"];
        cell.lbTile.text = @"电梯装潢";
    }
    
    cell.lbTel.text = @"业务联系电话:400-0615-365";

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
    
    if (0 == indexPath.row)
    {
        UIViewController *controller = [[ElevatorSellController alloc] init];
        
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (1 == indexPath.row)
    {
        UIViewController *controller = [[ElevatorPartsController alloc] init];
        
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (2 == indexPath.row)
    {
        UIViewController *controller = [[ElevatorDecorateController alloc] init];
        
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
//    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", @"4000615365"]];
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
//    [webView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
//    [self.view addSubview:webView];

}
@end
