//
//  MainTypeListResponse.h
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MainTypeListResponse_h
#define MainTypeListResponse_h

#import "ResponseArray.h"
#import "MainTypeInfo.h"

@interface MainTypeListResponse : ResponseArray

- (NSArray<MainTypeInfo *> *)getMainTypeList;

@end


#endif /* MainTypeListResponse_h */
