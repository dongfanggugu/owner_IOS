//
//  ExtraOrderAddController.m
//  owner
//
//  Created by 长浩 张 on 2017/5/5.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "ExtraOrderAddController.h"
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
#import "ListDialogData.h"
#import "ListDialogView.h"


@interface ExtraOrderAddController () <UITableViewDelegate, UITableViewDataSource, PayViewControllerDelegate, ListDialogViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (weak, nonatomic) OrderAmountCell *amountCell;

@property (weak, nonatomic) SelectableCell *brandCell;

@property (weak, nonatomic) KeyValueBtnCell *addressCell;

@property (strong, nonatomic) NSDictionary *houseInfo;

@property (strong, nonatomic) NSMutableArray *arrayHouse;

@end

@implementation ExtraOrderAddController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"服务订单"];
    [self initNavRightWithText:@"联系我们"];
    [self initView];
    [self getHouses];
}

- (void)onClickNavRight
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",Custom_Service]];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [webView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:webView];
}

- (NSMutableArray *)arrayHouse
{
    if (!_arrayHouse) {
        _arrayHouse = [NSMutableArray array];
    }
    
    return _arrayHouse;
}

- (void)submit
{
    MainOrderAddRequest *request = [[MainOrderAddRequest alloc] init];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"incrementTypeId"] = _serviceInfo.typeId;
    params[@"frequency"] = [NSNumber numberWithInteger:_amountCell.amount];
    params[@"villaId"] = _houseInfo[@"id"];

    
    
    [[HttpClient shareClient] post:URL_EXTRA_ADD parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
            
            cell.lbName.text = [NSString stringWithFormat:@"%@ ￥%.2lf", _serviceInfo.name, _serviceInfo.price];
            cell.lbContent.text = _serviceInfo.content;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (1 == indexPath.row) {
            
            if (_amountCell) {
                return _amountCell;
            }
            
            OrderAmountCell *cell = [OrderAmountCell cellFromNib];
            _amountCell = cell;
            
            cell.price = _serviceInfo.price;
            
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
            KeyValueBtnCell *cell =  [KeyValueBtnCell cellFromNib];
            
            _addressCell = cell;
            
            cell.lbKey.text = @"别墅地址";
            cell.lbValue.text = _houseInfo[@"cellName"];
            cell.btnTitle = @"切换";
            
            if (1 == self.arrayHouse.count) {
                [cell hideBtn];
            }
            
            __weak typeof (self) weakSelf = self;
            [cell addOnClickListener:^{
                [weakSelf showHouselist];
            }];
            
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
        
        controller.detail = self.serviceInfo.content;
        
        controller.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
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
        [self showHouselist];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)showHouselist
{
    if (0 == self.arrayHouse.count) {
        return;
    }
    
    if (1 == self.arrayHouse.count) {
        
        _houseInfo = self.arrayHouse[0];
        
        [_tableView reloadData];
        
        return;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *info in self.arrayHouse) {
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
    for (NSDictionary *info in self.arrayHouse) {
        if ([key isEqualToString:info[@"id"]]) {
            
            _houseInfo = info;
            
            [_tableView reloadData];
            break;
        }
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
