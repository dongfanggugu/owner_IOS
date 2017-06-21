//
//  MainPageController.m
//  owner
//
//  Created by 长浩 张 on 2017/1/6.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainPageController.h"
#import "RapidRepairController.h"
#import "AddBannerView.h"
#import "AddBannerData.h"
#import "EnsuranceMainController.h"
#import "OtherController.h"
#import "ReportController.h"
#import "CommonWebViewController.h"
#import "RapidRepairLoginController.h"
#import "KnowledgeController.h"
#import "HelpController.h"
#import "MarketDetailController.h"


@interface MainPageController () <AddBannerViewDelegate>

@property (strong, nonatomic) AddBannerView *bannerView;

@property (strong, nonatomic) UILabel *lbLocation;

@property (weak, nonatomic) IBOutlet UIImageView *ivMaintenance;

@property (weak, nonatomic) IBOutlet UILabel *lbMaint;

@property (weak, nonatomic) IBOutlet UIImageView *ivRepair;

@property (weak, nonatomic) IBOutlet UILabel *lbRepair;

@property (weak, nonatomic) IBOutlet UIImageView *ivInsure;

@property (weak, nonatomic) IBOutlet UIImageView *ivKnowledge;

@property (weak, nonatomic) IBOutlet UIImageView *ivMarket;

@property (weak, nonatomic) IBOutlet UILabel *lbMarket;

@property (weak, nonatomic) IBOutlet UIImageView *ivOther;

@property (weak, nonatomic) IBOutlet UIImageView *ivExpert;

@property (weak, nonatomic) IBOutlet UIView *viewCompany;

@property (weak, nonatomic) IBOutlet UILabel *lbKn1;

@property (weak, nonatomic) IBOutlet UILabel *lbKn2;

@property (weak, nonatomic) IBOutlet UILabel *lbKn3;

@property (weak, nonatomic) IBOutlet UILabel *lbKn4;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoConstraint;



@end

@implementation MainPageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"首页"];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self initView];
    [self checkUpdate];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

//    self.navigationController.navigationBar.hidden = NO;
}

- (void)onClickNavRight
{
    [HUDClass showHUDWithText:@"功能开发中!"];
}

- (void)initView
{

    self.tableView.bounces = NO;

//    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.screenWidth, 20)];
//    statusView.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
//
//    [self.view addSubview:statusView];

    [self.tableView showCopyWrite];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    UIView *footView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footView;

    self.tableView.backgroundColor = [Utils getColorByRGB:@"#e1e1e1"];

    [self initBannerView];

    _ivMaintenance.userInteractionEnabled = YES;
    [_ivMaintenance addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maintenance)]];

    _lbMaint.userInteractionEnabled = YES;
    [_lbMaint addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maintenance)]];

    _ivRepair.userInteractionEnabled = YES;
    [_ivRepair addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(repair)]];

    _lbRepair.userInteractionEnabled = YES;
    [_lbRepair addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(repair)]];

    _ivInsure.userInteractionEnabled = YES;
    [_ivInsure addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ensurance)]];

    _ivKnowledge.userInteractionEnabled = YES;
    [_ivKnowledge addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(help)]];

    _ivMarket.userInteractionEnabled = YES;
    [_ivMarket addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(market)]];

    _lbMarket.userInteractionEnabled = YES;
    [_lbMarket addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(market)]];

    _ivOther.userInteractionEnabled = YES;
    [_ivOther addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(other)]];


    _ivExpert.userInteractionEnabled = YES;
    [_ivExpert addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expert)]];

    //电梯常识
    _lbKn1.userInteractionEnabled = YES;
    [_lbKn1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(QA)]];

    _lbKn2.userInteractionEnabled = YES;
    [_lbKn2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faultCode)]];

    _lbKn3.userInteractionEnabled = YES;
    [_lbKn3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(operation)]];

    _lbKn4.userInteractionEnabled = YES;
    [_lbKn4 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(safety)]];

    [self initCompanyLogo];
}

- (void)initCompanyLogo
{
    _logoConstraint.constant = self.screenWidth / 12 + 2;

    CGFloat width = (self.screenWidth - 5) / 4;
    CGFloat height = (self.screenWidth - 5) / 12;

    UIImageView *com1 = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, width, height)];
    com1.image = [UIImage imageNamed:@"honyum_logo.png"];
    com1.userInteractionEnabled = YES;
    [com1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(honyum)]];

    UIImageView *com2 = [[UIImageView alloc] initWithFrame:CGRectMake(1 + (width + 1), 1, width, height)];
    com2.image = [UIImage imageNamed:@"zhonghao_logo.png"];
    com2.userInteractionEnabled = YES;
    [com2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zhonghaojidian)]];

    UIImageView *com3 = [[UIImageView alloc] initWithFrame:CGRectMake(1 + (width + 1) * 2, 1, width, height)];
    com3.image = [UIImage imageNamed:@"jiuzhou.png"];
    com3.userInteractionEnabled = YES;
    [com3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jiuzhou)]];

    UIImageView *com4 = [[UIImageView alloc] initWithFrame:CGRectMake(1 + (width + 1) * 3, 1, width, height)];
    com4.image = [UIImage imageNamed:@"zhongxunlongchen.png"];
    com4.userInteractionEnabled = YES;
    [com4 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zhongxunlongchen)]];


    _viewCompany.backgroundColor = RGB(@"#FFFFFF");

    [_viewCompany addSubview:com1];
    [_viewCompany addSubview:com2];
    [_viewCompany addSubview:com3];
    [_viewCompany addSubview:com4];
}

- (void)QA
{
    KnowledgeController *controller = [[KnowledgeController alloc] init];

    controller.knType = @"常见问题";
    controller.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:controller animated:YES];
}

- (void)faultCode
{
    KnowledgeController *controller = [[KnowledgeController alloc] init];

    controller.knType = @"故障码";
    controller.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:controller animated:YES];
}

- (void)operation
{
    KnowledgeController *controller = [[KnowledgeController alloc] init];

    controller.knType = @"操作手册";
    controller.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:controller animated:YES];
}

- (void)safety
{
    KnowledgeController *controller = [[KnowledgeController alloc] init];

    controller.knType = @"安全法规";
    controller.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:controller animated:YES];
}


- (void)initBannerView
{
    self.tableView.tableHeaderView = self.bannerView;

    __weak typeof(self) weakSelf = self;

    [[HttpClient shareClient] bagpost:@"getAdvertisementBySmallOwner" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray *array = [NSMutableArray array];

        for (NSDictionary *dic in [responseObject objectForKey:@"body"])
        {
            AddBannerData *data = [[AddBannerData alloc] initWithUrl:[dic objectForKey:@"pic"]
                                                            clickUrl:[dic objectForKey:@"picUrl"]];
            [array addObject:data];
        }

        weakSelf.bannerView.arrayData = [array copy];
        [weakSelf.bannerView shouldAutoShow:YES];

    }                         failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}

- (AddBannerView *)bannerView
{
    if (!_bannerView)
    {
        _bannerView = [[AddBannerView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenWidth / 2)];

        _lbLocation = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 21)];
        _lbLocation.backgroundColor = [UIColor colorWithRed:54 / 256.0 green:176 / 256.0 blue:243 / 256.0 alpha:0.5];
        _lbLocation.font = [UIFont systemFontOfSize:13];

        _lbLocation.textColor = [UIColor whiteColor];

        _lbLocation.textAlignment = NSTextAlignmentCenter;

        _lbLocation.text = @"北京";

        _lbLocation.layer.masksToBounds = YES;

        _lbLocation.layer.cornerRadius = 10;

        _lbLocation.center = CGPointMake(self.screenWidth - 40, 15);

        //[_bannerView addSubview:_lbLocation];
    }


    return _bannerView;
}

- (void)repair
{
    if (!self.login)
    {
        RapidRepairController *controller = [[RapidRepairController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:controller animated:YES];
        return;
    }

    RapidRepairLoginController *controller = [[RapidRepairLoginController alloc] init];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)maintenance
{
    ReportController *controller = [[ReportController alloc] init];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:controller];
}

- (void)ensurance
{
    EnsuranceMainController *controller = [[EnsuranceMainController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)market
{

    MarketDetailContrller *controller = [[MarketDetailContrller alloc] init];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)help
{
    HelpController *controller = [[HelpController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:controller animated:YES];
}

- (void)other
{
    OtherController *controller = [[OtherController alloc] init];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)expert
{
    CommonWebViewController *controller = [[CommonWebViewController alloc] init];
    controller.titleStr = @"专家团队";
    controller.urlLink = [NSString stringWithFormat:@"%@static/h5/expert.html", [Utils getIp]];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)honyum
{
    CommonWebViewController *controller = [[CommonWebViewController alloc] init];
    controller.titleStr = @"中建华宇";
    controller.urlLink = [NSString stringWithFormat:@"%@static/h5/honyum.html", [Utils getIp]];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)zhonghaojidian
{
    CommonWebViewController *controller = [[CommonWebViewController alloc] init];
    controller.titleStr = @"中豪机电";
    controller.urlLink = [NSString stringWithFormat:@"%@static/h5/zhonghao.html", [Utils getIp]];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)jiuzhou
{
    CommonWebViewController *controller = [[CommonWebViewController alloc] init];
    controller.titleStr = @"九洲";
    controller.urlLink = [NSString stringWithFormat:@"%@static/h5/jiuzhou.html", [Utils getIp]];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)zhongxunlongchen
{
    CommonWebViewController *controller = [[CommonWebViewController alloc] init];
    controller.titleStr = @"中讯龙臣";
    controller.urlLink = [NSString stringWithFormat:@"%@static/h5/zhongxunlongchen.html", [Utils getIp]];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        return 865;

    }
    return 240;
}


/**
 *  检测是否需要升级
 */
- (void)checkUpdate
{

    NSMutableDictionary *head = [NSMutableDictionary dictionary];
    [head setObject:@"3" forKey:@"osType"];
    [head setObject:@"1.0" forKey:@"version"];
    [head setObject:@"" forKey:@"deviceId"];

    [[HttpClient shareClient] post:URL_VERSION_CHECK head:head body:nil
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSInteger remoteVersion = [[responseObject[@"body"] objectForKey:@"appVersion"] integerValue];

                               NSLog(@"remote version:%ld", remoteVersion);

                               NSInteger localVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] integerValue];

                               if (remoteVersion > localVersion)
                               {
                                   [self performSelectorOnMainThread:@selector(alertUpdate) withObject:nil waitUntilDone:NO];
                               }

                           } failure:^(NSURLSessionDataTask *task, NSError *errr) {

            }];

}

/**
 *  提示进行升级
 */
- (void)alertUpdate
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"新的版本可用，请进行升级"
                                                                 preferredStyle:UIAlertControllerStyleAlert];

    [controller addAction:[UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [self jumpToUpdate];
    }]];

    [controller addAction:[UIAlertAction actionWithTitle:@"暂不升级" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {

    }]];

    [self presentViewController:controller animated:YES completion:nil];
}


- (void)jumpToUpdate
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://fir.im/liftowner"]];
}


#pragma mark - AddBannerViewDelegate

- (void)didClickPage:(AddBannerView *)view url:(NSString *)url
{
    NSLog(@"banner url:%@", url);
}

@end
