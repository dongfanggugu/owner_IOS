//
//  RapidRepairLoginController.m
//  owner
//
//  Created by 长浩 张 on 2017/5/24.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "RapidRepairLoginController.h"
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
#import "DialogEditView.h"
#import "KeyValueBtnCell.h"
#import "ListDialogData.h"
#import "KeyImageViewCell.h"
#import "ImageUtils.h"
#import "RepairOrderConfirmController.h"
#import "MainListResponse.h"
#import "RepairOrderConfirmNoPayController.h"


#define IMAGE_PATH @"/tmp/person/"

#define IMAGE_TEMP @"rapid_repair.jpg"

#define DATE_INIT @"点击选择上门日期"

@interface RapidRepairLoginController () <UITableViewDelegate, UITableViewDataSource, DatePickerDialogDelegate, ListDialogViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (strong, nonatomic) UITableView *tableView;

@property (copy, nonatomic) NSString *falutType;

@property (weak, nonatomic) SelectableCell *faultCell;

@property (weak, nonatomic) KeyMultiEditCell *desCell;

@property (weak, nonatomic) KeyImageViewCell *imageCell;

@property (weak, nonatomic) KeyValueCell *dateCell;

@property (strong, nonatomic) NSDictionary *houseInfo;

@property (strong, nonatomic) NSMutableArray *arrayHouse;

@property (copy, nonatomic) NSString *url;

@end

@implementation RapidRepairLoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"快修服务"];
    [self initNavRightWithText:@"联系我们"];
    [self initView];
    [self getHouses];
}

- (void)onClickNavRight
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", Custom_Service]];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [webView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:webView];
}

- (void)submit
{
    if (!_houseInfo)
    {
        [HUDClass showHUDWithText:@"请先选择您的别墅"];
        return;
    }

    NSString *faultInfo = _desCell.tvContent.text;

    if (0 == faultInfo.length)
    {
        [HUDClass showHUDWithText:@"请填写故障描述"];
        return;
    }

    if (0 == _url.length)
    {
        [HUDClass showHUDWithText:@"请先上传故障照片"];
        return;
    }

    NSString *date = _dateCell.lbValue.text;

    if ([date isEqualToString:DATE_INIT])
    {
        [HUDClass showHUDWithText:@"请选择上门日期"];
        return;
    }

    RepairAddRequest *request = [[RepairAddRequest alloc] init];

    request.repairTypeId = _falutType;
    request.phenomenon = faultInfo;
    request.url = _url;
    request.repairTime = date;
    request.villaId = _houseInfo[@"id"];
    [self getServiceInfo:request];
}

- (void)getServiceInfo:(RepairAddRequest *)request
{
    if (0 == request.villaId.length)
    {
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"villaId"] = request.villaId;

    [[HttpClient shareClient] post:URL_MAIN_LIST parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        MainListResponse *response = [[MainListResponse alloc] initWithDictionary:responseObject];

        NSArray *array = responseObject[@"body"];

        if (0 == array.count)
        {
            [self jumpPay:request];
            return;
        }

        NSDictionary *maintInfo = array[0];
        NSInteger type = maintInfo[@"mainttypeId"];

        if (type > Maint_Mid)
        {
            [self jumpPay:request];
        }
        else
        {
            //需要判断是否过期
//            [self jumpNoPay:request service:maintInfo];
            [self jumpPay:request];
        }


    } failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}

- (void)jumpPay:(RepairAddRequest *)request
{
    RepairOrderConfirmController *controller = [[RepairOrderConfirmController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.request = request;

    [self.navigationController pushViewController:controller animated:YES];

}

- (void)jumpNoPay:(RepairAddRequest *)request service:(NSDictionary *)serviceInfo
{
    RepairOrderConfirmNoPayController *controller = [[RepairOrderConfirmNoPayController alloc] init];

    controller.request = request;
    controller.serviceInfo = serviceInfo;

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSMutableArray *)arrayHouse
{
    if (!_arrayHouse)
    {
        _arrayHouse = [NSMutableArray array];
    }

    return _arrayHouse;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 7;

    }
    else
    {
        return 5;
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
    if (0 == indexPath.section)
    {
        if (0 == indexPath.row)
        {

            KeyValueCell *cell = [KeyValueCell cellFromNib];
            cell.lbKey.text = @"电梯品牌";

            if (_houseInfo)
            {
                cell.lbValue.text = _houseInfo[@"brand"];
            }

            return cell;

        }
        else if (1 == indexPath.row)
        {
            KeyValueCell *cell = [KeyValueCell cellFromNib];
            cell.lbKey.text = @"载重量";
            if (_houseInfo)
            {
                cell.lbValue.text = [NSString stringWithFormat:@"%@kg", _houseInfo[@"weight"]];
            }

            return cell;

        }
        else if (2 == indexPath.row)
        {
            KeyValueCell *cell = [KeyValueCell cellFromNib];
            cell.lbKey.text = @"电梯层站";

            if (_houseInfo)
            {
                cell.lbValue.text = [NSString stringWithFormat:@"%@层", _houseInfo[@"layerAmount"]];
            }

            return cell;

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

                [[HttpClient shareClient] post:URL_FAULT_LIST parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    FaultListResponse *response = [[FaultListResponse alloc] initWithDictionary:responseObject];

                    if ([response getFaultList].count > 0)
                    {
                        _falutType = [[response getFaultList] objectAtIndex:0].faultId;

                        [cell setData:[response getFaultList]];

                        [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
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

    }
    else if (1 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            KeyValueCell *cell = [KeyValueCell cellFromNib];
            cell.lbKey.text = @"联系人";
            if (_houseInfo)
            {
                cell.lbValue.text = _houseInfo[@"contacts"];
            }

            return cell;

        }
        else if (1 == indexPath.row)
        {
            KeyValueCell *cell = [KeyValueCell cellFromNib];
            cell.lbKey.text = @"联系人手机";
            if (_houseInfo)
            {
                cell.lbValue.text = _houseInfo[@"contactsTel"];
            }

            return cell;

        }
        else if (2 == indexPath.row)
        {
            KeyValueCell *cell = [KeyValueCell cellFromNib];
            cell.lbKey.text = @"业主";
            cell.lbValue.text = [[Config shareConfig] getName];

            return cell;

        }
        else if (3 == indexPath.row)
        {
            KeyValueCell *cell = [KeyValueCell cellFromNib];
            cell.lbKey.text = @"业主手机";
            cell.lbValue.text = [[Config shareConfig] getTel];

            return cell;

        }
        else if (4 == indexPath.row)
        {

            KeyValueBtnCell *cell = [KeyValueBtnCell cellFromNib];

            cell.lbKey.text = @"别墅地址";
            cell.lbValue.text = _houseInfo[@"cellName"];
            cell.btnTitle = @"切换";

            if (1 == self.arrayHouse.count)
            {
                [cell hideBtn];
            }

            __weak typeof(self) weakSelf = self;
            [cell addOnClickListener:^{
                [weakSelf showHouselist];
            }];

            return cell;


        }

    }

    return [KeyValueCell cellFromNib];

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

    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}

- (void)showHouselist
{
    if (0 == self.arrayHouse.count)
    {
        return;
    }

    if (1 == self.arrayHouse.count)
    {

        _houseInfo = self.arrayHouse[0];

        [_tableView reloadData];

        return;
    }

    NSMutableArray *array = [NSMutableArray array];

    for (NSDictionary *info in self.arrayHouse)
    {
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
    for (NSDictionary *info in self.arrayHouse)
    {
        if ([key isEqualToString:info[@"id"]])
        {

            _houseInfo = info;

            [_tableView reloadData];
            break;
        }
    }
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

- (void)showEditDialog:(SelectableCell *)cell
{
    DialogEditView *dialog = [DialogEditView viewFromNib];

    [dialog addOnClickOkListener:^(NSString *content) {
        cell.lbContent.text = content;

    }];

    [dialog addOnClickCancelListener:^{
        cell.lbContent.text = @"";
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

        CGSize size = CGSizeMake(360, 480);

        image = [ImageUtils imageWithImage:image scaledToSize:size];

        //上传到服务器
        [self uploadRepairImage:image];

        //将图片转换为 NSData
        NSData *data;

        data = UIImageJPEGRepresentation(image, 0.5);

        //将图片保存为rapid_repair.jpg
        NSString *dirPath = [NSHomeDirectory() stringByAppendingString:IMAGE_PATH];

        BOOL suc = [FileUtils writeFile:data Path:dirPath fileName:IMAGE_TEMP];

        if (suc)
        {
            NSLog(@"照片保存成功");

        }
        else
        {
            NSLog(@"照片保存失败");
        }

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
