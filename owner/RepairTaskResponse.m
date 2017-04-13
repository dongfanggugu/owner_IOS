//
//  RepairTaskResponse.m
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RepairTaskResponse.h"

@implementation RepairTaskResponse

+ (Class)body_class
{
    return [RepairTaskInfo class];
}

- (NSArray<RepairTaskInfo *> *)getTaskList
{
    return (NSArray<RepairTaskInfo *> *)self.body;
}

@end
