//
//  SMSCodeResponse.m
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMSCodeResponse.h"

@implementation SMSCodeResponse

- (NSString *)getSMSCode
{
    return [self.body objectForKey:@"code"];
}

@end
