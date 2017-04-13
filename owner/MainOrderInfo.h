//
//  MainOrderInfo.h
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MainOrderInfo_h
#define MainOrderInfo_h

#import <Jastor.h>

@interface MainOrderInfo : Jastor

@property (copy, nonatomic) NSString *code;

@property (copy, nonatomic) NSString *createTime;

@property (copy, nonatomic) NSString *orderId;

@property (copy, nonatomic) NSString *isPay;

@property (copy, nonatomic) NSString *mainttypeId;

@property (copy, nonatomic) NSString *maintypeName;

@property (assign, nonatomic) CGFloat price;

@end


#endif /* MainOrderInfo_h */
