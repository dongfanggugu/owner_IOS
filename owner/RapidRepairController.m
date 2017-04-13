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



#define DATE_INIT @"点击选择上门日期"

@interface RapidRepairController()<UITableViewDelegate, UITableViewDataSource, DatePickerDialogDelegate>
{
    BOOL _isLogin;
}

@property (strong, nonatomic) UITableView *tableView;

@property (weak, nonatomic) UILabel *lbBrand;

@property (weak, nonatomic) UITextField *tfType;

@property (weak, nonatomic) NSString *falutType;

@property (weak, nonatomic) UITextView *tvRepair;

@property (weak, nonatomic) UITextField *tfName;

@property (weak, nonatomic) UITextField *tfTel;

@property (weak, nonatomic) UITextField *tfCode;

@property (weak, nonatomic) UITextField *tfAddress;

@property (weak, nonatomic) UILabel *lbDate;

@end

@implementation RapidRepairController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"快修服务"];
    [self initNavRightWithText:@"提交"];
    
    [self initData];
    [self initView];
}

- (void)onClickNavRight
{
    
    NSString *faultInfo = _tvRepair.text;
    
    if (0 == faultInfo.length)
    {
        [HUDClass showHUDWithLabel:@"请填写故障描述" view:self.view];
        return;
    }
    
    NSString *date = _lbDate.text;
    
    if ([date isEqualToString:DATE_INIT])
    {
        [HUDClass showHUDWithLabel:@"请选择上门日期" view:self.view];
        return;
    }
    
    RepairAddRequest *request = [[RepairAddRequest alloc] init];
    
    request.repairTypeId = _falutType;
    request.phenomenon = faultInfo;
    request.repairTime = date;
    
   
    if (!_isLogin)
    {
        
        NSString *brand = _lbBrand.text;
        
        NSString *type = _tfType.text;
        
        if (0 == type.length)
        {
            [HUDClass showHUDWithLabel:@"请填写电梯品牌" view:self.view];
            return;
        }
        
        NSString *name = _tfName.text;
        
        if (0 == name.length)
        {
            [HUDClass showHUDWithLabel:@"请填写用户姓名" view:self.view];
            return;
        }
        
        NSString *tel = _tfTel.text;
        
        if (0 == tel.length)
        {
            [HUDClass showHUDWithLabel:@"请填写用户手机号码" view:self.view];
            return;
        }
        
        NSString *code = _tfCode.text;
        
        if (0 == code.length)
        {
            [HUDClass showHUDWithLabel:@"请填写验证码" view:self.view];
            return;
        }
        
        if (![code isEqualToString:[[Config shareConfig] getSMSCode]])
        {
            [HUDClass showHUDWithLabel:@"验证码不正确，请确认验证码" view:self.view];
            return;
            
        }
        
        NSString *address = _tfAddress.text;
        
        if (0 == address.length)
        {
            [HUDClass showHUDWithLabel:@"请填写您的地址" view:self.view];
            return;
        }
        
        request.brand = brand;
        request.model = type;
        request.tel = tel;
        request.name = name;
        request.address = address;
        
    }

    [[HttpClient shareClient] view:self.view post:URL_REPAIR_ADD parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithLabel:@"快修单提交成功" view:self.view];
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
    NSString *userId = [[Config shareConfig] getUserId];
    
    _isLogin = userId.length;
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)
                                              style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}


#pragma mark - Network Request


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isLogin)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 5;
    }
    else
    {
        return 4;
    }
}

- (void)showDatePicker
{
    DatePickerDialog *dialog = [DatePickerDialog viewFromNib];
    dialog.delegate = self;
    
    [self.view addSubview:dialog];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            SelectableCell *cell = [SelectableCell cellFromNib];
            
            cell.lbKey.text = @"电梯品牌";
            
            _lbBrand = cell.lbContent;
            
            if (!_isLogin)
            {
                [[HttpClient shareClient] view:nil post:URL_LIFT_BRAND parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    BrandListResponse *response = [[BrandListResponse alloc] initWithDictionary:responseObject];
                    [cell setView:self.view data:[response getBrandList]];
                } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                    
                }];
            }
            else
            {
                cell.lbContent.text = [[Config shareConfig] getBrand];
                cell.lbContent.enabled = NO;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (1 == indexPath.row)
        {
            KeyEditCell *cell = [KeyEditCell cellFromNib];
            cell.lbKey.text = @"电梯型号";
            
            if (!_isLogin)
            {
                cell.tfValue.placeholder = @"电梯型号";
            
                _tfType = cell.tfValue;
            }
            else
            {
                cell.tfValue.text = [[Config shareConfig] getLiftType];
                cell.tfValue.enabled = NO;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (2 == indexPath.row)
        {
            SelectableCell *cell = [SelectableCell cellFromNib];
            
            cell.lbKey.text = @"电梯故障类型";
            
            [[HttpClient shareClient] view:nil post:URL_FAULT_LIST parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                FaultListResponse *response = [[FaultListResponse alloc] initWithDictionary:responseObject];
                
                if ([response getFaultList].count > 0)
                {
                    _falutType = [[response getFaultList] objectAtIndex:0].faultId;
                    
                    [cell setView:self.view data:[response getFaultList]];
                    
                    [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                        _falutType = key;
                    }];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                
            }];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (3 == indexPath.row)
        {
            KeyMultiEditCell *cell = [KeyMultiEditCell viewFromNib];
            cell.lbKey.text = @"电梯故障描述";
            cell.lbPlaceHolder.text = @"电梯故障描述";
            
            _tvRepair = cell.tvContent;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            KeyValueCell *cell = [KeyValueCell cellFromNib];
            cell.lbKey.text = @"上门日期";
            
            cell.lbValue.text = DATE_INIT;
            
            cell.lbValue.userInteractionEnabled = YES;
            
            _lbDate = cell.lbValue;
            
            [cell.lbValue addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker)]];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else if (1 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            KeyEditCell *cell = [KeyEditCell cellFromNib];
            cell.lbKey.text = @"姓名";
            
            cell.tfValue.placeholder = @"姓名";
            _tfName = cell.tfValue;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (1 == indexPath.row)
        {
            KeyEditBtnCell *cell = [KeyEditBtnCell cellFromNib];
            cell.lbKey.text = @"手机";
            cell.tfValue.placeholder = @"手机";
            _tfTel = cell.tfValue;
            
            __weak typeof(cell) weakCell = cell;
            [cell setOnClickBtnListener:^{
                
                NSString *tel = weakCell.tfValue.text;
                
                if (0 == tel.length || tel.length != 11)
                {
                    [HUDClass showHUDWithLabel:@"请输入正确的手机号码" view:self.view];
                    return;
                }
                SMSCodeRequest *request = [[SMSCodeRequest alloc] init];
                request.tel = tel;
                
                [[HttpClient shareClient] view:self.view post:URL_SMS_CODE parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
                    SMSCodeResponse *response = [[SMSCodeResponse alloc] initWithDictionary:responseObject];
                    [[Config shareConfig] setSMCode:[response getSMSCode]];
                } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                    
                }];
            }];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (2 == indexPath.row)
        {
            KeyEditCell *cell = [KeyEditCell cellFromNib];
            cell.lbKey.text = @"验证码";
            
            cell.tfValue.placeholder = @"验证码";
            _tfCode = cell.tfValue;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        else if (3 == indexPath.row)
        {
            KeyEditCell *cell = [KeyEditCell cellFromNib];
            cell.lbKey.text = @"地址";
            
            cell.tfValue.placeholder = @"地址";
            _tfAddress = cell.tfValue;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    
    return nil;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        if (3 == indexPath.row)
        {
            return [KeyMultiEditCell cellHeight];
        }
        
        return [KeyEditCell cellHeight];
    }
    else
    {
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

@end
