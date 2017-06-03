//
//  MaintEvaluateController.m
//  owner
//
//  Created by 长浩 张 on 2017/6/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "MaintEvaluateController.h"
#import "MaintEvaluateView.h"
#import "MainTaskEvaluateRequest.h"
#import "MainTaskInfo.h"

@interface MaintEvaluateController () <UITableViewDelegate, UITableViewDataSource, MaintEvaluateViewDelegate>

@property (strong, nonatomic) MaintEvaluateView *evaluateView;

@end

@implementation MaintEvaluateController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维保评价"];
    [self initView];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    
    //处理评价界面
    self.evaluateView = [MaintEvaluateView viewFromNib];
    self.evaluateView.delegate = self;
    
    tableView.tableHeaderView = self.evaluateView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - MaintEvaluateViewDelegate

- (void)onSubmit:(NSInteger)star content:(NSString *)content
{
    MainTaskEvaluateRequest *request = [[MainTaskEvaluateRequest alloc] init];
    request.maintOrderProcessId = self.taskInfo.taskId;
    request.evaluateContent = content;
    request.evaluateResult = star;
    
    [[HttpClient shareClient] post:URL_MAIN_TASK_EVALUATE parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithText:@"维保评价成功"];
        _taskInfo.evaluateContent = content;
        _taskInfo.evaluateResult = star;
        _taskInfo.state = @"3";
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

@end
