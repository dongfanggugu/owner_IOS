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


@interface MainTaskDetailController() <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

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
    
    cell.lbPlanDate.text = _taskInfo.planTime;
    
    cell.lbContent.text = _taskInfo.maintOrderInfo.maintypeInfo.content;
    
    cell.lbWorker.text = _taskInfo.maintUserInfo.name;
    
    cell.lbTel.text = _taskInfo.maintUserInfo.tel;

    cell.lbAddress.text = _taskInfo.maintOrderInfo.villaInfo[@"cellName"];
    
    CGFloat lat = [_taskInfo.maintOrderInfo.villaInfo[@"lat"] floatValue];
    
    CGFloat lng = [_taskInfo.maintOrderInfo.villaInfo[@"lng"] floatValue];
    
    NSInteger state = _taskInfo.state.integerValue;
    
    if (3 == state) {
        [cell.btnEvaluate setTitle:@"查看评价" forState:UIControlStateNormal];
    }
    
    [cell markOnMapWithLat:lat lng:lng];
    
    __weak typeof (self) weakSelf = self;
    
    [cell setOnClickEvaluate:^{
        EvaluateController *controller = [[EvaluateController alloc] init];
        
        NSInteger state = weakSelf.taskInfo.state.integerValue;
        
        if (3 == state) {
            controller.enterType = Show;
            controller.content = weakSelf.taskInfo.evaluateContent;
            controller.star = weakSelf.taskInfo.evaluateResult;
        
        } else {
            controller.enterType = Maint_Submit;
            controller.mainTaskInfo = weakSelf.taskInfo;
        }
        
        
        controller.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
    
    [cell setOnClickMore:^{
        MainTypeDetailController *controller = [[MainTypeDetailController alloc] init];
        controller.detail = weakSelf.taskInfo.maintOrderInfo.maintypeInfo.content;
        
        controller.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
    
    
    [cell setOnClickFinish:^{
        EvaluateController *controller = [[EvaluateController alloc] init];
        
        NSInteger state = weakSelf.taskInfo.state.integerValue;
        
        if (3 == state) {
            controller.enterType = Show;
            controller.content = weakSelf.taskInfo.evaluateContent;
            controller.star = weakSelf.taskInfo.evaluateResult;
            
        } else {
            controller.enterType = Maint_Submit;
            controller.mainTaskInfo = weakSelf.taskInfo;
        }

    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MainTaskDetailCell cellHeight];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
