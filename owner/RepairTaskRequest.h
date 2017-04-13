//
//  RepairTaskRequest.h
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RepairTaskRequest_h
#define RepairTaskRequest_h


#import "Request.h"

@interface RepairTaskRequest : Request

@property (copy, nonatomic) NSString *repairOrderId;

@end

#endif /* RepairTaskRequest_h */
