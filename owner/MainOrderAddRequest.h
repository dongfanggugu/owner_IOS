//
//  MainOrderAddRequest.h
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MainOrderAddRequest_h
#define MainOrderAddRequest_h

#import "Request.h"

@interface MainOrderAddRequest : Request

@property (copy, nonatomic) NSString *tel;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *sex;

@property (copy, nonatomic) NSString *brand;

@property (copy, nonatomic) NSString *model;

@property (copy, nonatomic) NSString *cellName;

@property (copy, nonatomic) NSString *address;

@property (copy, nonatomic) NSString *loginname;

@property (copy, nonatomic) NSString *mainttypeId;

@property (assign, nonatomic) NSInteger frequency;

//增值服务订单使用
@property (copy, nonatomic) NSString *incrementTypeId;

@end

#endif /* MainOrderAddRequest_h */
