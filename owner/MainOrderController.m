//
//  MainOrderController.m
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainOrderController.h"
#import "MainOrderInfoCell.h"
#import "KeyValueCell.h"
#import "KeyEditCell.h"
#import "SelectableCell.h"
#import "BrandListResponse.h"
#import "KeyEditBtnCell.h"
#import "SMSCodeRequest.h"
#import "SMSCodeResponse.h"
#import "MainOrderAddRequest.h"
#import "MainTaskDetailController.h"
#import "MainTypeDetailController.h"
#import "OrderAmountCell.h"
#import "PayViewController.h"
#import "AddressLocationController.h"

@interface MainOrderController () <UITableViewDelegate, UITableViewDataSource, PayViewControllerDelegate, AddressLocationControllerDelegate>


@property (strong, nonatomic) UITableView *tableView;

@property (weak, nonatomic) UILabel *lbBrand;

@property (weak, nonatomic) UITextField *tfType;

@property (weak, nonatomic) UITextField *tfName;

@property (weak, nonatomic) UITextField *tfTel;

@property (weak, nonatomic) UITextField *tfCode;

@property (assign, nonatomic) CGFloat lat;

@property (assign, nonatomic) CGFloat lng;


@property (weak, nonatomic) OrderAmountCell *amountCell;

@property (weak, nonatomic) SelectableCell *brandCell;

@property (weak, nonatomic) KeyEditCell *modelCell;

@property (weak, nonatomic) KeyEditCell *nameCell;

@property (weak, nonatomic) KeyEditBtnCell *telCell;

@property (weak, nonatomic) KeyValueCell *addressCell;

@end


@implementation MainOrderController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"服务订单"];
    [self initData];
    [self initView];
}

- (void)submit
{
    MainOrderAddRequest *request = [[MainOrderAddRequest alloc] init];
    request.mainttypeId = _mainInfo.typeId;
    request.frequency = _amountCell.amount;
    
    if (!self.login) {
        NSString *brand = _lbBrand.text;
        
        NSString *type = _tfType.text;
        
        if (0 == type.length) {
            [HUDClass showHUDWithText:@"请填写电梯品牌"];
            return;
        }
        
        NSString *name = _tfName.text;
        
        if (0 == name.length) {
            [HUDClass showHUDWithText:@"请填写用户姓名"];
            return;
        }
        
        NSString *tel = _tfTel.text;
        
        if (0 == tel.length) {
            [HUDClass showHUDWithText:@"请填写用户手机号码"];
            return;
        }
        
        NSString *code = _tfCode.text;
        
        if (0 == code.length) {
            [HUDClass showHUDWithText:@"请填写验证码"];
            return;
        }
        
        if (![code isEqualToString:[[Config shareConfig] getSMSCode]]) {
            [HUDClass showHUDWithText:@"验证码不正确，请确认验证码"];
            return;
            
        }
        
        NSString *address = _addressCell.lbValue.text;
        
        if (0 == address.length) {
            [HUDClass showHUDWithText:@"请选择您的地址"];
            return;
        }
        
        
        
        
        request.brand = brand;
        request.model = type;
        request.name = name;
        request.tel = tel;
        request.address = address;
        request.lat = _lat;
        request.lng = _lng;
    }
    
    
    [[HttpClient shareClient] post:URL_MAIN_ADD parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *url = [responseObject[@"body"] objectForKey:@"url"];
        
        if (url.length != 0) {
            PayViewController *controller = [[PayViewController alloc] init];
            controller.urlStr = url;
            
            controller.delegate = self;
            
            [self presentViewController:controller animated:YES completion:^{
                [self.navigationController popViewControllerAnimated:NO];
            }];
            //controller.hidesBottomBarWhenPushed = YES;
            //[self.navigationController popViewControllerAnimated:NO];
            //[self.navigationController pushViewController:controller animated:YES];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData
{

}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)
                                              style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
   //_tableView.bounces = NO;
    
    [self.view addSubview:_tableView];
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 80)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    
    btn.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
    [btn setTitle:@"确认并支付" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    
    btn.center = CGPointMake(self.screenWidth / 2, 40);
    [footView addSubview:btn];
    
    _tableView.tableFooterView = footView;
    
}


#pragma mark - Network Request


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.login) {
        return 2;
        
    } else {
        return 3;
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return 2;
        
    } else if (1 == section) {
        return 2;
        
    } else {
        return 4;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        
        if (0 == indexPath.row) {
            MainOrderInfoCell *cell = [MainOrderInfoCell cellFromNib];
            
            cell.lbName.text = [NSString stringWithFormat:@"%@ ￥%.2lf", _mainInfo.name, _mainInfo.price];
            cell.lbContent.text = _mainInfo.content;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (1 == indexPath.row) {
            
            if (_amountCell) {
                return _amountCell;
            }
            
            OrderAmountCell *cell = [OrderAmountCell cellFromNib];
            _amountCell = cell;
            
            cell.price = _mainInfo.price;
            
            return cell;
        }
        
    } else if (1 == indexPath.section) {
        
        if (0 == indexPath.row) {
            
            if (_brandCell) {
                return _brandCell;
                
            } else {
                SelectableCell *cell = [SelectableCell cellFromNib];
                
                _brandCell = cell;
                
                
                cell.lbKey.text = @"电梯品牌";
                
                _lbBrand = cell.lbContent;
                
                if (!self.login) {
                    [[HttpClient shareClient] post:URL_LIFT_BRAND parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                        BrandListResponse *response = [[BrandListResponse alloc] initWithDictionary:responseObject];
                        [cell setData:[response getBrandList]];
                    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                        
                    }];
                    
                } else {
                    cell.lbContent.text = [[Config shareConfig] getBrand];
                    cell.showable = NO;
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
        } else {
            if (_modelCell) {
                return _modelCell;
                
            } else {
                KeyEditCell *cell = [KeyEditCell cellFromNib];
                _modelCell = cell;
                
                cell.lbKey.text = @"电梯型号";
                
                if (!self.login) {
                    cell.tfValue.placeholder = @"电梯型号";
                    
                    _tfType = cell.tfValue;
                    
                } else {
                    cell.tfValue.text = [[Config shareConfig] getLiftType];
                    
                    cell.tfValue.enabled = NO;
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        
    } else if (2 == indexPath.section) {
        if (0 == indexPath.row) {
            if (_nameCell) {
                return _nameCell;
            
            } else {
                KeyEditCell *cell = [KeyEditCell cellFromNib];
                _nameCell = cell;
                
                cell.lbKey.text = @"姓名";
                
                cell.tfValue.placeholder = @"姓名";
                _tfName = cell.tfValue;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
        } else if (1 == indexPath.row) {
            
            if (_telCell) {
                return _telCell;
                
            } else {
                KeyEditBtnCell *cell = [KeyEditBtnCell cellFromNib];
                _telCell = cell;
                
                cell.lbKey.text = @"手机";
                cell.tfValue.placeholder = @"手机";
                cell.tfValue.keyboardType = UIKeyboardTypePhonePad;
                
                _tfTel = cell.tfValue;
                
                
                __weak typeof(cell) weakCell = cell;
                
                [cell setOnClickBtnListener:^{
                    
                    NSString *tel = weakCell.tfValue.text;
                    
                    if (0 == tel.length || tel.length != 11) {
                        [HUDClass showHUDWithText:@"请输入正确的手机号码"];
                        return;
                    }
                    SMSCodeRequest *request = [[SMSCodeRequest alloc] init];
                    request.tel = tel;
                    
                    [[HttpClient shareClient] post:URL_SMS_CODE parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
                        SMSCodeResponse *response = [[SMSCodeResponse alloc] initWithDictionary:responseObject];
                        [[Config shareConfig] setSMCode:[response getSMSCode]];
                    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                        
                    }];
                }];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
        } else if (2 == indexPath.row) {
            KeyEditCell *cell = [KeyEditCell cellFromNib];
            cell.lbKey.text = @"验证码";
            
            cell.tfValue.placeholder = @"验证码";
            _tfCode = cell.tfValue;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        } else {
            
            if (_addressCell) {
                return _addressCell;
                
            } else {
                KeyValueCell *cell =  [KeyValueCell cellFromNib];
                _addressCell = cell;
                
                cell.lbKey.text = @"别墅地址";
                cell.lbValue.text = @"点击选择别墅地址";
                
                cell.lbValue.userInteractionEnabled = YES;
                
                [cell.lbValue addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressLocation)]];
                
                return cell;
            }
        }
    }
    
    
    KeyEditCell *cell = [KeyEditCell cellFromNib];
    cell.lbKey.text = @"验证码";
    
    cell.tfValue.placeholder = @"验证码";
    _tfCode = cell.tfValue;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        
        if (0 == indexPath.row) {
            return [MainOrderInfoCell cellHeight];
            
        } else {
            return [OrderAmountCell cellHeight];
        }
        
    } else {
        return [KeyEditCell cellHeight];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 40)];
    view.backgroundColor = [Utils getColorByRGB:@"#f1f1f1"];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 20)];
    titleView.center = CGPointMake(16, 20);
    titleView.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [Utils getColorByRGB:TITLE_COLOR];
    label.center = CGPointMake(75, 20);
    
    [view addSubview:titleView];
    [view addSubview:label];
    
    if (0 == section) {
        label.text = @"订单信息";
        return view;
        
    } else if (1 == section) {
        label.text = @"电梯信息";
        return view;
        
    } else {
        label.text = @"业主信息";
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (0 == indexPath.section && 0 == indexPath.row) {
        
        MainTypeDetailController *controller = [[MainTypeDetailController alloc] init];
        
        controller.detail = self.mainInfo.content;
        
        controller.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)addressLocation
{
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

#pragma mark - PayViewControllerDelegate

- (void)clickBack
{
    
}

@end
