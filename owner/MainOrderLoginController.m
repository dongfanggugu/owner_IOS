//
//  MainOrderLoginController.m
//  owner
//
//  Created by 长浩 张 on 2017/5/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "MainOrderLoginController.h"
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
#import "MainTypeInfo.h"

@interface MainOrderLoginController () <UITableViewDelegate, UITableViewDataSource, PayViewControllerDelegate>

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

@implementation MainOrderLoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"服务订单"];
    [self initNavRightWithText:@"联系我们"];
    [self initData];
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
    request.villaId = _houseInfo[@"id"];
    
    
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
    
    [_tableView showCopyWrite];
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
        return 5;
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
            
            KeyValueCell *cell = [KeyValueCell cellFromNib];
            cell.lbKey.text = @"电梯品牌";
            cell.lbValue.text = _houseInfo[@"brand"];
            
            return cell;
            
        } else if (1 == indexPath.row) {
            KeyValueCell *cell = [KeyValueCell cellFromNib];
            cell.lbKey.text = @"载重量";
            cell.lbValue.text = [NSString stringWithFormat:@"%@kg", _houseInfo[@"weight"]];
            
            return cell;
            
        } else if (2 == indexPath.row) {
            KeyValueCell *cell = [KeyValueCell cellFromNib];
            cell.lbKey.text = @"电梯层站";
            cell.lbValue.text = [NSString stringWithFormat:@"%@层", _houseInfo[@"layerAmount"]];
            
            return cell;
        }
        
    } else if (2 == indexPath.section) {
        
        if (0 == indexPath.row) {
            
            KeyValueCell *cell = [KeyValueCell cellFromNib];
            cell.lbKey.text = @"联系人";
            cell.lbValue.text = _houseInfo[@"contacts"];
            
            return cell;
            
        } else if (1 == indexPath.row) {
            
            KeyValueCell *cell = [KeyValueCell cellFromNib];
            cell.lbKey.text = @"联系人手机";
            cell.lbValue.text = _houseInfo[@"contactsTel"];
            
            return cell;
            
        } else if (2 == indexPath.row) {
            KeyValueCell *cell = [KeyValueCell cellFromNib];
            cell.lbKey.text = @"业主";
            cell.lbValue.text = [[Config shareConfig] getName];
            
            return cell;
            
        } else if (3 == indexPath.row) {
            
            KeyValueCell *cell = [KeyValueCell cellFromNib];
            cell.lbKey.text = @"业主手机";
            cell.lbValue.text = [[Config shareConfig] getTel];
            return cell;
            
        } else if (4 == indexPath.row) {
            KeyValueCell *cell = [KeyValueCell cellFromNib];
            cell.lbKey.text = @"别墅地址";
            cell.lbValue.text = [NSString stringWithFormat:@"%@%@", _houseInfo[@"cellName"], _houseInfo[@"address"]];
            return cell;
            
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

@end
