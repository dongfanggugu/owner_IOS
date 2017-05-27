//
//  RepairPaymentController.h
//  owner
//
//  Created by 长浩 张 on 2017/5/27.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, RepairPayEnterType) {
    Repair_Pay,
    Repair_Show
};

@interface RepairPaymentController : BaseViewController

@property (copy, nonatomic) NSString *orderId;

@property (copy, nonatomic) NSString *payTime;

@property (assign, nonatomic) RepairPayEnterType enterType;

@end
