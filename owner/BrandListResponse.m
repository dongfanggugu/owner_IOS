//
//  BrandListResponse.m
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BrandListResponse.h"

@implementation BrandListResponse

+ (Class)body_class
{
    return [ElevatorBrandInfo class];
}

- (NSArray<ElevatorBrandInfo *> *)getBrandList
{
    return (NSArray<ElevatorBrandInfo *> *)self.body;
}

@end
