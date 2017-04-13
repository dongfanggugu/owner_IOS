//
//  MainTaskListResponse.h
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MainTaskListResponse_h
#define MainTaskListResponse_h

#import "ResponseArray.h"
#import "MainTaskInfo.h"

@interface MainTaskListResponse : ResponseArray

- (NSArray<MainTaskInfo *> *)getTaskList;

@end

#endif /* MainTaskListResponse_h */
