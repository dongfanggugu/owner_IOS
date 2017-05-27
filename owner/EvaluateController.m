//
//  EvaluateController.m
//  owner
//
//  Created by 长浩 张 on 2017/5/27.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "EvaluateController.h"
#import "EvaluateView.h"
#import "MainTaskEvaluateRequest.h"
#import "RepairEvaluateRequest.h"
#import "MainTaskInfo.h"
#import "RepairOrderInfo.h"


@interface EvaluateController () <EvaluateViewDelegate>

@property (strong, nonatomic) EvaluteView *evaluateView;

@end

@implementation EvaluateController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"用户评价"];
    [self initView];
}


- (void)initView
{
    _evaluateView = [EvaluteView viewFromNib];
    
    _evaluateView.frame = CGRectMake(0, 64, self.screenWidth, 300);
    
    _evaluateView.delegate = self;
    
    [self.view addSubview:_evaluateView];
    
    if (Show == _enterType) {
        [_evaluateView setModeShow];
        [_evaluateView setStar:_star];
        [_evaluateView setContent:_content];
    }
}

#pragma mark - EvaluateViewDelegate

- (void)onSubmit:(NSInteger)star content:(NSString *)content
{
    
    if (Maint_Submit == _enterType) {
        MainTaskEvaluateRequest *request = [[MainTaskEvaluateRequest alloc] init];
        request.maintOrderProcessId = _mainTaskInfo.taskId;
        request.evaluateContent = content;
        request.evaluateResult = star;
        
        [[HttpClient shareClient] post:URL_MAIN_TASK_EVALUATE parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
            [HUDClass showHUDWithText:@"维保评价成功"];
            _mainTaskInfo.evaluateContent = content;
            _mainTaskInfo.evaluateResult = star;
            _mainTaskInfo.state = @"3";
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask *task, NSError *errr) {
            
        }];
        
    } else {
        RepairEvaluateRequest *request = [[RepairEvaluateRequest alloc] init];
        request.repairOrderId = _repairOrderInfo.orderId;
        request.evaluateInfo = content;
        request.evaluate = [NSString stringWithFormat:@"%ld", star];
        
        [[HttpClient shareClient] post:URL_REPAIR_EVALUATE parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
            [HUDClass showHUDWithText:@"快修评价成功"];
            _repairOrderInfo.evaluateInfo = content;
            _repairOrderInfo.evaluate = [NSString stringWithFormat:@"%ld", star];
            _repairOrderInfo.state = @"9";
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask *task, NSError *errr) {
            
        }];
    }
   
}

@end
