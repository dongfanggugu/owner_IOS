//
//  RepairTaskDetailController.m
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RepairTaskDetailController.h"
#import "KeyValueCell.h"

@interface RepairTaskDetailController()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end


@implementation RepairTaskDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"任务详情"];
    [self initView];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width,
                                                               self.view.frame.size.height - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

//1待出发 2已出发 3工作中 5检修完成 6维修完成
- (NSString *)getStateDes:(NSInteger)state
{
    NSString *res = @"";
    
    switch (state) {
        case 1:
            res = @"待出发";
            break;
        case 2:
            res = @"已出发";
            break;
        case 3:
            res = @"工作中";
            break;
        case 5:
            res = @"检修完成";
            break;
        case 6:
            res = @"维修完成";
            break;
            
        default:
            break;
    }
    
    return res;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KeyValueCell *cell = [tableView dequeueReusableCellWithIdentifier:[KeyValueCell identifier]];
    
    if (!cell)
    {
        cell = [KeyValueCell cellFromNib];
    }
    
    if (0 == indexPath.row)
    {
        cell.lbKey.text = @"任务单号";
        cell.lbValue.text = _taskInfo.code;
    }
    else if (1 == indexPath.row)
    {
        cell.lbKey.text = @"维修状态";
        cell.lbValue.text = [self getStateDes:_taskInfo.state.integerValue];
    }
    else if (2 == indexPath.row)
    {
        cell.lbKey.text = @"维修人员姓名";
        cell.lbValue.text = _taskInfo.workerName;
    }
    else if (3 == indexPath.row)
    {
        cell.lbKey.text = @"维修人员电话";
        cell.lbValue.text = _taskInfo.workerTel;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
