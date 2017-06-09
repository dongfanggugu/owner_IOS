//
//  ServiceTaskController.m
//  owner
//
//  Created by 长浩 张 on 2017/4/28.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "ServiceTaskController.h"
#import "MainTaskListRequest.h"
#import "MainTaskListResponse.h"
#import "RepairTaskCell.h"
#import "MainTaskDetailController.h"


@interface ServiceTaskController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayTask;

@end

@implementation ServiceTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"维保服务单"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getTask];
}

- (NSMutableArray *)arrayTask {
    if (!_arrayTask) {
        _arrayTask = [NSMutableArray array];
    }

    return _arrayTask;
}

- (void)initNoHistoryView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, self.screenWidth, 40)];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;

    label.text = @"您还没有服维保服务单!";

    [self.view addSubview:label];

    return;
}

- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _tableView.delegate = self;

    _tableView.dataSource = self;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:_tableView];
}

- (void)getTask {
    MainTaskListRequest *request = [[MainTaskListRequest alloc] init];

    request.maintOrderId = _serviceId;

    [[HttpClient shareClient] post:URL_MAIN_TASK parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        MainTaskListResponse *response = [[MainTaskListResponse alloc] initWithDictionary:responseObject];

        [self.arrayTask removeAllObjects];

        [self.arrayTask addObjectsFromArray:[response getTaskList]];

        if (0 == self.arrayTask.count) {
            [self initNoHistoryView];

        } else {
            [self initTableView];

        }

    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}

//0待确认 1已确认 2已完成 3已评价
- (NSString *)getStateDes:(NSInteger)state {
    NSString *res = @"";

    switch (state) {
        case 0:
            res = @"待确认";
            break;
        case 1:
            res = @"已确认";
            break;
        case 2:
            res = @"已完成";
            break;
        case 3:
            res = @"已评价";
            break;

        default:
            break;
    }

    return res;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayTask.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RepairTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:[RepairTaskCell identifier]];

    if (!cell) {
        cell = [RepairTaskCell cellFromNib];
    }

    MainTaskInfo *info = _arrayTask[indexPath.row];

    cell.lbCode.text = info.taskCode;

    cell.lbState.text = [self getStateDes:info.state.integerValue];

    //cell.lbInfo.text = [NSString stringWithFormat:@"%@ %@", info.maintUserInfo.name, info.maintUserInfo.tel];

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [RepairTaskCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MainTaskDetailController *controller = [[MainTaskDetailController alloc] init];
    controller.taskInfo = _arrayTask[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
