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


#pragma mark - 电梯商城

typedef NS_ENUM(NSInteger, Market_Type) {
    
    Market_Lift,  //整体销售
    
    Market_Decorate,  //电梯装潢
    
    Market_Msg  //留言
};


#pragma mark - 客服电话

#define Custom_Service @"400-919-6333"

#pragma mark - 定位字典

#define User_Location @"user_location"

#define User_Custom @"user_custom"

#define Custom_Location_Complete @"custom_location_complete"


#endif /* Constant_h */
