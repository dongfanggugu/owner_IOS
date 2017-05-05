//
//  MainTypeInfo.h
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MainTypeInfo_h
#define MainTypeInfo_h

#import <Jastor.h>

@interface MainTypeInfo : Jastor

@property (copy, nonatomic) NSString *content;

@property (copy, nonatomic) NSString *createTime;

@property (copy, nonatomic) NSString *typeId;

@property (copy, nonatomic) NSString *name;

@property (assign, nonatomic) CGFloat price;

@property (copy, nonatomic) NSString *logo;

@end

#endif /* MainTypeInfo_h */
