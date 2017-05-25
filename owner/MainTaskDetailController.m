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

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth,
                                                               self.screenHeight - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
    
//    NSInteger state = _taskInfo.state.integerValue;
//    
//    if (0 == state) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
//        
//        _btnConfirm = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 120, 20, 80, 30)];
//        
//        [_btnConfirm setTitle:@"确认" forState:UIControlStateNormal];
//        
//        [_btnConfirm setBackgroundColor:[Utils getColorByRGB:TITLE_COLOR]];
//        
//        [_btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        
//        _btnConfirm.titleLabel.font = [UIFont systemFontOfSize:13];
//        
//        _btnConfirm.layer.masksToBounds = YES;
//        
//        _btnConfirm.layer.cornerRadius = 5;
//        
//        [_btnConfirm addTarget:self action:@selector(confirmTask) forControlEvents:UIControlEventTouchUpInside];
//        
//        [view addSubview:_btnConfirm];
//        
//        _tableView.tableFooterView = view;
//        
//    } else if (2 == state) {
//        EvaluteView *view = [EvaluteView viewFromNib];
//        
//        view.delegate = self;
//        
//        _tableView.tableFooterView = view;
//        
//    } else if (3 == state) {
//        EvaluteView *view = [EvaluteView viewFromNib];
//        
//        _tableView.tableFooterView = view;
//        
//        [view setModeShow];
//        
//        [view setStar:_taskInfo.evaluateResult];
//        
//        [view setContent:_taskInfo.evaluateContent];
//    }
}

//- (void)confirmTask
//{
//    MainTaskConfirmRequest *request = [[MainTaskConfirmRequest alloc] init];
//    
//    request.maintOrderPorcessId = _taskInfo.taskId;
//    
//    [[HttpClient shareClient]post:URL_CONFIRM_MAIN_TASK parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
//        [HUDClass showHUDWithText:@"维保任务确认成功"];
//        
//        [_btnConfirm removeFromSuperview];
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
//        
//    }];
//}

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
    
    [cell markOnMapWithLat:lat lng:lng];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MainTaskDetailCell cellHeight];
}

//#pragma mark - EvaluateViewDelegate
//
//- (void)onSubmit:(NSInteger)star content:(NSString *)content
//{
//    MainTaskEvaluateRequest *request = [[MainTaskEvaluateRequest alloc] init];
//    request.maintOrderProcessId = _taskInfo.taskId;
//    request.evaluateContent = content;
//    request.evaluateResult = star;
//    
//    [[HttpClient shareClient] post:URL_MAIN_TASK_EVALUATE parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
//        [HUDClass showHUDWithText:@"维保评价成功"];
//        
//        [self performSelector:@selector(back) withObject:nil afterDelay:1.0f];
//    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
//        
//    }];
//}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
