//
//  FaultInfo.h
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef FaultInfo_h
#define FaultInfo_h

#import <Jastor.h>
#import "ListDialogView.h"

@interface FaultInfo : Jastor<ListDialogDataDelegate>

@property (copy, nonatomic) NSString *faultId;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *content;

@property (copy, nonatomic) NSString *createTime;

@end


#endif /* FaultInfo_h */
