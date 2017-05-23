//
//  MainOrderController.h
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MainOrderController_h
#define MainOrderController_h


#import "BaseViewController.h"
@class MainTypeInfo;


@interface MainOrderController : BaseViewController

@property (strong, nonatomic) MainTypeInfo *mainInfo;

@property (strong, nonatomic) NSDictionary *houseInfo;

@end

#endif /* MainOrderController_h */
