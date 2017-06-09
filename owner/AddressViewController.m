//
//  AddressViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/7/5.
//
//

#import <Foundation/Foundation.h>
#import "AddressViewController.h"
#import "LocationViewController.h"
#import "HUDClass.h"
#import "HttpClient.h"


@interface AddressViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

@property (weak, nonatomic) IBOutlet UITextField *addressTF;

@property (strong, nonatomic) NSArray *dataArray;

@property (strong, nonatomic) UIView *alartView;

@property (strong, nonatomic) UITableView *tableView;


@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"地址填写"];
    [self initView];
}

- (void)initView {
    [self setTitleRight];

    [_locationBtn addTarget:self action:@selector(location) forControlEvents:UIControlEventTouchUpInside];


    _latView.hidden = YES;
    _latValueLabel.hidden = YES;

    _lngView.hidden = YES;
    _lngValueLabel.hidden = YES;
}

/**
 *  设置标题栏右侧
 */
- (void)setTitleRight {
    UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnSubmit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnSubmit];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)location {
    NSString *address = [_addressTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (0 == address.length) {
        [HUDClass showHUDWithText:@"请先填写您的详细地址"];
        return;
    }
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
    LocationViewController *controller = [board instantiateViewControllerWithIdentifier:@"address_location"];
    controller.address = address;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)submit {

    NSString *address = [_addressTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (0 == address.length) {
        [HUDClass showHUDWithText:@"请填写您的详细地址!"];
        return;
    }

    NSString *lat = _latValueLabel.text;
    NSString *lng = _lngValueLabel.text;
    if (0 == lat.length || 0 == lng.length) {
        [HUDClass showHUDWithText:@"请点击定位图标,选择地图上的位置!"];
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"address"] = address;
    params[@"lat"] = [NSNumber numberWithFloat:[lat floatValue]];
    params[@"lng"] = [NSNumber numberWithFloat:[lng floatValue]];

    __weak typeof(self) weakSelf = self;

    [[HttpClient shareClient] post:URL_PERSON_MODIFY parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [[Config shareConfig] setBranchAddress:address];
        [[Config shareConfig] setLat:[lat floatValue]];
        [[Config shareConfig] setLng:[lng floatValue]];
        [HUDClass showHUDWithText:@"修改成功"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];

}


- (void)readZones {
    NSString *zoneJson = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"beijing_districts" ofType:@"json"]
                                                   encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [zoneJson dataUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *zoneDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    _dataArray = [zoneDic objectForKey:@"districts"];
    [self showZones];
}

- (void)showZones {
    if (_alartView != nil && _alartView.window != nil) {
        NSLog(@"already showing");
        return;
    }

    if (_alartView != nil && nil == _alartView.window) {
        [self.view addSubview:_alartView];
        return;
    }

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

    _alartView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    _alartView.backgroundColor = [UIColor clearColor];

    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, screenWidth - 40, screenHeight - 60 - 64)];
    parentView.backgroundColor = [UIColor whiteColor];
    //设置阴影
    parentView.layer.shadowColor = [UIColor blackColor].CGColor;
    parentView.layer.shadowOffset = CGSizeMake(4, 4);
    parentView.layer.shadowOpacity = 0.6;
    parentView.layer.shadowRadius = 4;


    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 40, 40)];
    titleLabel.text = @"城区选择";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor colorWithRed:0.0 green:126 / 255.0 blue:197 / 255.0 alpha:1.0];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, screenWidth - 40, screenHeight - 60 - 64 - 80)
                                              style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, screenHeight - 60 - 64 - 40, screenWidth - 40, 40)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1.0]];
    [cancelBtn addTarget:self action:@selector(cancelAlertView) forControlEvents:UIControlEventTouchUpInside];


    [_alartView addSubview:parentView];
    [parentView addSubview:titleLabel];
    [parentView addSubview:_tableView];
    [parentView addSubview:cancelBtn];
    [self.view addSubview:_alartView];
}

- (void)cancelAlertView {
    if (_alartView != nil && _alartView.window != nil) {
        [_alartView removeFromSuperview];
    }
}


#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zone_cell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zone_cell"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 150, 24)];
        label.tag = 1001;
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
    }

    NSDictionary *info = _dataArray[indexPath.row];
    UILabel *label = (UILabel *) [cell.contentView viewWithTag:1001];
    label.text = [info objectForKey:@"name"];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = _dataArray[indexPath.row];

    NSString *name = [info objectForKey:@"name"];
    [_alartView removeFromSuperview];
}

@end
