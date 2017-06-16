//
//  MainTaskDetailController.m
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainTaskDetailController.h"
#import "MainTaskDetailCell.h"
#import "EvaluateController.h"
#import "MainTypeDetailController.h"
#import "MaintEvaluateController.h"
#import "MaintResultController.h"
#import "DatePickerDialog.h"


@interface MainTaskDetailController () <UITableViewDelegate, UITableViewDataSource, DatePickerDialogDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (weak, nonatomic) MainTaskDetailCell *taskCell;

@end


@implementation MainTaskDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"任务详情"];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth,
            self.screenHeight - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTaskDetailCell *cell = [MainTaskDetailCell cellFromNib];

    _taskCell = cell;

    cell.lbPlanDate.text = _taskInfo.planTime;

    cell.lbContent.text = _taskInfo.maintOrderInfo.maintypeInfo.content;

    cell.lbWorker.text = _taskInfo.maintUserInfo.name;

    cell.lbTel.text = _taskInfo.maintUserInfo.tel;

    cell.lbAddress.text = _taskInfo.maintOrderInfo.villaInfo[@"cellName"];

    CGFloat lat = [_taskInfo.maintOrderInfo.villaInfo[@"lat"] floatValue];

    CGFloat lng = [_taskInfo.maintOrderInfo.villaInfo[@"lng"] floatValue];

    NSInteger state = _taskInfo.state.integerValue;

    [self showViewWithState:state cell:cell];

    [cell markOnMapWithLat:lat lng:lng];

    __weak typeof(self) weakSelf = self;


    [cell setOnClickMore:^{
        MainTypeDetailController *controller = [[MainTypeDetailController alloc] init];
        controller.detail = weakSelf.taskInfo.maintOrderInfo.maintypeInfo.content;

        controller.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];

    return cell;
}

- (void)showViewWithState:(NSInteger)state cell:(MainTaskDetailCell *)cell
{
    switch (state)
    {
        case 0:     //待确认
            [self state0:cell];
            break;

        case 1:     //已确认
            [self state1:cell];
            break;

        case 2:     //已出发
            [self state2:cell];
            break;

        case 3:     //已到达
            [self state3:cell];
            break;

        case 4:     //已完成
            [self state4:cell];
            break;

        case 5:     //已评价
            [self state5:cell];
            break;

        default:
            break;
    }
}

- (void)state0:(MainTaskDetailCell *)cell
{
    [cell.btnFinish setTitle:@"确认计划" forState:UIControlStateNormal];

    cell.btnResult.hidden = YES;

    __weak typeof(self) weakSelf = self;

    [cell setOnClickModify:^{
        [weakSelf showDatePicker];
    }];

    NSString *planTime = cell.lbPlanDate.text;
    [cell setOnClickFinish:^{
        [weakSelf confirmPlan:planTime];
    }];
}

- (void)state1:(MainTaskDetailCell *)cell
{
    cell.btnPlanDate.hidden = YES;
    cell.btnResult.hidden = YES;
    cell.btnFinish.hidden = YES;
}

- (void)state2:(MainTaskDetailCell *)cell
{
    cell.btnPlanDate.hidden = YES;
    cell.btnResult.hidden = YES;
    cell.btnFinish.hidden = YES;
}

- (void)state3:(MainTaskDetailCell *)cell
{
    cell.btnPlanDate.hidden = YES;
    cell.btnResult.hidden = YES;
    cell.btnFinish.hidden = YES;
}

- (void)state4:(MainTaskDetailCell *)cell
{
    cell.btnPlanDate.hidden = YES;
    cell.btnResult.hidden = NO;

    __weak typeof(self) weakSelf = self;

    [cell setOnClickResult:^{
        MaintResultController *controller = [[MaintResultController alloc] init];

        controller.maintContent = weakSelf.taskInfo.maintUserFeedback;
        controller.urlBefore = weakSelf.taskInfo.beforeImg;
        controller.urlAfter = weakSelf.taskInfo.afterImg;

        controller.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];

    [cell.btnFinish setTitle:@"维保评价" forState:UIControlStateNormal];


    [cell setOnClickFinish:^{
        MaintEvaluateController *controller = [[MaintEvaluateController alloc] init];
        controller.taskInfo = weakSelf.taskInfo;

        controller.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
}

- (void)state5:(MainTaskDetailCell *)cell
{
    cell.btnPlanDate.hidden = YES;
    cell.btnResult.hidden = NO;

    __weak typeof(self) weakSelf = self;

    [cell setOnClickResult:^{
        MaintResultController *controller = [[MaintResultController alloc] init];

        controller.maintContent = weakSelf.taskInfo.maintUserFeedback;
        controller.urlBefore = weakSelf.taskInfo.beforeImg;
        controller.urlAfter = weakSelf.taskInfo.afterImg;

        controller.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];

    [cell.btnFinish setTitle:@"查看评价" forState:UIControlStateNormal];

    [cell setOnClickFinish:^{

        EvaluateController *controller = [[EvaluateController alloc] init];
        controller.enterType = Show;
        controller.content = weakSelf.taskInfo.evaluateContent;
        controller.star = weakSelf.taskInfo.evaluateResult;

        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
}

- (void)confirmPlan:(NSString *)planTime
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"maintOrderPorcessId"] = _taskInfo.taskId;
    params[@"planTime"] = planTime;

    __weak typeof(self) weakSelf = self;
    [[HttpClient shareClient] post:URL_OWNER_CONFIRM parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        weakSelf.taskInfo.planTime = planTime;
        weakSelf.taskInfo.state = @"1";
        [HUDClass showHUDWithText:@"维保计划确认已经确认,请等待维修工上门服务"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MainTaskDetailCell cellHeight];
}


- (void)showDatePicker
{
    DatePickerDialog *dialog = [DatePickerDialog viewFromNib];
    dialog.delegate = self;

    [dialog show];
}

#pragma mark - DatePickerDelegate

- (void)onPickerDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [format stringFromDate:date];
    _taskCell.lbPlanDate.text = dateStr;
}

@end
