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
#import "DialogEditView.h"
#import "KeyValueBtnCell.h"
#import "LinkModifyController.h"
#import "ListDialogData.h"
#import "KeyImageViewCell.h"
#import "ImageUtils.h"


#define DATE_INIT @"点击选择上门日期"

#define IMAGE_PATH @"/tmp/person/"

#define IMAGE_TEMP @"rapid_repair.jpg"

@interface RapidRepairController () <UITableViewDelegate, UITableViewDataSource, DatePickerDialogDelegate, AddressLocationControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (strong, nonatomic) UITableView *tableView;

@property (weak, nonatomic) UITextField *tfType;

@property (weak, nonatomic) NSString *falutType;

@property (weak, nonatomic) UITextField *tfCode;

@property (weak, nonatomic) SelectableCell *brandCell;

@property (weak, nonatomic) SelectableCell *weightCell;

@property (weak, nonatomic) SelectableCell *layerCell;

@property (weak, nonatomic) SelectableCell *faultCell;

@property (weak, nonatomic) KeyMultiEditCell *desCell;

@property (weak, nonatomic) KeyValueCell *dateCell;

@property (weak, nonatomic) KeyImageViewCell *imageCell;

@property (weak, nonatomic) KeyEditCell *nameCell;

@property (weak, nonatomic) KeyEditBtnCell *telCell;

@property (weak, nonatomic) KeyValueCell *addressCell;

@property (weak, nonatomic) KeyEditCell *linkNameCell;

@property (weak, nonatomic) KeyEditCell *linkTelCell;

@property (copy, nonatomic) NSString *cellName;

@property (copy, nonatomic) NSString *address;

@property (assign, nonatomic) CGFloat lat;

@property (assign, nonatomic) CGFloat lng;

@property (copy, nonatomic) NSString *url;

@end

@implementation RapidRepairController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"快修服务"];
    [self initNavRightWithText:@"联系我们"];
    [self initView];
}

- (void)onClickNavRight
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", Custom_Service]];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [webView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:webView];
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

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:_tableView];

    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 80)];


    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, self.screenWidth - 32, 50)];

    label.font = [UIFont systemFontOfSize:14];

    label.textAlignment = NSTextAlignmentCenter;

    label.text = @"您需要登录之后才能使用平台快修服务!";

    [footView addSubview:label];

    _tableView.tableFooterView = footView;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (void)showDatePicker
{
    DatePickerDialog *dialog = [DatePickerDialog viewFromNib];
    dialog.delegate = self;

    [dialog show];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (0 == indexPath.row)
        {

            if (_brandCell)
            {
                return _brandCell;

            }
            else
            {
                SelectableCell *cell = [SelectableCell cellFromNib];
                _brandCell = cell;

                cell.lbKey.text = @"电梯品牌";

                __weak typeof(cell) weakCell = cell;

                __weak typeof(self) weakSelf = self;

                [[HttpClient shareClient] post:URL_LIFT_BRAND parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    BrandListResponse *response = [[BrandListResponse alloc] initWithDictionary:responseObject];
                    [weakCell setData:[response getBrandList]];

                    [weakCell setBeforeSelectedListener:^(NSString *preConent, NSString *content) {
                        if ([content isEqualToString:@"其他"])
                        {
                            [weakSelf showEditDialog:weakCell pre:preConent];
                        }
                    }];
                }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

                }];


                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;

            }

        }
        else if (1 == indexPath.row)
        {
            if (_weightCell)
            {
                return _weightCell;

            }
            else
            {

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
                    if ([content isEqualToString:@"其他"])
                    {
                        [weakSelf showWeightEditDialog:weakCell pre:preContent];
                    }
                }];


                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }

        }
        else if (2 == indexPath.row)
        {
            if (_layerCell)
            {
                return _layerCell;

            }
            else
            {
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
        else if (3 == indexPath.row)
        {
            if (_faultCell)
            {
                return _faultCell;

            }
            else
            {
                SelectableCell *cell = [SelectableCell cellFromNib];

                _faultCell = cell;

                cell.lbKey.text = @"电梯故障类型";

                __weak typeof(self) weakSelf = self;

                __weak typeof(cell) weakCell = cell;

                [[HttpClient shareClient] post:URL_FAULT_LIST parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    FaultListResponse *response = [[FaultListResponse alloc] initWithDictionary:responseObject];

                    if ([response getFaultList].count > 0)
                    {
                        weakSelf.falutType = [[response getFaultList] objectAtIndex:0].faultId;

                        [weakCell setData:[response getFaultList]];

                        [weakCell setAfterSelectedListener:^(NSString *key, NSString *content) {
                            weakSelf.falutType = key;
                        }];
                    }
                }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

                }];

                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }

        }
        else if (4 == indexPath.row)
        {
            if (_desCell)
            {
                return _desCell;

            }
            else
            {
                KeyMultiEditCell *cell = [KeyMultiEditCell viewFromNib];
                _desCell = cell;

                cell.lbKey.text = @"电梯故障描述";
                cell.lbPlaceHolder.text = @"电梯故障描述";

                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }

        }
        else if (5 == indexPath.row)
        {
            if (_dateCell)
            {
                return _dateCell;

            }
            else
            {
                KeyValueCell *cell = [KeyValueCell cellFromNib];
                _dateCell = cell;
                cell.lbKey.text = @"上门日期";

                cell.lbValue.text = DATE_INIT;

                cell.lbValue.userInteractionEnabled = YES;

                [cell.lbValue addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker)]];

                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;

            }

        }
        else if (6 == indexPath.row)
        {

            if (_imageCell)
            {
                return _imageCell;

            }
            else
            {
                KeyImageViewCell *cell = [KeyImageViewCell cellFromNib];

                _imageCell = cell;

                __weak typeof(cell) weakCell = cell;
                __weak typeof(self) weakSelf = self;

                [cell setOnClickImageListener:^{
                    if (weakCell.hasImage)
                    {
                        return;
                    }
                    [weakSelf showPicker];

                }];

                [cell setOnClickBtnListener:^{
                    if (!weakCell.hasImage)
                    {
                        return;
                    }

                    [weakCell delPhoto];

                    [weakSelf delRepairImage];
                }];

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

        if (4 == indexPath.row)
        {
            return [KeyMultiEditCell cellHeight];

        }
        else if (6 == indexPath.row)
        {
            return [KeyImageViewCell cellHeight];

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
        label.text = @"业主信息";
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
    _dateCell.lbValue.text = dateStr;
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

- (void)showPicker
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    [controller addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [self pickPhoto];
    }]];

    [controller addAction:[UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [self takePhoto];
    }]];

    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {

    }]];

    [self presentViewController:controller animated:YES completion:nil];

}

/**
 *  从本地选取照片
 */
- (void)pickPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];

    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;

    //设置选择后的图片可以编辑
    picker.allowsEditing = YES;

    [self showViewController:picker sender:self];
}

/**
 *  拍摄照片
 */
- (void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;

        //设置拍照后的图片可以编辑
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self showViewController:picker sender:self];
    }
}

/**
 *  当选择一张图片后调用此方法
 *
 *  @param picker picker
 *  @param info info
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info
{

    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];

    //选择的是图片
    if ([type isEqualToString:@"public.image"])
    {

        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

        CGSize size = CGSizeMake(90, 120);

        image = [ImageUtils imageWithImage:image scaledToSize:size];

        _imageCell.imageView.image = image;

        //上传到服务器
        //[self uploadRepairImage:image];

        //将图片转换为 NSData
//        NSData *data;
//
//        data = UIImageJPEGRepresentation(image, 0.5);
//
//        //将图片保存为rapid_repair.jpg
//        NSString *dirPath = [NSHomeDirectory() stringByAppendingString:IMAGE_PATH];
//
//        BOOL suc = [FileUtils writeFile:data Path:dirPath fileName:IMAGE_TEMP];
//
//        if (suc)
//        {
//            NSLog(@"照片保存成功");
//
//        }
//        else
//        {
//            NSLog(@"照片保存失败");
//        }

        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


/**
 *  取消图片选择时调用
 *
 *  @param picker picker
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)delRepairImage
{
    NSString *path = [NSString stringWithFormat:@"%@%@", IMAGE_PATH, IMAGE_TEMP];
    NSString *dirPath = [NSHomeDirectory() stringByAppendingString:path];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:dirPath];

    if (exist)
    {
        NSError *error;
        BOOL suc = [fileManager removeItemAtPath:dirPath error:&error];

        NSLog(@"error:%@", error);

        if (suc)
        {
            NSLog(@"del successfully");
        }
        else
        {
            NSLog(@"del failed");
        }
    }
    else
    {
        NSLog(@"image does not exist");
    }
}

- (void)uploadRepairImage:(UIImage *)image
{
    NSString *imageStr = [Utils image2Base64From:image];

    if (0 == imageStr.length)
    {
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"img"] = imageStr;

    [[HttpClient shareClient] post:@"uploadImg" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        self.url = responseObject[@"body"][@"url"];

        CGSize thumSize = CGSizeMake(90, 120);

        _imageCell.photo = [ImageUtils imageWithImage:image scaledToSize:thumSize];

    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}


- (void)dealloc
{
    [self delRepairImage];
}

@end
