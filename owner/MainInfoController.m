//
//  MainInfoController.m
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainInfoController.h"
#import "MainOrderInfoView.h"
#import "MainTaskInfo.h"
#import "MainTaskListResponse.h"
#import "MainTaskCell.h"
#import "MainTaskDetailController.h"
#import "PayOrderController.h"
#import "MainTypeDetailController.h"
#import "MainOrderLoginController.h"
#import "ServiceHistoryController.h"
#import "ListDialogData.h"
#import "ListDialogView.h"

@interface MainInfoController () <UITableViewDelegate, UITableViewDataSource, MainOrderInfoViewDelegate, ListDialogViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) MainOrderInfoView *infoView;

@property (strong, nonatomic) UILabel *lbNone;

@property (strong, nonatomic) NSMutableArray<MainTaskInfo *> *arrayTask;

@property (strong, nonatomic) MainOrderInfo *serviceInfo;

@property (strong, nonatomic) NSDictionary *houseInfo;

@property (strong, nonatomic) NSMutableArray *arrayHouse;

@end

@implementation MainInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维保服务"];
    [self initView];
    [self initData];
    [self getHouses];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (void)initData
{
    _arrayTask = [NSMutableArray array];
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

 @param houseInfo <#houseInfo description#>
 */
- (void)setHouseInfo:(NSDictionary *)houseInfo
{
    _houseInfo = houseInfo;

    if (_infoView)
    {
        _infoView.lbAddress.text = houseInfo[@"cellName"];
    }
    [self getServiceInfo];
}

- (Maint_Type)maintType
{
    return _serviceInfo.mainttypeId.integerValue;
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    //维保记录
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    [_tableView showCopyWrite];


    //显示服务订单信息
    _infoView = [MainOrderInfoView viewFromNib];

    _tableView.tableHeaderView = _infoView;

    _infoView.delegate = self;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:_tableView];

    //当没有维保信息时，提示
    _lbNone = [[UILabel alloc] initWithFrame:CGRectMake(16, 120, self.screenWidth - 32, 40)];
    _lbNone.font = [UIFont systemFontOfSize:14];
    _lbNone.textAlignment = NSTextAlignmentCenter;

    _lbNone.numberOfLines = 0;

    _lbNone.text = @"您还没有订购有效的维保服务,请到服务->电梯管家中订制您的维保!";

    [self.view addSubview:_lbNone];
}

- (void)initMainInfo
{
    if (!_serviceInfo)
    {

        _infoView.viewHidden = YES;

        _lbNone.hidden = NO;

        return;
    }

    _infoView.viewHidden = NO;

    _lbNone.hidden = YES;

    _infoView.lbName.text = [_serviceInfo.maintypeInfo name];


    if (Maint_Low == self.maintType)
    {
        _infoView.lbInfo.text = [NSString stringWithFormat:@"剩余次数:%ld", _serviceInfo.frequency];

        _infoView.lbTag.text = @"三级管家";

    }
    else if (Maint_Mid == self.maintType)
    {
        if (0 == _serviceInfo.expireTime)
        {
            _infoView.lbInfo.text = @"无效";

        }
        else
        {
            _infoView.lbInfo.text = [NSString stringWithFormat:@"%@ 到期", _serviceInfo.expireTime];

        }

        _infoView.lbTag.text = @"二级管家";

    }
    else
    {
        if (0 == _serviceInfo.expireTime)
        {
            _infoView.lbInfo.text = @"无效";

        }
        else
        {
            _infoView.lbInfo.text = [NSString stringWithFormat:@"%@ 到期", _serviceInfo.expireTime];

        }

        _infoView.lbTag.text = @"一级管家";
    }

}

#pragma mark - Network Request

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
        _infoView.btnChange.hidden = YES;
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


- (void)getServiceInfo
{
    if (!_houseInfo)
    {
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"villaId"] = _houseInfo[@"id"];

    [[HttpClient shareClient] post:URL_MAIN_LIST parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {


        if ([responseObject[@"body"] count] > 0)
        {
            _serviceInfo = [[MainOrderInfo alloc] initWithDictionary:responseObject[@"body"][0]];
        }
        else
        {
            _serviceInfo = nil;
        }
        [self initMainInfo];
        [self getTask];

    } failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}


- (void)getTask
{
    if (!_serviceInfo)
    {
        [_arrayTask removeAllObjects];
        [_tableView reloadData];
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"villaId"] = _houseInfo[@"id"];
    params[@"maintOrderId"] = _serviceInfo.orderId;

    [[HttpClient shareClient] post:URL_MAIN_TASK parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        MainTaskListResponse *response = [[MainTaskListResponse alloc] initWithDictionary:responseObject];

        [_arrayTask removeAllObjects];

        [_arrayTask addObjectsFromArray:[response getTaskList]];

        [_tableView reloadData];
    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}

//0待确认 1已确认 2已完成 3已评价
- (NSString *)getStateDes:(NSInteger)state
{
    NSString *res = @"";

    switch (state)
    {
        case 0:
            res = @"待确认";
            break;

        case 1:
            res = @"已确认";
            break;

        case 2:
            res = @"已出发";
            break;

        case 3:
            res = @"已到达";
            break;

        case 4:
            res = @"待评价";
            break;

        case 5:
            res = @"已评价";
            break;

        default:
            break;
    }

    return res;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayTask.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:[MainTaskCell identifier]];

    if (!cell)
    {
        cell = [MainTaskCell cellFromNib];
    }

    MainTaskInfo *info = _arrayTask[indexPath.row];

    cell.lbIndex.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];

    cell.lbCode.text = info.taskCode;

    cell.lbState.text = [self getStateDes:info.state.integerValue];

    cell.lbWorker.text = [NSString stringWithFormat:@"维保工人: %@", info.maintUserInfo.name];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MainTaskCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MainTaskDetailController *controller = [[MainTaskDetailController alloc] init];
    controller.taskInfo = _arrayTask[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - MainOrderInfoViewDelegate

- (void)onClickPayButton:(MainOrderInfoView *)view
{
    MainOrderLoginController *controller = [[MainOrderLoginController alloc] init];
    controller.mainInfo = _serviceInfo.maintypeInfo;
    controller.houseInfo = _houseInfo;

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickOrderButton:(MainOrderInfoView *)view
{
    PayOrderController *controller = [[PayOrderController alloc] init];
    controller.serviceId = _serviceInfo.orderId;
    controller.houseInfo = _houseInfo;

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickDetailButton:(MainOrderInfoView *)view
{
    MainTypeDetailController *controller = [[MainTypeDetailController alloc] init];

    controller.detail = _serviceInfo.maintypeInfo.content;

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickChangeButton:(MainOrderInfoView *)view
{
    [self selectHouse];
}


- (void)onClickBackButton:(MainOrderInfoView *)view
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", Custom_Service]];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [webView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:webView];
}


@end
