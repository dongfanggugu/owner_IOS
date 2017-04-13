//
//  AppReportController.m
//  owner
//
//  Created by 长浩 张 on 2017/1/12.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppReportController.h"

@interface AppReportController()

@property (weak, nonatomic) IBOutlet UITextView *tvContent;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@end

@implementation AppReportController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"电梯故障报修"];
    [self initView];
}

- (void)initView
{
    _tvContent.layer.masksToBounds = YES;
    _tvContent.layer.cornerRadius = 5;
    
    _tvContent.layer.borderWidth = 1;
    _tvContent.layer.borderColor = [Utils getColorByRGB:TITLE_COLOR].CGColor;
    
    _btnSubmit.layer.masksToBounds = YES;
    _btnSubmit.layer.cornerRadius = 5;
    
    _btnSubmit.userInteractionEnabled = YES;
    [_btnSubmit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)submit
{
    NSString *content = _tvContent.text;
    if (0 == content.length)
    {
        [HUDClass showHUDWithLabel:@"请先填写电梯故障描述" view:self.view];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"communityId"] = _projectId;
    params[@"type"] = @"2";
    params[@"phenomenon"] = content;
    [[HttpClient shareClient] view:self.view post:@"addRepair" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithLabel:@"电梯报修成功,客服人员稍后会联系您,请保持手机畅通" view:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];

}

@end
