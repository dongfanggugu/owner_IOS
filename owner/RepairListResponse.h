//
//  RepairListResponse.h
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RepairListResponse_h
#define RepairListResponse_h

#import "ResponseArray.h"
#import "RepairOrderInfo.h"

@interface RepairListResponse : ResponseArray

- (NSArray<RepairOrderInfo *> *)getOrderList;

@end


#endif /* RepairListResponse_h */
