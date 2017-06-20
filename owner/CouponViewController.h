//
//  CouponViewController.h
//  owner
//
//  Created by 长浩 张 on 2017/6/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "BaseViewController.h"

@protocol CouponViewControllerDelegate <NSObject>

- (void)onChooseCoupon:(NSDictionary *)couponInfo;

@end

@interface CouponViewController : BaseViewController

@property (assign, nonatomic) CGFloat payAmount;

@property (copy, nonatomic) NSString *branchId;

@property (weak, nonatomic) id <CouponViewControllerDelegate> delegate;

@end
