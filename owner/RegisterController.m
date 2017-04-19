//
//  RegisterController.m
//  owner
//
//  Created by 长浩 张 on 17/1/8.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegisterController.h"
#import "LocationViewController.h"
#import "SelectableCell.h"
#import "BrandListResponse.h"
#import "AddressLocationController.h"
#import "KeyValueCell.h"

#pragma mark - RegisterCell

@interface RegisterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbKey;

@property (weak, nonatomic) IBOutlet UITextField *tfValue;

@property (weak, nonatomic) IBOutlet UIButton *btnLocation;


@end


@implementation RegisterCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _btnLocation.hidden = YES;
}

@end

#pragma mark - RegisterController

@interface RegisterController()<UITableViewDelegate, UITableViewDataSource, AddressLocationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet KeyValueCell *addressCell;

@end

@implementation RegisterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"注册"];
    [self initNavRightWithText:@"提交"];
    [self initView];
}


- (void)initView
{
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setAllowsSelection:NO];
}


- (void)onClickNavRight
{
    [self ownerRegister];
}

#pragma mark - NetworkRequest

- (void)ownerRegister
{
    RegisterCell *cell0 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *userName = cell0.tfValue.text;
    
    if (0 == userName.length) {
        [HUDClass showHUDWithText:@"请填写用户名"];
        return;
    }
    
    RegisterCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *name = cell1.tfValue.text;
    
    if (0 == name.length) {
        [HUDClass showHUDWithText:@"请填写用户姓名"];
        return;
    }
    
    RegisterCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *tel = cell2.tfValue.text;
    
    if (0 == tel.length) {
        [HUDClass showHUDWithText:@"请填写用户联系方式"];
        return;
    }
    
    RegisterCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *pwd = cell3.tfValue.text;
    
    if (0 == pwd.length) {
        [HUDClass showHUDWithText:@"请填写密码"];
        return;
    }
    
    
    RegisterCell *cell4 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    NSString *pwdConfirm = cell4.tfValue.text;
    
    if (![pwd isEqualToString:pwdConfirm]) {
        [HUDClass showHUDWithText:@"确认密码和密码不一致"];
        return;
    }
    
    SelectableCell *cell5 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    NSString *brand = cell5.getContentValue;
    
    NSString *address = _addressCell.lbValue.text;
    
    if (0 == address.length || [address isEqualToString:@"点击选择别墅地址"]) {
        [HUDClass showHUDWithText:@"请选择别墅地址"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginname"] = userName;
    params[@"name"] = name;
    params[@"tel"] = tel;
    params[@"sex"] = @"1";
    params[@"password"] = [Utils md5:pwd];
    params[@"brand"] = brand;
    params[@"address"] = address;
    params[@"lng"] = [NSNumber numberWithFloat:_lng];
    params[@"lat"] = [NSNumber numberWithFloat:_lat];
    
    
    [[HttpClient shareClient] post:@"addSmallOwner" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithText:@"注册成功,请使用您的用户名或手机号码登录"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

#pragma mark - UITabelViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    
    if (0 == index)
    {
        RegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"register_cell"];
        cell.lbKey.text = @"用户名";
        cell.tfValue.placeholder = @"用户名";
        
        return cell;
    }
    else if (1 == index)
    {
        RegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"register_cell"];
        
        cell.lbKey.text = @"姓名";
        cell.tfValue.placeholder = @"姓名";
        
        return cell;
    }
    else if (2 == index)
    {
        RegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"register_cell"];
        
        cell.lbKey.text = @"电话";
        cell.tfValue.placeholder = @"电话";
        
        return cell;
    }
    else if (3 == index)
    {
        RegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"register_cell"];
        
        cell.lbKey.text = @"密码";
        cell.tfValue.placeholder = @"密码";
        
        cell.tfValue.secureTextEntry = YES;
        
        return cell;
    }
    else if (4 == index)
    {
        
        RegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"register_cell"];
        
        cell.lbKey.text = @"确认密码";
        cell.tfValue.placeholder = @"确认密码";
        
        cell.tfValue.secureTextEntry = YES;
        
        return cell;
    }
    else if (5 == index)
    {
        SelectableCell *cell = [SelectableCell cellFromNib];
        
        cell.lbKey.text = @"电梯品牌";
        
        [[HttpClient shareClient] post:URL_LIFT_BRAND parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            BrandListResponse *response = [[BrandListResponse alloc] initWithDictionary:responseObject];
            [cell setData:[response getBrandList]];
        } failure:^(NSURLSessionDataTask *task, NSError *errr) {
            
        }];
   
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (6 == index)
    {
//        RegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"register_cell"];
//        
//        cell.lbKey.text = @"小区地址";
//        cell.tfValue.placeholder = @"小区地址";
//        cell.btnLocation.hidden = YES;
//        [cell.btnLocation addTarget:self action:@selector(addressLocation) forControlEvents:UIControlEventTouchUpInside];
        
        KeyValueCell *cell = [tableView dequeueReusableCellWithIdentifier:[KeyValueCell identifier]];
        
        if (!cell) {
            cell = [KeyValueCell cellFromNib];
        }
        
        _addressCell = cell;
        
        cell.lbKey.text = @"别墅地址";
        cell.lbValue.text = @"点击选择别墅地址";
        
        cell.lbValue.userInteractionEnabled = YES;
        
        [cell.lbValue addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressLocation)]];
        
        return cell;
    }
    
    return nil;
}

- (void)addressLocation
{
//    RegisterCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
//    NSString *address = cell.tfValue.text;
    
//    if (0 == address.length) {
//        [HUDClass showHUDWithText:@"请先填写小区地址"];
//        
//        return;
//    }
    
//    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
//    LocationViewController *controller = [board instantiateViewControllerWithIdentifier:@"address_location"];
//    controller.delegate = self;
//    controller.enterType = 1;
//    controller.address = address;
//    controller.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:controller animated:YES];
    
    AddressLocationController *controller = [[AddressLocationController alloc] init];
    controller.delegate = self;
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - LocationControllerDelegate
- (void)onChooseAddress:(NSString *)address Lat:(CGFloat)lat lng:(CGFloat)lng
{
    _addressCell.lbValue.text = address;
    _lat = lat;
    _lng = lng;
}

@end
