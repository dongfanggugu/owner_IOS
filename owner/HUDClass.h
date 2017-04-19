//
//  HUDClass.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef HUDClass_h
#define HUDClass_h

#import "MBProgressHUD.h"

@interface HUDClass: NSObject


/**
 显示提示内容
 **/
+ (void)showHUDWithText:(NSString *)text;

/**
 loading视图
 **/
+ (MBProgressHUD *)showLoadingHUD;

/**
 隐藏loading视图
 **/
+ (void)hideLoadingHUD:(MBProgressHUD *)hud;

@end


#endif /* HUDClass_h */
