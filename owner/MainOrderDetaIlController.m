//
//  MainOrderDetaIlController.m
//  owner
//
//  Created by 长浩 张 on 2017/5/25.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "MainOrderDetaIlController.h"
#import "MainOrderDetailCell.h"
#import "PayViewController.h"

@interface MainOrderDetaIlController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MainOrderDetaIlController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"订单详情"];
    
    [self initView];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

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
    MainOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[MainOrderDetailCell identifier]];
    
    if (!cell) {
        cell = [MainOrderDetailCell cellFromNib];
    }
    
    cell.lbCode.text = [NSString stringWithFormat:@"订单编号:%@", _orderInfo[@"code"]];
    
    cell.lbDate.text = [NSString stringWithFormat:@"下单时间:%@", _orderInfo[@"createTime"]];
    
    NSString *payType = [_orderInfo[@"mainttypeInfo"] objectForKey:@"name"];
    
    cell.lbName.text = [NSString stringWithFormat:@"服务类型:%@", payType];
    
    cell.lbContent.text = [_orderInfo[@"mainttypeInfo"] objectForKey:@"content"];
    
    cell.lbBrand.text = [NSString stringWithFormat:@"电梯品牌:%@", _houseInfo[@"brand"]];
    
    cell.lbAddress.text = [NSString stringWithFormat:@"别墅地址:%@", _houseInfo[@"cellName"]];
    
    
    cell.lbAmount.text = [NSString stringWithFormat:@"%ld", [_orderInfo[@"frequency"] integerValue]];
    
    
    CGFloat price = [[_orderInfo[@"mainttypeInfo"] objectForKey:@"price"] floatValue];
    
    cell.lbPrice.text = [NSString stringWithFormat:@"￥%.2lf", price];
    
    cell.lbDiscourt.text = @"￥0";
    
    cell.lbPay.text = [NSString stringWithFormat:@"￥%.2lf", [_orderInfo[@"payMoney"] floatValue]];
    
    cell.lbPayType.text = @"在线支付";
    
    NSInteger isPay = [_orderInfo[@"isPay"] integerValue];
    
    if (isPay) {
        cell.lbPayState.text = @"已经支付";
        cell.lbPayDate.text = _orderInfo[@"payTime"];
        cell.btn.hidden = YES;
        
    } else {
        
        NSInteger delete = [[_orderInfo[@"maintOrderInfo"] objectForKey:@"isDelete"] integerValue];
        
        if (delete) {
            cell.lbPayState.text = @"已过期";
            cell.lbPayDate.text = @"--";
            cell.btn.hidden = YES;
            
        } else {
            cell.lbPayState.text = @"未支付";
            cell.lbPayDate.text = @"--";
            cell.btn.hidden = NO;
            
            [cell.btn addTarget:self action:@selector(payment) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MainOrderDetailCell cellHeight];
}

- (void)payment
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"paymentId"] = _orderInfo[@"id"];
    
    [[HttpClient shareClient] post:@"continuePayment" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *url = [responseObject[@"body"] objectForKey:@"url"];
        
        if (url.length != 0) {
            PayViewController *controller = [[PayViewController alloc] init];
            controller.urlStr = url;
            
            [self presentViewController:controller animated:YES completion:^{
                [self.navigationController popViewControllerAnimated:NO];
            }];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];

}

@end
