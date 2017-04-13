//
//  MainTaskInfo.h
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MainTaskInfo_h
#define MainTaskInfo_h

#import <Jastor.h>
#import "MainOrderInfo.h"
#import "MainWorkerInfo.h"

@interface MainTaskInfo : Jastor

@property (copy, nonatomic) NSString *taskId;

@property (copy, nonatomic) NSString *isPay;

@property (copy, nonatomic) NSString *maintUserId;

@property (copy, nonatomic) NSString *planTime;

//0待确认 1已确认 2已完成 3已评价
@property (copy, nonatomic) NSString *state;

@property (copy, nonatomic) NSString *taskCode;

@property (copy, nonatomic) NSString *evaluateContent;

@property (assign, nonatomic) NSInteger evaluateResult;

@property (strong, nonatomic) MainOrderInfo *maintOrderInfo;

@property (strong, nonatomic) MainWorkerInfo *maintUserInfo;

@end


#endif /* MainTaskInfo_h */
