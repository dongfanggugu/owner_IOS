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
#import "DialogEditView.h"
#import "KeyValueBtnCell.h"
#import "LinkModifyController.h"
#import "MainTypeInfo.h"
#import "ListDialogData.h"

@interface MainOrderController () <UITableViewDelegate, UITableViewDataSource, PayViewControllerDelegate, AddressLocationControllerDelegate>


@property (strong, nonatomic) UITableView *tableView;


@property (weak, nonatomic) UITextField *tfCode;

@property (copy, nonatomic) NSString *cellName;

@property (copy, nonatomic) NSString *address;

@property (assign, nonatomic) CGFloat lat;

@property (assign, nonatomic) CGFloat lng;


@property (weak, nonatomic) OrderAmountCell *amountCell;

@property (weak, nonatomic) SelectableCell *brandCell;

@property (weak, nonatomic) SelectableCell *weightCell;

@property (weak, nonatomic) SelectableCell *layerCell;

@property (weak, nonatomic) KeyEditCell *nameCell;

@property (weak, nonatomic) KeyEditBtnCell *telCell;

@property (weak, nonatomic) KeyValueCell *addressCell;

@property (weak, nonatomic) KeyEditCell *linkNameCell;

@property (weak, nonatomic) KeyEditCell *linkTelCell;

@end


@implementation MainOrderController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"服务订单"];
    [self initNavRightWithText:@"联系我们"];
    [self initView];
}

- (void)onClickNavRight
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",Custom_Service]];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [webView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:webView];
}

- (void)submit
{
    MainOrderAddRequest *request = [[MainOrderAddRequest alloc] init];
    request.mainttypeId = _mainInfo.typeId;
    request.frequency = _amountCell.amount;
    
    NSString *brand = _brandCell.getContentValue;
    
    if (0 == brand.length) {
        [HUDClass showHUDWithText:@"请选择电梯品牌"];
        return;
    }
    
    NSString *weight = [Utils string:_weightCell.getContentValue substringBeforeChar:@"k"];
    
    if (0 == weight.length) {
        [HUDClass showHUDWithText:@"请选择电梯载重量"];
        return;
    }
    
    NSString *layer = [Utils string:_layerCell.getContentValue substringBeforeChar:@"层"];
    
    if (0 == layer.length) {
        [HUDClass showHUDWithText:@"请选择电梯电梯层站"];
        return;
    }
    
    NSString *name = _nameCell.tfValue.text;
    
    if (0 == name.length) {
        [HUDClass showHUDWithText:@"请填写业主姓名"];
        return;
    }
    
    NSString *tel = _telCell.tfValue.text;
    
    if (0 == tel.length) {
        [HUDClass showHUDWithText:@"请填写业主手机号码"];
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
    
    
    NSString *linkName = _linkNameCell.tfValue.text;
    
    NSString *linkTel = _linkTelCell.tfValue.text;
    
    if (0 == linkName || 0 == linkTel) {
        
        [HUDClass showHUDWithText:@"请正确填写联系人信息"];
        return;
    }
    
    request.brand = brand;
    request.weight = weight.floatValue;
    request.layerAmount = layer.integerValue;
    request.name = name;
    request.tel = tel;
    request.cellName = _cellName;
    request.address = _address;
    request.lat = _lat;
    request.lng = _lng;
    request.contacts = name;
    request.contactsTel = tel;
    
    
    [[HttpClient shareClient] post:URL_MAIN_ADD parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *url = [responseObject[@"body"] objectForKey:@"url"];
        
        if (url.length != 0) {
            PayViewController *controller = [[PayViewController alloc] init];
            controller.urlStr = url;
            
            controller.delegate = self;
            
            [self presentViewController:controller animated:YES completion:^{
                [self.navigationController popViewControllerAnimated:NO];
            }];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return 2;
        
    } else if (1 == section) {
        return 3;
        
    } else {
        return 6;
        
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
                
                __weak typeof (cell) weakCell = cell;
                
                __weak typeof (self) weakSelf = self;
                [[HttpClient shareClient] post:URL_LIFT_BRAND parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    BrandListResponse *response = [[BrandListResponse alloc] initWithDictionary:responseObject];
                    [weakCell setData:[response getBrandList]];
                    
                    [weakCell setBeforeSelectedListener:^(NSString *preContent, NSString *content) {
                        if ([content isEqualToString:@"其他"]) {
                            [weakSelf showEditDialog:weakCell pre:preContent];
                        }
                    }];
                } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                    
                }];
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
        } else if (1 == indexPath.row) {
            if (_weightCell) {
                return _weightCell;
            
            } else {
            
                SelectableCell *cell = [SelectableCell cellFromNib];
                _weightCell = cell;
                
                cell.lbKey.text = @"载重量";
                
                __weak typeof (self) weakSelf = self;
                __weak typeof (cell) weakCell = cell;
                
                ListDialogData *data1 = [[ListDialogData alloc] initWithKey:nil content:@"240kg"];
                
                ListDialogData *data2 = [[ListDialogData alloc] initWithKey:nil content:@"320kg"];
                
                ListDialogData *data3 = [[ListDialogData alloc] initWithKey:nil content:@"480kg"];
                
                ListDialogData *data4 = [[ListDialogData alloc] initWithKey:nil content:@"640kg"];
                
                ListDialogData *data5 = [[ListDialogData alloc] initWithKey:nil content:@"其他"];
                
                NSArray *array = [[NSArray alloc] initWithObjects:data1, data2, data3, data4, data5, nil];
                
                [cell setData:array];
                
                [cell setBeforeSelectedListener:^(NSString *preContent, NSString *content) {
                    if ([content isEqualToString:@"其他"]) {
                        [weakSelf showWeightEditDialog:weakCell pre:preContent];
                    }
                }];
                
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
        } else if (2 == indexPath.row) {
            if (_layerCell) {
                return _layerCell;
                
            } else {
                SelectableCell *cell = [SelectableCell cellFromNib];
                _layerCell = cell;
                
                cell.lbKey.text = @"电梯层站";
                
                ListDialogData *data1 = [[ListDialogData alloc] initWithKey:nil content:@"2层"];
                
                ListDialogData *data2 = [[ListDialogData alloc] initWithKey:nil content:@"3层"];
                
                ListDialogData *data3 = [[ListDialogData alloc] initWithKey:nil content:@"4层"];
                
                ListDialogData *data4 = [[ListDialogData alloc] initWithKey:nil content:@"5层"];
                
                ListDialogData *data5 = [[ListDialogData alloc] initWithKey:nil content:@"6层"];
                
                ListDialogData *data6 = [[ListDialogData alloc] initWithKey:nil content:@"7层"];
                
                
                NSArray *array = [[NSArray alloc] initWithObjects:data1, data2, data3, data4, data5, data6, nil];
                
                [cell setData:array];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            
            }
        }
        
    } else if (2 == indexPath.section) {
        
        if (0 == indexPath.row) {
            if (_linkNameCell) {
                return _linkNameCell;
                
            } else {
                KeyEditCell *cell = [KeyEditCell cellFromNib];
                _linkNameCell = cell;
                
                cell.lbKey.text = @"联系人";
                cell.tfValue.placeholder = @"请输入别墅联系人";
                
                return cell;
            }

            
        } else if (1 == indexPath.row) {
            if (_linkTelCell) {
                return _linkTelCell;
                
            } else {
                
                KeyEditCell *cell = [KeyEditCell cellFromNib];
                _linkTelCell = cell;
                
                cell.lbKey.text = @"联系人电话";
                cell.tfValue.placeholder = @"请输入别墅联系人电话";
                
                return cell;
            }
        
        } else if (2 == indexPath.row) {
            if (_nameCell) {
                return _nameCell;
            
            } else {
                KeyEditCell *cell = [KeyEditCell cellFromNib];
                _nameCell = cell;
                
                cell.lbKey.text = @"业主";
                
                cell.tfValue.placeholder = @"输入业主姓名";
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
        } else if (3 == indexPath.row) {
            
            if (_telCell) {
                return _telCell;
                
            } else {
                KeyEditBtnCell *cell = [KeyEditBtnCell cellFromNib];
                _telCell = cell;
                
                cell.lbKey.text = @"业主手机";
                cell.tfValue.placeholder = @"请输入业主手机号码";
                cell.tfValue.keyboardType = UIKeyboardTypePhonePad;
                
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
            
        } else if (4 == indexPath.row) {
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

- (void)onChooseCell:(NSString *)cell address:(NSString *)address Lat:(CGFloat)lat lng:(CGFloat)lng
{
    _cellName = cell;
    _address = address;
    
    _lat = lat;
    _lng = lng;
    
    _addressCell.lbValue.text = [NSString stringWithFormat:@"%@%@", cell, address];
    
}

#pragma mark - PayViewControllerDelegate

- (void)clickBack
{
    
}

- (void)showEditDialog:(SelectableCell *)cell pre:(NSString *)preContent
{
    DialogEditView *dialog = [DialogEditView viewFromNib];
    
    [dialog addOnClickOkListener:^(NSString *content) {
        cell.lbContent.text = content;
        
    }];
    
    [dialog addOnClickCancelListener:^{
        cell.lbContent.text = preContent;
    }];
    
    [dialog show];
}

- (void)showWeightEditDialog:(SelectableCell *)cell pre:(NSString *)preContent
{
    DialogEditView *dialog = [DialogEditView viewFromNib];
    
    dialog.lbTitle.text = @"输入电梯的载重量";
    
    dialog.tfContent.placeholder = @"请输入电梯的载重量";
    
    dialog.tfContent.keyboardType = UIKeyboardTypeNumberPad;
    
    [dialog addOnClickOkListener:^(NSString *content) {
        cell.lbContent.text = [NSString stringWithFormat:@"%@kg", content];
        
    }];
    
    [dialog addOnClickCancelListener:^{
        cell.lbContent.text = preContent;
    }];
    
    [dialog show];
}


@end
