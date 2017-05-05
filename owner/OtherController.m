//
//  OtherController.m
//  owner
//
//  Created by 长浩 张 on 2017/1/18.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OtherController.h"
#import "MainTypeCell.h"
#import "MainTypeDetailController.h"
#import "MainTypeInfo.h"
#import "MainOrderController.h"
#import "ExtraOrderAddController.h"

@interface OtherController() <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayService;

@end

@implementation OtherController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"增值服务"];
    [self initView];
    [self getServices];
}

- (NSMutableArray *)arrayService
{
    if (nil == _arrayService) {
        _arrayService = [NSMutableArray array];
    }
    
    return _arrayService;
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    
    //headview
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenWidth / 2)];
    
    _tableView.tableHeaderView = headView;
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenWidth / 2)];
    
    iv.image = [UIImage imageNamed:@"icon_other_banner.png"];
    
    [headView addSubview:iv];
    
}

#pragma mark - 网络请求

- (void)getServices
{
    [[HttpClient shareClient] post:@"getIncrementTypeList" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self.arrayService removeAllObjects];
        
        [self.arrayService addObjectsFromArray:responseObject[@"body"]];
        
        [self.tableView reloadData];
        
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
    MainTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:[MainTypeCell identifier]];
    
    if (!cell) {
        cell = [MainTypeCell cellFromNib];
    }
    
    NSDictionary *info = self.arrayService[indexPath.row];
    
    cell.lbName.text = info[@"name"];
    
    cell.lbContent.text = info[@"content"];
    
    cell.lbPrice.text = [NSString stringWithFormat:@"￥%.2lf", [info[@"price"] floatValue]];
    
    NSString *url = info[@"logo"];
    
    if (url.length > 0) {
        [cell.imageView setImageWithURL:[NSURL URLWithString:url]];
    }
    
    
    __weak typeof (self) weakSelf = self;
    [cell setOnClickListener:^{
        MainTypeDetailController *controller = [[MainTypeDetailController alloc] init];
        
        controller.detail = info[@"content"];
        
        controller.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MainTypeCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTypeInfo *info = [[MainTypeInfo alloc] initWithDictionary:self.arrayService[indexPath.row]];
    
    ExtraOrderAddController *controller = [[ExtraOrderAddController alloc] init];
    controller.serviceInfo = info;
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
