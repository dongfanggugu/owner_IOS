//
//  SMSCodeRequest.h
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SMSCodeRequest_h
#define SMSCodeRequest_h

#import "Request.h"

@interface SMSCodeRequest : Request

@property (copy, nonatomic) NSString *tel;

@end


#endif /* SMSCodeRequest_h */
