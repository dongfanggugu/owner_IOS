//
//  RepairTaskResponse.h
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RepairTaskResponse_h
#define RepairTaskResponse_h

#import "ResponseArray.h"
#import "RepairTaskInfo.h"

@interface RepairTaskResponse : ResponseArray

- (NSArray<RepairTaskInfo *> *)getTaskList;

@end

#endif /* RepairTaskResponse_h */
