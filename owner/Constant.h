//
//  Constant.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/14.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#define BM_APPKEY @"dCVibNZkuBKviK3EHO625E7C3GpPwg1C"

#define JPUSH_APPKEY @"47418d621c26447346a769b3"

#pragma mark - 维保服务类型

typedef NS_ENUM(NSInteger, Maint_Type) {
    
    Maint_Low = 1,  //单次服务
    
    Maint_Mid = 2,  //智能小管家
    
    Maint_High  //全能大管家
};

#endif /* Constant_h */
