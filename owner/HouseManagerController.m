//
//  HouseManagerController.m
//  owner
//
//  Created by 长浩 张 on 2017/5/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "HouseManagerController.h"
#import "HouseItemCell.h"
#import "HouseAddController.h"
#import "HouseModifyController.h"

@interface HouseManagerController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayHouse;

@end

@implementation HouseManagerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"别墅管理"];
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getHouses];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64 - 60) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_tableView showCopyWrite];
    
    [self.view addSubview:_tableView];
    
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.screenHeight - 60, self.screenWidth, 60)];
    
    bottom.backgroundColor = [Utils getColorByRGB:@"#e1e1e1"];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth - 40, 40)];
    
    btn.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
    [btn setTitle:@"添加别墅" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addHouse) forControlEvents:UIControlEventTouchUpInside];
    
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    
    btn.center = CGPointMake(self.screenWidth / 2, 30);
    
    [bottom addSubview:btn];
    
    [self.view addSubview:bottom];
}

- (void)addHouse
{
    HouseAddController *controller = [[HouseAddController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSMutableArray *)arrayHouse
{
    if (!_arrayHouse) {
        _arrayHouse = [NSMutableArray array];
    }
    
    return _arrayHouse;
}


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
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

#pragma mark - 处理数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayHouse.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HouseItemCell *cell = [tableView dequeueReusableCellWithIdentifier:[HouseItemCell identifier]];
    
    if (!cell) {
        cell = [HouseItemCell cellFromNib];
    }
    
    NSDictionary *houseInfo = self.arrayHouse[indexPath.section];
    
    NSString *name = houseInfo[@"contacts"];
    
    cell.lbName.text = 0 == name.length ? [[Config shareConfig] getName] : name;
    
    NSString *tel = houseInfo[@"contactsTel"];
    
    cell.lbTel.text = 0 == tel.length ? [[Config shareConfig] getTel] : tel;
    
    cell.lbAddress.text = [NSString stringWithFormat:@"%@%@", houseInfo[@"cellName"], houseInfo[@"address"]];
    
    __weak typeof (self) weakSelf = self;
    [cell setOnClickEditListener:^{
        HouseModifyController *controller = [[HouseModifyController alloc] init];
        controller.houseInfo = houseInfo;
        
        controller.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
    
    [cell setOnClickDelListener:^{
        [self houseDel:houseInfo];
    }];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HouseItemCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 4;
}

#pragma mark - 删除别墅

- (void)houseDel:(NSDictionary *)info
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"确认删除" message:info[@"cellName"] preferredStyle:UIAlertControllerStyleAlert];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self confirmDel:info[@"id"]];
    }]];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)confirmDel:(NSString *)villaId
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"villaId"] = villaId;
    
    [[HttpClient shareClient] post:@"deleteVilla" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithText:@"别墅已经删除"];
        [self getHouses];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}


@end
