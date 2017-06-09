//
//  MainTaskInfo.m
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainTaskInfo.h"

@implementation MainTaskInfo

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];

    if (self) {
        self.taskId = dictionary[@"id"];

        self.maintOrderInfo = [[MainOrderInfo alloc] initWithDictionary:dictionary[@"maintOrderInfo"]];

        self.maintUserInfo = [[MainWorkerInfo alloc] initWithDictionary:dictionary[@"maintUserInfo"]];
    }

    return self;
}

@end
