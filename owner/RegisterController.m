//
//  RegisterController.m
//  owner
//
//  Created by 长浩 张 on 17/1/8.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegisterController.h"
#import "SelectableCell.h"
#import "BrandListResponse.h"
#import "AddressLocationController.h"
#import "KeyValueCell.h"
#import "DialogEditView.h"
#import "ListDialogData.h"

#pragma mark - RegisterCell

@interface RegisterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbKey;

@property (weak, nonatomic) IBOutlet UITextField *tfValue;

@property (weak, nonatomic) IBOutlet UIButton *btnLocation;


@end


@implementation RegisterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _btnLocation.hidden = YES;
}

@end

#pragma mark - RegisterController

@interface RegisterController () <UITableViewDelegate, UITableViewDataSource, AddressLocationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet KeyValueCell *addressCell;

@property (copy, nonatomic) NSString *cellName;

@property (copy, nonatomic) NSString *address;

@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"注册"];
    [self initView];
}


- (void)initView {
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setAllowsSelection:NO];

    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 80)];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];

    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;

    btn.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(ownerRegister) forControlEvents:UIControlEventTouchUpInside];

    btn.center = CGPointMake(self.screenWidth / 2, 40);
    [footView addSubview:btn];

    _tableView.tableFooterView = footView;
}


#pragma mark - NetworkRequest

- (void)ownerRegister {
    RegisterCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *name = cell1.tfValue.text;

    if (0 == name.length) {
        [HUDClass showHUDWithText:@"请填写用户姓名"];
        return;
    }

    RegisterCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *tel = cell2.tfValue.text;

    if (0 == tel.length) {
        [HUDClass showHUDWithText:@"请填写用户联系方式"];
        return;
    }

    RegisterCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *pwd = cell3.tfValue.text;

    if (0 == pwd.length) {
        [HUDClass showHUDWithText:@"请填写密码"];
        return;
    }


    RegisterCell *cell4 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *pwdConfirm = cell4.tfValue.text;

    if (![pwd isEqualToString:pwdConfirm]) {
        [HUDClass showHUDWithText:@"确认密码和密码不一致"];
        return;
    }

    SelectableCell *cell5 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    NSString *brand = cell5.getContentValue;

    if (0 == brand.length) {
        [HUDClass showHUDWithText:@"请选择电梯品牌"];
        return;
    }

    SelectableCell *cell6 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];

    NSString *weight = [Utils string:cell6.getContentValue substringBeforeChar:@"k"];

    if (0 == weight.length) {
        [HUDClass showHUDWithText:@"请选择电梯载重量"];
        return;
    }

    SelectableCell *cell7 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    NSString *layer = [Utils string:cell7.getContentValue substringBeforeChar:@"层"];

    NSString *address = _addressCell.lbValue.text;

    if (0 == address.length || [address isEqualToString:@"点击选择别墅地址"]) {
        [HUDClass showHUDWithText:@"请选择别墅地址"];
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = name;
    params[@"tel"] = tel;
    params[@"sex"] = @"1";
    params[@"password"] = [Utils md5:pwd];
    params[@"brand"] = brand;
    params[@"address"] = _address;

    params[@"cellName"] = _cellName;

    params[@"lng"] = [NSNumber numberWithFloat:_lng];
    params[@"lat"] = [NSNumber numberWithFloat:_lat];
    params[@"weight"] = [NSNumber numberWithInteger:weight.integerValue];
    params[@"layerAmount"] = [NSNumber numberWithInteger:layer.integerValue];


    [[HttpClient shareClient] post:@"addSmallOwner" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithText:@"注册成功,请使用您的手机号码登录"];
        [self.navigationController popViewControllerAnimated:YES];
    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}

#pragma mark - UITabelViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;

    if (0 == index) {
        RegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"register_cell"];

        cell.lbKey.text = @"姓名";
        cell.tfValue.placeholder = @"姓名";

        return cell;

    } else if (1 == index) {
        RegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"register_cell"];

        cell.lbKey.text = @"电话";
        cell.tfValue.placeholder = @"电话";

        return cell;

    } else if (2 == index) {
        RegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"register_cell"];

        cell.lbKey.text = @"密码";
        cell.tfValue.placeholder = @"密码";

        cell.tfValue.secureTextEntry = YES;

        return cell;

    } else if (3 == index) {

        RegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"register_cell"];

        cell.lbKey.text = @"确认密码";
        cell.tfValue.placeholder = @"确认密码";

        cell.tfValue.secureTextEntry = YES;

        return cell;

    } else if (4 == index) {
        SelectableCell *cell = [SelectableCell cellFromNib];

        cell.lbKey.text = @"电梯品牌";

        __weak typeof(cell) weakCell = cell;

        __weak typeof(self) weakSelf = self;

        [[HttpClient shareClient] post:URL_LIFT_BRAND parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            BrandListResponse *response = [[BrandListResponse alloc] initWithDictionary:responseObject];
            [weakCell setData:[response getBrandList]];

            [weakCell setAfterSelectedListener:^(NSString *key, NSString *content) {
                if ([content isEqualToString:@"其他"]) {
                    [weakSelf showBrandEditDialog:weakCell];
                }
            }];
        }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

        }];


        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    } else if (5 == indexPath.row) {
        SelectableCell *cell = [SelectableCell cellFromNib];

        cell.lbKey.text = @"载重量";


        __weak typeof(self) weakSelf = self;
        __weak typeof(cell) weakCell = cell;

        ListDialogData *data1 = [[ListDialogData alloc] initWithKey:nil content:@"240kg"];

        ListDialogData *data2 = [[ListDialogData alloc] initWithKey:nil content:@"320kg"];

        ListDialogData *data3 = [[ListDialogData alloc] initWithKey:nil content:@"480kg"];

        ListDialogData *data4 = [[ListDialogData alloc] initWithKey:nil content:@"640kg"];

        ListDialogData *data5 = [[ListDialogData alloc] initWithKey:nil content:@"其他"];

        NSArray *array = [[NSArray alloc] initWithObjects:data1, data2, data3, data4, data5, nil];

        [cell setData:array];

        [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
            if ([content isEqualToString:@"其他"]) {
                [weakSelf showWeightEditDialog:weakCell];
            }
        }];


        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    } else if (6 == indexPath.row) {
        SelectableCell *cell = [SelectableCell cellFromNib];

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

    } else if (7 == index) {

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

- (void)addressLocation {
    AddressLocationController *controller = [[AddressLocationController alloc] init];
    controller.delegate = self;

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - LocationControllerDelegate

- (void)onChooseCell:(NSString *)cell address:(NSString *)address Lat:(CGFloat)lat lng:(CGFloat)lng {
    _cellName = cell;
    _address = address;

    _lat = lat;
    _lng = lng;

    _addressCell.lbValue.text = [NSString stringWithFormat:@"%@%@", cell, address];

}

- (void)showWeightEditDialog:(SelectableCell *)cell {
    DialogEditView *dialog = [DialogEditView viewFromNib];

    dialog.lbTitle.text = @"输入电梯的载重量";

    dialog.tfContent.placeholder = @"请输入电梯的载重量";

    dialog.tfContent.keyboardType = UIKeyboardTypeNumberPad;

    [dialog addOnClickOkListener:^(NSString *content) {
        cell.lbContent.text = [NSString stringWithFormat:@"%@kg", content];

    }];

    [dialog addOnClickCancelListener:^{
        cell.lbContent.text = @"";
    }];

    [dialog show];
}

- (void)showBrandEditDialog:(SelectableCell *)cell {
    DialogEditView *dialog = [DialogEditView viewFromNib];


    dialog.tfContent.keyboardType = UIKeyboardTypeNumberPad;

    [dialog addOnClickOkListener:^(NSString *content) {
        cell.lbContent.text = content;

    }];

    [dialog addOnClickCancelListener:^{
        cell.lbContent.text = @"";
    }];

    [dialog show];
}

@end
