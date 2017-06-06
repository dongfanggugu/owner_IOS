//
//  RepairOrderInfo.h
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RepairOrderInfo_h
#define RepairOrderInfo_h


#import <Jastor.h>

@interface RepairOrderInfo : Jastor

@property (copy, nonatomic) NSString *orderId;

@property (copy, nonatomic) NSString *phenomenon;

@property (copy, nonatomic) NSString *picture;

//保修时间
@property (copy, nonatomic) NSString *createTime;

@property (copy, nonatomic) NSString *repairTime;

//1待确认 2已确认 4已委派 6维修中 7支付单生成 8维修完成 9已评价
@property (copy, nonatomic) NSString *state;

@property (copy, nonatomic) NSString *smallOwnerId;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *tel;

@property (copy, nonatomic) NSString *address;

@property (copy, nonatomic) NSString *brand;

@property (copy, nonatomic) NSString *isPayment;

@property (copy, nonatomic) NSString *payTime;

@property (copy, nonatomic) NSString *evaluate;

@property (copy, nonatomic) NSString *evaluateInfo;

@property (copy, nonatomic) NSString *code;

@property (copy, nonatomic) NSString *repairTypeId;

@property (copy, nonatomic) NSString *repairTypeName;

@property (strong, nonatomic) NSDictionary *repairTypeInfo;

@end


#endif /* RepairOrderInfo_h */
