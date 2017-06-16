//
//  RepairTaskInfo.h
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RepairTaskInfo_h
#define RepairTaskInfo_h

#import <Jastor.h>

@interface RepairTaskInfo : Jastor

@property (copy, nonatomic) NSString *taskId;

@property (copy, nonatomic) NSString *repairOrderId;

@property (copy, nonatomic) NSString *workerId;

@property (copy, nonatomic) NSString *workerName;

@property (copy, nonatomic) NSString *workerTel;

@property (copy, nonatomic) NSString *startTime;

@property (copy, nonatomic) NSString *arriveTime;

@property (copy, nonatomic) NSString *completeTime;

@property (copy, nonatomic) NSString *createTime;

@property (copy, nonatomic) NSString *finishResult;

@property (copy, nonatomic) NSString *pictures;

//1待出发 2已出发 3已到达 5检修完成 6维修完成
@property (copy, nonatomic) NSString *state;

@property (copy, nonatomic) NSString *code;

@property (copy, nonatomic) NSString *phenomenon;

@property (copy, nonatomic) NSString *repairTypeName;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *tel;

@property (copy, nonatomic) NSString *address;

@property (copy, nonatomic) NSString *brand;

@end


#endif /* RepairTaskInfo_h */
