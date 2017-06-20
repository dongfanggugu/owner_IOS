//
//  CouponViewController.m
//  owner
//
//  Created by 长浩 张 on 2017/6/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponCell.h"

@interface CouponViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayCoupon;

@end

@implementation CouponViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"我的优惠券"];

    [self initView];
    [self getCoupons];
}

- (NSMutableArray *)arrayCoupon
{
    if (!_arrayCoupon)
    {
        _arrayCoupon = [NSMutableArray array];
    }

    return _arrayCoupon;
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:_tableView];
}

/**
 * get available coupons
 *
 * private String id;
	private String branchId;  //代理公司
	private String branchName;
	private String couponCode;//优惠券编码
	private String couponName;//优惠券名称
	private String province;//省
	private String city;//市
	private String county;//区
	private String smallOwnerId;  //业主id
	private String smallOwnerName;
	private String smallOwnerTel;
	private Date grandDate;  //发放日期
	private Date effectiveStarteDate; //有效期
	private Date effectiveEndDate;
	private int effectiveDays;  //有效期天数
	private int startMoney;  //起始使用金额
	private int couponMoney;  //优惠券金额
	private int type ;//优惠券类型
	private String typeName ;//优惠券类型
	private int stage; //阶段
	private String stageName; //阶段
	private String createTime;
	private String grandBranchId;
	private String grandBranchName;
	private String grandUserId;
	private String grandUserName;
 */
- (void)getCoupons
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[@"province"] = @"北京市";

    NSString *url = @"getCouponRecordBySmallOwner";

    if (0 == _branchId.length)
    {
        url = @"getSureCouponRecord";
    }
    else
    {
        params[@"branchId"] = _branchId;    //选择维保公司id

        params[@"startMoney"] = [NSNumber numberWithInteger:(NSInteger)(_payAmount * 100)];  //订单原始价格，单位为分
    }

    __weak typeof(self) weakSelf = self;
    [[HttpClient shareClient] post:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf.arrayCoupon removeAllObjects];

        [weakSelf.arrayCoupon addObjectsFromArray:responseObject[@"body"]];

        [weakSelf.tableView reloadData];

    } failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayCoupon.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:[CouponCell identifier]];

    if (!cell)
    {
        cell = [CouponCell cellFromNib];
    }

    NSDictionary *info = self.arrayCoupon[indexPath.row];
    cell.lbAmount.text = [NSString stringWithFormat:@"%.2lf", [info[@"couponMoney"] floatValue]];

    cell.lbDeadTime.text = [NSString stringWithFormat:@"有效期:%@ 至 %@", info[@"effectiveStarteDate"], info[@"effectiveEndDate"]];

    cell.lbDes.text = [NSString stringWithFormat:@"满%.2lf可用", [info[@"startMoney"] floatValue]];
    cell.tvZone.text = [NSString stringWithFormat:@"限%@地区使用", info[@"city"]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(onChooseCoupon:)])
    {
        [_delegate onChooseCoupon:self.arrayCoupon[indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.screenWidth / 3;
}


@end
