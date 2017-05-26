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

@interface OtherController() <UITableViewDelegate, UITableViewDataSource, MainTypeCellDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayService;

@end

@implementation OtherController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"增值服务"];
    [self initView];
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
    
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenWidth / 3)];
    
    iv.image = [UIImage imageNamed:@"icon_other_banner.png"];
    
    _tableView.tableHeaderView = iv;
    
}

#pragma mark - 网络请求

- (void)getServices
{
    [[HttpClient shareClient] post:@"getIncrementTypeList" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self.arrayService removeAllObjects];
        
        [self.arrayService addObjectsFromArray:responseObject[@"body"]];
        
        if (self.arrayService.count > 0) {
            [self addOrder:self.arrayService[0]];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MainTypeCell *cell = [MainTypeCell cellFromNib];
    
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MainTypeCell cellHeight];
}


- (void)addOrder:(NSDictionary *)serviceInfo
{
    MainTypeInfo *info = [[MainTypeInfo alloc] initWithDictionary:serviceInfo];
    
    ExtraOrderAddController *controller = [[ExtraOrderAddController alloc] init];
    controller.serviceInfo = info;
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];

}

#pragma mark - MainTypeCellDelegate

- (void)onClick1
{
    if (!self.login) {
        [HUDClass showHUDWithText:@"您需要先登录才能购买增值服务"];
        return;
    }
    [self getServices];
}

- (void)onClick2
{
    [HUDClass showHUDWithText:@"功能开发中,敬请期待"];
    return;
}

- (void)onClick3
{
    [HUDClass showHUDWithText:@"功能开发中,敬请期待"];
    return;
}

- (void)onClick4
{
    [HUDClass showHUDWithText:@"功能开发中,敬请期待"];
    return;
}

- (void)onClick5
{
    [HUDClass showHUDWithText:@"功能开发中,敬请期待"];
    return;
}

@end
