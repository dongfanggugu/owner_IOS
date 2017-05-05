//
//  ExtraServiceController.m
//  owner
//
//  Created by 长浩 张 on 2017/5/4.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "ExtraServiceController.h"
#import "MainOrderInfoView.h"
#import <objc/runtime.h>
#import "MainTypeDetailController.h"
#import "ExtraOrderAddController.h"
#import "MainTypeInfo.h"
#import "PayOrderController.h"
#import "ExtraPayOrderController.h"
#import "ExtraServiceCell.h"
#import "ExtraServiceHistoryController.h"

@interface ExtraServiceController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayService;

@end

@implementation ExtraServiceController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"增值服务"];
    [self initNavRightWithText:@"查看历史"];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getServices];
}

- (void)onClickNavRight
{
    ExtraServiceHistoryController *controller = [[ExtraServiceHistoryController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSMutableArray *)arrayService
{
    if (!_arrayService) {
        _arrayService = [NSMutableArray array];
    }
    
    return _arrayService;
}

- (void)initNoView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 70, self.screenWidth - 32, 40)];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    
    label.numberOfLines = 0;
    
    label.text = @"您还没有订购增值服务,请到服务->增值服务中订制您的服务!";
    
    [self.view addSubview:label];
    
    return;
}

- (void)initTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //_tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self.view addSubview:_tableView];
}

#pragma mark - 网络请求


/** 获取用户订购的增值服务
 id         服务单ID
 code    服务单编号
 incrementTypeId   服务类型ID
 incrementTypeName   服务类型名称
 smallOwnerId     业主ID
 smallOwnerName  业主名字
 smallOwnerTel   业主电话
 createTime    创建时间
 expireTime    到期时间
 isDelete   是否退订
 deleteTime   退订时间
 deleteUserId  退订人ID
 frequency  次数
 incrementTypeInfo   服务类型信息
 smallOwnerInfo  业主信息
 deleteUserInfo   退订人信息
 */
- (void)getServices
{
    [[HttpClient shareClient] post:URL_GET_EXTRA parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.arrayService removeAllObjects];
        
        [self.arrayService addObjectsFromArray:responseObject[@"body"]];
        
        if (0 == self.arrayService) {
            [self initNoView];
            
        } else {
            [_tableView reloadData];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

#pragma mark - UITableViewDataSource

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
    
    ExtraServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:[ExtraServiceCell identifier]];
    
    if (!cell) {
        cell = [ExtraServiceCell cellFromNib];
    }
    
    NSDictionary *info = self.arrayService[indexPath.row];
    
    cell.lbName.text = info[@"incrementTypeName"];
    
    NSString *url = [info[@"incrementTypeInfo"] objectForKey:@"logo"];
    
    if (url.length > 0) {
        [cell.ivLogo setImageWithURL:[NSURL URLWithString:url]];
    }
    
    NSString *expireTime = info[@"expireTime"];
    
    if (0 == expireTime.length) {
        cell.lbInfo.text = @"无效";
        
    } else {
        cell.lbInfo.text = [NSString stringWithFormat:@"到期日期:%@", expireTime];
        
    }
    
    __weak typeof (self) weakSelf = self;
    
    [cell addOnClickDetailListener:^{
        NSString *detail = [info[@"incrementTypeInfo"] objectForKey:@"content"];
        [weakSelf onClickDetailButton:detail];
    }];
    
    [cell addOnClickPayListener:^{
        NSDictionary *serviceInfo = info[@"incrementTypeInfo"];
        [weakSelf onClickPayButton:serviceInfo];
    }];
    
    [cell addOnClickLinkListener:^{
        [weakSelf onClickLinkButton];
    }];
    
    [cell addOnClickOrderListener:^{
        NSDictionary *serviceInfo = info[@"incrementTypeInfo"];
        [weakSelf onClickOrderButton:serviceInfo];
    }];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

#pragma mark - MainOrderInfoViewDelegate

- (void)onClickLinkButton
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",Custom_Service]];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [webView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:webView];
}

- (void)onClickDetailButton:(NSString *)detail
{
    MainTypeDetailController *controller = [[MainTypeDetailController alloc] init];
    
    controller.detail = detail;
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickPayButton:(NSDictionary *)serviceInfo
{
    ExtraOrderAddController *controller = [[ExtraOrderAddController alloc] init];
    controller.serviceInfo =  [[MainTypeInfo alloc] initWithDictionary:serviceInfo];
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickOrderButton:(NSDictionary *)serviceInfo
{
    ExtraPayOrderController *controller = [[ExtraPayOrderController alloc] init];
    
    controller.serviceInfo = [[MainTypeInfo alloc] initWithDictionary:serviceInfo];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
