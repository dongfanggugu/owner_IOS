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
#import "HouseChangeView.h"
#import "ListDialogData.h"
#import "ListDialogView.h"

@interface ExtraServiceController () <UITableViewDelegate, UITableViewDataSource, HouseChangeViewDelegate, ListDialogViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayService;

@property (strong, nonatomic) IBOutlet HouseChangeView *headView;

@property (strong, nonatomic) NSDictionary *houseInfo;

@property (strong, nonatomic) NSMutableArray *arrayHouse;

@end

@implementation ExtraServiceController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"增值服务"];
    [self initTableView];
    [self getHouses];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)onClickNavRight
{
    ExtraServiceHistoryController *controller = [[ExtraServiceHistoryController alloc] init];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSMutableArray *)arrayService
{
    if (!_arrayService)
    {
        _arrayService = [NSMutableArray array];
    }

    return _arrayService;
}

- (NSMutableArray *)arrayHouse
{
    if (!_arrayHouse)
    {
        _arrayHouse = [NSMutableArray array];
    }

    return _arrayHouse;
}

/**
 设置别墅信息
 
 */
- (void)setHouseInfo:(NSDictionary *)houseInfo
{
    _houseInfo = houseInfo;

    if (_headView)
    {
        _headView.lbContent.text = houseInfo[@"cellName"];
    }
    [self getServices];
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

    _headView = [HouseChangeView viewFromNib];

    _headView.delegate = self;

    _tableView.tableHeaderView = _headView;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    //_tableView.separatorStyle = UITableViewCellSelectionStyleNone;

    [self.view addSubview:_tableView];
}

#pragma mark - 网络请求

/**
 villaId
 brand
 model
 cellName
 address
 lng
 lat
 weight
 layerAmount
 contacts
 contactsTel
 */
- (void)getHouses
{
    [[HttpClient shareClient] post:URL_GET_HOUSE parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.arrayHouse removeAllObjects];
        [self.arrayHouse addObjectsFromArray:responseObject[@"body"]];
        [self showHouseList];

    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}

- (void)showHouseList
{
    if (0 == self.arrayHouse.count)
    {
        return;
    }

    self.houseInfo = self.arrayHouse[0];

    if (1 == self.arrayHouse.count)
    {
        _headView.btnHidden = YES;
    }

}

- (void)selectHouse
{
    if (!self.houseInfo)
    {
        self.houseInfo = self.arrayHouse[0];
    }

    NSMutableArray *array = [NSMutableArray array];

    for (NSDictionary *info in self.arrayHouse)
    {
        ListDialogData *data = [[ListDialogData alloc] initWithKey:info[@"id"] content:info[@"cellName"]];
        [array addObject:data];
    }

    ListDialogView *dialog = [ListDialogView viewFromNib];
    dialog.delegate = self;
    [dialog setData:array];
    [dialog show];
}

#pragma mark - LisDialogViewDelegate

- (void)onSelectItem:(NSString *)key content:(NSString *)content
{
    for (NSDictionary *info in self.arrayHouse)
    {
        if ([key isEqualToString:info[@"id"]])
        {
            self.houseInfo = info;
            break;
        }
    }
}


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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"villaId"] = _houseInfo[@"id"];

    [[HttpClient shareClient] post:URL_GET_EXTRA parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.arrayService removeAllObjects];

        [self.arrayService addObjectsFromArray:responseObject[@"body"]];

        [_tableView reloadData];

//        if (0 == self.arrayService) {
//            [self initNoView];
//            
//        } else {
//            [_tableView reloadData];
//            
//        }
    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

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

    if (!cell)
    {
        cell = [ExtraServiceCell cellFromNib];
    }

    NSDictionary *info = self.arrayService[indexPath.row];

    cell.lbName.text = info[@"incrementTypeName"];


    NSString *expireTime = info[@"expireTime"];

    if (0 == expireTime.length)
    {
        cell.lbInfo.text = @"无效";

    }
    else
    {
        cell.lbInfo.text = [NSString stringWithFormat:@"%@ 到期", expireTime];

    }

    __weak typeof(self) weakSelf = self;

    [cell addOnClickDetailListener:^{
        NSString *detail = [info[@"incrementTypeInfo"] objectForKey:@"content"];
        [weakSelf onClickDetailButton:detail];
    }];

    [cell addOnClickLinkListener:^{
        [weakSelf onClickLinkButton];
    }];

    [cell addOnClickOrderListener:^{
        NSDictionary *serviceInfo = info[@"incrementTypeInfo"];
        [weakSelf onClickOrderButton:serviceInfo];
    }];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ExtraServiceCell cellHeight];
}

#pragma mark - MainOrderInfoViewDelegate

- (void)onClickLinkButton
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", Custom_Service]];
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

- (void)onClickOrderButton:(NSDictionary *)serviceInfo
{
    ExtraPayOrderController *controller = [[ExtraPayOrderController alloc] init];

    controller.serviceInfo = [[MainTypeInfo alloc] initWithDictionary:serviceInfo];
    controller.houseInfo = _houseInfo;

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - HouseInfoViewDelegate

- (void)onClickBtn:(HouseChangeView *)view
{
    [self selectHouse];
}

@end
