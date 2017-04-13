//
//  ElevatorBrandInfo.h
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef ElevatorBrandInfo_h
#define ElevatorBrandInfo_h

#import <Jastor.h>
#import "ListDialogView.h"

@interface ElevatorBrandInfo : Jastor<ListDialogDataDelegate>

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *value;

@end


#endif /* ElevatorBrandInfo_h */
