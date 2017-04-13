//
//  BrandListResponse.h
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef BrandListResponse_h
#define BrandListResponse_h

#import "ResponseArray.h"
#import "ElevatorBrandInfo.h"

@interface BrandListResponse : ResponseArray

- (NSArray<ElevatorBrandInfo *> *)getBrandList;

@end



#endif /* BrandListResponse_h */
