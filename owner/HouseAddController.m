//
//  HouseAddController.m
//  owner
//
//  Created by 长浩 张 on 2017/5/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "HouseAddController.h"
#import "KeyEditCell.h"
#import "SelectableCell.h"
#import "BrandListResponse.h"
#import "ListDialogData.h"
#import "KeyValueCell.h"
#import "AddressLocationController.h"
#import "DialogEditView.h"

@interface HouseAddController () <UITableViewDelegate, UITableViewDataSource, AddressLocationControllerDelegate>

@property (weak, nonatomic) KeyEditCell *nameCell;

@property (weak, nonatomic) KeyEditCell *telCell;

@property (weak, nonatomic) SelectableCell *brandCell;

@property (weak, nonatomic) SelectableCell *weightCell;

@property (weak, nonatomic) SelectableCell *layerCell;

@property (weak, nonatomic) KeyValueCell *addressCell;

@property (copy, nonatomic) NSString *cellName;

@property (copy, nonatomic) NSString *address;

@property (assign, nonatomic) CGFloat lat;

@property (assign, nonatomic) CGFloat lng;

@end

@implementation HouseAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"别墅添加"];
    [self initView];
}

- (void)initView {
    self.automaticallyAdjustsScrollViewInsets = NO;

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64 - 60)];

    tableView.delegate = self;

    tableView.dataSource = self;

    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [tableView showCopyWrite];

    [self.view addSubview:tableView];

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

    tableView.tableFooterView = footView;
}

- (void)submit {
    NSString *name = _nameCell.tfValue.text;

    if (0 == name.length) {
        [HUDClass showHUDWithText:@"请先填写别墅联系人姓名"];
        return;
    }

    NSString *tel = _telCell.tfValue.text;

    if (0 == tel.length) {
        [HUDClass showHUDWithText:@"请先填写别墅联系人手机"];
        return;
    }

    NSString *brand = _brandCell.getContentValue;

    if (0 == brand.length) {
        [HUDClass showHUDWithText:@"请先选择别墅电梯品牌"];
        return;
    }

    NSString *weight = [Utils string:_weightCell.getContentValue substringBeforeChar:@"k"];;

    if (0 == weight.length) {
        [HUDClass showHUDWithText:@"请先选择别墅电梯载重量"];
        return;
    }

    NSString *layer = [Utils string:_layerCell.getContentValue substringBeforeChar:@"层"];

    NSString *address = _addressCell.lbValue.text;

    if (0 == address.length || [address isEqualToString:@"点击选择别墅地址"]) {
        [HUDClass showHUDWithText:@"请选择别墅地址"];
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"contacts"] = name;
    params[@"contactsTel"] = tel;
    params[@"brand"] = brand;
    params[@"weight"] = [NSNumber numberWithInteger:weight.integerValue];
    params[@"layerAmount"] = [NSNumber numberWithInteger:layer.integerValue];
    params[@"cellName"] = _cellName;
    params[@"address"] = _address;
    params[@"lng"] = [NSNumber numberWithFloat:_lng];
    params[@"lat"] = [NSNumber numberWithFloat:_lat];

    [[HttpClient shareClient] post:@"addVilla" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithText:@"别墅添加成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];

}

#pragma mark - UITabelViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;

    if (0 == index) {

        if (_nameCell) {
            return _nameCell;

        } else {
            KeyEditCell *cell = [KeyEditCell cellFromNib];

            _nameCell = cell;

            cell.lbKey.text = @"联系人";
            cell.tfValue.placeholder = @"输入别墅联系姓名";

            return cell;
        }

    } else if (1 == index) {
        if (_telCell) {
            return _telCell;

        } else {
            KeyEditCell *cell = [KeyEditCell cellFromNib];
            _telCell = cell;

            cell.lbKey.text = @"联系人手机";
            cell.tfValue.placeholder = @"输入别墅联系人手机";

            return cell;
        }

    } else if (2 == index) {
        SelectableCell *cell = [SelectableCell cellFromNib];

        _brandCell = cell;

        cell.lbKey.text = @"电梯品牌";

        __weak typeof(cell) weakCell = cell;

        __weak typeof(self) weakSelf = self;

        [[HttpClient shareClient] post:URL_LIFT_BRAND parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            BrandListResponse *response = [[BrandListResponse alloc] initWithDictionary:responseObject];
            [weakCell setData:[response getBrandList]];

            [weakCell setAfterSelectedListener:^(NSString *key, NSString *content) {
                if ([content isEqualToString:@"其他"]) {
                    [weakSelf showBrandEditDialog:weakCell preContent:content];
                }
            }];
        }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

        }];


        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    } else if (3 == indexPath.row) {
        SelectableCell *cell = [SelectableCell cellFromNib];

        _weightCell = cell;

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

        [cell setBeforeSelectedListener:^(NSString *preContent, NSString *content) {
            if ([content isEqualToString:@"其他"]) {
                [weakSelf showWeightEditDialog:weakCell preContent:preContent];
            }
        }];


        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    } else if (4 == indexPath.row) {
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

    } else if (5 == index) {

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

- (void)onChooseAddress:(NSString *)address Lat:(CGFloat)lat lng:(CGFloat)lng {
    _addressCell.lbValue.text = address;
    _lat = lat;
    _lng = lng;
}

- (void)onChooseCell:(NSString *)cell address:(NSString *)address Lat:(CGFloat)lat lng:(CGFloat)lng {
    _cellName = cell;
    _address = address;

    _lat = lat;
    _lng = lng;

    _addressCell.lbValue.text = [NSString stringWithFormat:@"%@%@", cell, address];

}

- (void)showWeightEditDialog:(SelectableCell *)cell preContent:(NSString *)preContent {
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

- (void)showBrandEditDialog:(SelectableCell *)cell preContent:(NSString *)preContent {
    DialogEditView *dialog = [DialogEditView viewFromNib];


    dialog.tfContent.keyboardType = UIKeyboardTypeNumberPad;

    [dialog addOnClickOkListener:^(NSString *content) {
        cell.lbContent.text = content;

    }];

    [dialog addOnClickCancelListener:^{
        cell.lbContent.text = preContent;
    }];

    [dialog show];
}


@end
