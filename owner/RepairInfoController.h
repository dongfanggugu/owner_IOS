//
//  RepairInfoController.h
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RepairInfoController_h
#define RepairInfoController_h

#import "BaseViewController.h"
#import "RepairOrderInfo.h"

@interface RepairInfoController : BaseViewController

@property (strong, nonatomic) RepairOrderInfo *orderInfo;

@property (strong, nonatomic) NSDictionary *houseInfo;

@end


#endif /* RepairInfoController_h */
