//
// Created by changhaozhang on 2017/6/22.
// Copyright (c) 2017 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "MaintTaskListController.h"
#import "MainTaskInfo.h"
#import "MainTaskCell.h"
#import "MainTaskListResponse.h"
#import "MainTaskDetailController.h"


@interface MaintTaskListController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<MainTaskInfo *> *arrayTask;

@end

@implementation MaintTaskListController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维保任务单"];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getTask];
}

- (NSMutableArray *)arrayTask
{
    if (!_arrayTask)
    {
        _arrayTask = [NSMutableArray array];
    }

    return _arrayTask;
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    //维保记录
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [_tableView showCopyWrite];

    [self.view addSubview:_tableView];
}

- (void)getTask
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"maintOrderId"] = _orderInfo[@"id"];

    [[HttpClient shareClient] post:@"getMaintOrderProcessByMaintOrder" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        MainTaskListResponse *response = [[MainTaskListResponse alloc] initWithDictionary:responseObject];

        [self.arrayTask removeAllObjects];

        [self.arrayTask addObjectsFromArray:[response getTaskList]];

        [self reloadData];
    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}
- (void)reloadData
{
    if (0 == self.arrayTask.count)
    {
        //当没有维保信息时，提示
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 40)];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;

        label.numberOfLines = 0;

        label.text = @"您还没有为您的别墅购买维保订单!";

        _tableView.tableHeaderView = label;
    }
    else
    {
       _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    }

    [_tableView reloadData];
}


//0待确认 1已确认 2已完成 3已评价
- (NSString *)getStateDes:(NSInteger)state
{
    NSString *res = @"";

    switch (state)
    {
        case 0:
            res = @"待确认";
            break;

        case 1:
            res = @"已确认";
            break;

        case 2:
            res = @"已出发";
            break;

        case 3:
            res = @"已到达";
            break;

        case 4:
            res = @"待评价";
            break;

        case 5:
            res = @"已评价";
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
    return _arrayTask.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:[MainTaskCell identifier]];

    if (!cell)
    {
        cell = [MainTaskCell cellFromNib];
    }

    MainTaskInfo *info = _arrayTask[indexPath.row];

    cell.lbIndex.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];

    cell.lbCode.text = info.taskCode;

    cell.lbState.text = [self getStateDes:info.state.integerValue];

    cell.lbWorker.text = [NSString stringWithFormat:@"维保工人: %@", info.maintUserInfo.name];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MainTaskCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MainTaskDetailController *controller = [[MainTaskDetailController alloc] init];
    controller.taskInfo = _arrayTask[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


@end