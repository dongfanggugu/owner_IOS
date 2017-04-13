//
//  MainTaskEvaluateRequest.h
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MainTaskEvaluateRequest_h
#define MainTaskEvaluateRequest_h

#import "Request.h"

@interface MainTaskEvaluateRequest : Request

@property (copy, nonatomic) NSString *maintOrderProcessId;

@property (copy, nonatomic) NSString *evaluateContent;

@property (assign, nonatomic) CGFloat evaluateResult;

@end

#endif /* MainTaskEvaluateRequest_h */
