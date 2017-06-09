//
//  MainTaskListResponse.m
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainTaskListResponse.h"

@implementation MainTaskListResponse

+ (Class)body_class {
    return [MainTaskInfo class];
}

- (NSArray<MainTaskInfo *> *)getTaskList {
    return (NSArray<MainTaskInfo *> *) self.body;
}

@end

