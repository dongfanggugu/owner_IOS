//
//  MainListResponse.h
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MainListResponse_h
#define MainListResponse_h

#import "ResponseArray.h"
#import "MainOrderInfo.h"

@interface MainListResponse : ResponseArray

- (NSArray<MainOrderInfo *> *)getOrderList;

@end


#endif /* MainListResponse_h */
