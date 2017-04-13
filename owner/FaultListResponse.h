//
//  FaultListResponse.h
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef FaultListResponse_h
#define FaultListResponse_h

#import "ResponseArray.h"
#import "FaultInfo.h"

@interface FaultListResponse : ResponseArray

- (NSArray<FaultInfo *> *)getFaultList;

@end

#endif /* FaultListResponse_h */
