//
//  RepairListResponse.m
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RepairListResponse.h"

@implementation RepairListResponse

+ (Class)body_class
{
    return [RepairOrderInfo class];
}

- (NSArray<RepairOrderInfo *> *)getOrderList
{
    return (NSArray<RepairOrderInfo *> *)self.body;
}

@end
