//
//  MainOrderInfo.m
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainOrderInfo.h"
#import "MainTypeInfo.h"

@implementation MainOrderInfo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];

    if (self)
    {
        self.orderId = dictionary[@"id"];
        self.maintypeInfo = [[MainTypeInfo alloc] initWithDictionary:dictionary[@"mainttypeInfo"]];
    }

    return self;
}

@end
