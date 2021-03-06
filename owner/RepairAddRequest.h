//
//  RepairAddRequest.h
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RepairAddRequest_h
#define RepairAddRequest_h

#import "Request.h"

@interface RepairAddRequest : Request

@property (copy, nonatomic) NSString *tel;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *brand;

@property (copy, nonatomic) NSString *model;

@property (copy, nonatomic) NSString *cellName;

@property (copy, nonatomic) NSString *address;

@property (copy, nonatomic) NSString *loginname;

@property (copy, nonatomic) NSString *repairTypeId;

@property (copy, nonatomic) NSString *phenomenon;

@property (copy, nonatomic) NSString *repairTime;

@property (copy, nonatomic) NSString *contacts;

@property (copy, nonatomic) NSString *contactsTel;

@property (assign, nonatomic) CGFloat lat;

@property (assign, nonatomic) CGFloat lng;

@property (copy, nonatomic) NSString *villaId;

@property (assign, nonatomic) CGFloat weight;

@property (assign, nonatomic) NSInteger layerAmount;

@property (copy, nonatomic) NSString *url;

//红包id
@property (copy, nonatomic) NSString *couponRecordId;

//是否需要支付, 0 不需要 1 需要支付
@property (copy, nonatomic) NSString *type;

//维保公司id
@property (copy, nonatomic) NSString *branchId;

@end


#endif /* RepairAddRequest_h */
