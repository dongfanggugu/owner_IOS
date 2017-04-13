//
//  RepairEvaluateRequest.h
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RepairEvaluateRequest_h
#define RepairEvaluateRequest_h

#import "Request.h"

@interface RepairEvaluateRequest : Request

@property (copy, nonatomic) NSString *repairOrderId;

@property (copy, nonatomic) NSString *evaluate;

@property (copy, nonatomic) NSString *evaluateInfo;

@end


#endif /* RepairEvaluateRequest_h */
