//
//  OrderListRequest.h
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef OrderListRequest_h
#define OrderListRequest_h

#import "Request.h"

@interface OrderListRequest : Request

@property (assign, nonatomic) NSInteger page;

@property (assign, nonatomic) NSInteger rows;

@end


#endif /* OrderListRequest_h */
