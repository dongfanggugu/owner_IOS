//
//  HUDClass.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HUDClass.h"

@interface HUDClass()

@end

@implementation HUDClass

+ (void)showHUDWithLabel:(NSString *)content view:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.0f;
    hud.removeFromSuperViewOnHide = YES;
    
    hud.labelText = content;
    [hud hide:YES afterDelay:2.0f];
}

+ (MBProgressHUD *)showLoadingHUD:(UIView *)view
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    
    hud.minSize = CGSizeMake(80.0f, 80.0f);
    hud.removeFromSuperViewOnHide = YES;
    [view addSubview:hud];
    [hud show:YES];
    
    return hud;
}

+ (void)hideLoadingHUD:(MBProgressHUD *)hud
{
    if ([hud superview])
    {
        [hud hide:YES];
    }
}

@end
