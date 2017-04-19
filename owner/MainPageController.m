//
//  MainPageController.m
//  owner
//
//  Created by 长浩 张 on 2017/1/6.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainPageController.h"
#import "MaintenanceController.h"
#import "RapidRepairController.h"
#import "AddBannerView.h"
#import "AddBannerData.h"
#import "EnsuranceController.h"

@interface MainPageController  () <AddBannerViewDelegate>

@property (weak, nonatomic) IBOutlet AddBannerView *bannerView;

@property (weak, nonatomic) IBOutlet UIImageView *ivMaintenance;

@property (weak, nonatomic) IBOutlet UIImageView *ivRepair;

@property (weak, nonatomic) IBOutlet UIImageView *ivInsure;

@property (weak, nonatomic) IBOutlet UIImageView *ivKnowledge;

@property (weak, nonatomic) IBOutlet UIImageView *ivMarket;

@property (weak, nonatomic) IBOutlet UIImageView *ivOther;


@end

@implementation MainPageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"老丁电梯"];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self initView];
    [self checkUpdate];
}


- (void)onClickNavRight
{
    [HUDClass showHUDWithText:@"功能开发中!"];
}

- (void)initView
{
    self.tableView.allowsSelection = NO;
    self.tableView.bounces = NO;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self initBannerView];
    
    _ivMaintenance.userInteractionEnabled = YES;
    [_ivMaintenance addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maintenance)]];
    
    _ivRepair.userInteractionEnabled = YES;
    [_ivRepair addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(repair)]];
    
    
    _ivInsure.userInteractionEnabled = YES;
    [_ivInsure addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ensurance)]];
    
    _ivKnowledge.userInteractionEnabled = YES;
    [_ivKnowledge addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(help)]];
    
    _ivMarket.userInteractionEnabled = YES;
    [_ivMarket addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(market)]];
    
    _ivOther.userInteractionEnabled = YES;
    [_ivOther addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(other)]];
    
}

- (void)initBannerView
{
    
    __weak typeof(self) weakSelf = self;
    
    [[HttpClient shareClient] post:@"getAdvertisementBySmallOwner" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSDictionary *dic in [responseObject objectForKey:@"body"])
        {
            AddBannerData *data = [[AddBannerData alloc] initWithUrl:[dic objectForKey:@"pic"]
                                                            clickUrl:[dic objectForKey:@"picUrl"]];
            [array addObject:data];
        }
        
        weakSelf.bannerView.arrayData = [array copy];
        [weakSelf.bannerView shouldAutoShow:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)repair
{
    RapidRepairController *controller = [[RapidRepairController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)maintenance
{
    MaintenanceController *controller = [[MaintenanceController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)ensurance
{
    EnsuranceController *controller = [[EnsuranceController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)market
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Market" bundle:nil];
    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"market_detail"];
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    //self.hidesBottomBarWhenPushed = NO;
}

- (void)help
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Help" bundle:nil];
    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"help_controller"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)other
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"other_controller"];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        return self.screenWidth / 2;
        
    }
    
    return 120;
}


/**
 *  检测是否需要升级
 */
- (void)checkUpdate
{
    
    [[HttpClient shareClient] post:URL_VERSION_CHECK parameters:nil
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSInteger remoteVersion = [[responseObject[@"body"] objectForKey:@"appVersion"] integerValue];
                               
                               NSLog(@"remote version:%ld", remoteVersion);
                               
                               NSInteger localVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] integerValue];
                               
                               if(remoteVersion > localVersion) {
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
    
    [controller addAction:[UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self jumpToUpdate];
    }]];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"暂不升级" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
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
