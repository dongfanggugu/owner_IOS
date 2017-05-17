//
//  RapidRepairController.m
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RapidRepairController.h"
#import "KeyEditCell.h"
#import "KeyMultiEditCell.h"
#import "KeyEditBtnCell.h"
#import "SelectableCell.h"
#import "KeyValueCell.h"
#import "FaultListResponse.h"
#import "BrandListResponse.h"
#import "SMSCodeRequest.h"
#import "SMSCodeResponse.h"
#import "DatePickerDialog.h"
#import "RepairAddRequest.h"
#import "AddressLocationController.h"



#define DATE_INIT @"点击选择上门日期"

@interface RapidRepairController()<UITableViewDelegate, UITableViewDataSource, DatePickerDialogDelegate, AddressLocationControllerDelegate>


@property (strong, nonatomic) UITableView *tableView;

@property (weak, nonatomic) UILabel *lbBrand;

@property (weak, nonatomic) UITextField *tfType;

@property (weak, nonatomic) NSString *falutType;

@property (weak, nonatomic) UITextView *tvRepair;

@property (weak, nonatomic) UITextField *tfName;

@property (weak, nonatomic) UITextField *tfTel;

@property (weak, nonatomic) UITextField *tfCode;

@property (weak, nonatomic) UILabel *lbDate;

@property (weak, nonatomic) SelectableCell *brandCell;

@property (weak, nonatomic) KeyEditCell *modelCell;

@property (weak, nonatomic) SelectableCell *faultCell;

@property (weak, nonatomic) KeyMultiEditCell *desCell;

@property (weak, nonatomic) KeyValueCell *dateCell;

@property (weak, nonatomic) KeyValueCell *addressCell;

@property (assign, nonatomic) CGFloat lat;

@property (assign, nonatomic) CGFloat lng;

@end

@implementation RapidRepairController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"快修服务"];
    [self initData];
    [self initView];
}

- (void)submit
{
    
    NSString *faultInfo = _tvRepair.text;
    
    if (0 == faultInfo.length) {
        [HUDClass showHUDWithText:@"请填写故障描述"];
        return;
    }
    
    NSString *date = _lbDate.text;
    
    if ([date isEqualToString:DATE_INIT]) {
        [HUDClass showHUDWithText:@"请选择上门日期"];
        return;
    }
    
    RepairAddRequest *request = [[RepairAddRequest alloc] init];
    
    request.repairTypeId = _falutType;
    request.phenomenon = faultInfo;
    request.repairTime = date;
    
   
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
        request.tel = tel;
        request.name = name;
        request.address = address;
        request.lat = _lat;
        request.lng = _lng;
        
    }

    [[HttpClient shareClient] post:URL_REPAIR_ADD parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithText:@"快修单提交成功"];
        [self performSelector:@selector(back) withObject:nil afterDelay:1.0f];
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
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 80)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    
    btn.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    
    btn.center = CGPointMake(self.screenWidth / 2, 40);
    [footView addSubview:btn];
    
    _tableView.tableFooterView = footView;

}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.login) {
        return 1;
        
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return 5;
        
    } else {
        return 4;
    }
}

- (void)showDatePicker
{
    DatePickerDialog *dialog = [DatePickerDialog viewFromNib];
    dialog.delegate = self;
    
    [dialog show];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
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
            
        } else if (1 == indexPath.row) {
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
            
        } else if (2 == indexPath.row) {
            if (_faultCell) {
                return _faultCell;
            
            } else {
                SelectableCell *cell = [SelectableCell cellFromNib];
                
                _faultCell = cell;
                
                cell.lbKey.text = @"电梯故障类型";
                
                __weak typeof (self) weakSelf = self;
                
                [[HttpClient shareClient] post:URL_FAULT_LIST parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    FaultListResponse *response = [[FaultListResponse alloc] initWithDictionary:responseObject];
                    
                    if ([response getFaultList].count > 0) {
                        _falutType = [[response getFaultList] objectAtIndex:0].faultId;
                        
                        [cell setData:[response getFaultList]];
                        
                        [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                            weakSelf.falutType = key;
                        }];
                    }
                } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                    
                }];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
        } else if (3 == indexPath.row) {
            if (_desCell) {
                return _desCell;
            
            } else {
                KeyMultiEditCell *cell = [KeyMultiEditCell viewFromNib];
                _desCell = cell;
                
                cell.lbKey.text = @"电梯故障描述";
                cell.lbPlaceHolder.text = @"电梯故障描述";
                
                _tvRepair = cell.tvContent;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
        } else if (4 == indexPath.row) {
            if (_dateCell) {
                return _dateCell;
            
            } else {
                KeyValueCell *cell = [KeyValueCell cellFromNib];
                _dateCell = cell;
                cell.lbKey.text = @"上门日期";
                
                cell.lbValue.text = DATE_INIT;
                
                cell.lbValue.userInteractionEnabled = YES;
                
                _lbDate = cell.lbValue;
                
                [cell.lbValue addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker)]];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;

            }
        }
    } else if (1 == indexPath.section) {
        if (0 == indexPath.row) {
            KeyEditCell *cell = [KeyEditCell cellFromNib];
            cell.lbKey.text = @"姓名";
            
            cell.tfValue.placeholder = @"姓名";
            _tfName = cell.tfValue;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (1 == indexPath.row) {
            KeyEditBtnCell *cell = [KeyEditBtnCell cellFromNib];
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
            
        } else if (2 == indexPath.row) {
            KeyEditCell *cell = [KeyEditCell cellFromNib];
            cell.lbKey.text = @"验证码";
            
            cell.tfValue.placeholder = @"验证码";
            _tfCode = cell.tfValue;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        } else if (3 == indexPath.row) {
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
    
    return nil;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        
        if (3 == indexPath.row) {
            return [KeyMultiEditCell cellHeight];
        }
        
        return [KeyEditCell cellHeight];
        
    } else {
        return [KeyEditCell cellHeight];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
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
    
    if (0 == section)
    {
        label.text = @"订单信息";
        return view;
    }
    else if (1 == section)
    {
        label.text = @"电梯信息";
        return view;
    }
    else
    {
        label.text = @"业主信息";
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


#pragma mark - DatePickerDelegate

- (void)onPickerDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [format stringFromDate:date];
    _lbDate.text = dateStr;
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



@end
