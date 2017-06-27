//
// Created by changhaozhang on 2017/6/10.
// Copyright (c) 2017 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "OrderMaintDetailController.h"
#import "MaintProcessController.h"
#import "MaintDetailController.h"
#import "PayViewController.h"
#import "MaintTaskListController.h"


@interface OrderMaintDetailController () <MaintDetailControllerDelegate, MaintProcessControllerDelegate>

@end

@implementation OrderMaintDetailController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维保订单"];
    [self initView];
    [self loadProcessAndDetail];
}

- (void)initView
{
    NSArray *array = [NSArray arrayWithObjects:@"订单进度", @"订单详情",nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:array];
    CGRect frame = CGRectMake(0, 70, 200, 30);
    segment.frame = frame;

    segment.center = CGPointMake(self.screenWidth / 2, 90);

    segment.tintColor = RGB(TITLE_COLOR);

    [self.view addSubview:segment];

    [segment setSelectedSegmentIndex:0];
    [segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)segmentChanged:(UISegmentedControl *)segment
{
    NSInteger index = segment.selectedSegmentIndex;

    if (0 == index)
    {
        [self loadProcess];

    }
    else
    {
        [self loadDetail];
    }
}

- (void)loadProcessAndDetail
{
    MaintProcessController *controller = [[MaintProcessController alloc] init];
    controller.delegate = self;
    controller.orderInfo = _orderInfo;

    [self addChildViewController:controller];

    CGRect frame = CGRectMake(0, 118, self.screenWidth, self.screenHeight - 118);
    controller.view.frame = frame;

    [self.view addSubview:controller.view];

    MaintDetailController *detail = [[MaintDetailController alloc] init];

    detail.orderInfo = _orderInfo;
    detail.delegate = self;
    [self addChildViewController:detail];

    detail.view.frame = frame;
}

- (void)loadProcess
{
    if (self.childViewControllers.count < 2) {
        return;
    }

    [self transitionFromViewController:self.childViewControllers[1] toViewController:self.childViewControllers[0]
                              duration:0 options:UIViewAnimationOptionTransitionNone animations:^{

            } completion:^(BOOL finished) {

            }];
}

- (void)loadDetail
{
    if (self.childViewControllers.count < 2) {
        return;
    }
     [self transitionFromViewController:self.childViewControllers[0] toViewController:self.childViewControllers[1]
                              duration:0 options:UIViewAnimationOptionTransitionNone animations:^{

            } completion:^(BOOL finished) {

            }];
}

#pragma mark - MaintDetailControllerDelegate

- (void)onClickPay
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"paymentId"] = _orderInfo[@"id"];

    [[HttpClient shareClient] post:@"continuePayment" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {

        NSString *url = [responseObject[@"body"] objectForKey:@"url"];

        if (url.length != 0)
        {
            PayViewController *controller = [[PayViewController alloc] init];
            controller.urlStr = url;

            [self presentViewController:controller animated:YES completion:^{
                [self.navigationController popViewControllerAnimated:NO];
            }];
        }
    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}

#pragma mark - MaintProcessControllerDelegate

- (void)checkMaintTask
{
    MaintTaskListController *controller = [[MaintTaskListController alloc] init];
    controller.orderInfo = _orderInfo;

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end