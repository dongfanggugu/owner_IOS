//
//  EvaluateController.h
//  owner
//
//  Created by 长浩 张 on 2017/5/27.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, EnterType) {
    Maint_Submit,
    Repair_Submit,
    Show
};

@class MainTaskInfo;

@class RepairOrderInfo;

@interface EvaluateController : BaseViewController

@property (strong, nonatomic) MainTaskInfo *mainTaskInfo;;

@property (strong, nonatomic) RepairOrderInfo *repairOrderInfo;

@property (copy, nonatomic) NSString *content;

@property (assign, nonatomic) NSInteger star;

@property (assign, nonatomic) EnterType enterType;


@end
