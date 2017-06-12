//
//  CouponCell.h
//  owner
//
//  Created by 长浩 张 on 2017/6/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponCell : UITableViewCell

+ (id)cellFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;

@property (weak, nonatomic) IBOutlet UILabel *lbDes;

@property (weak, nonatomic) IBOutlet UILabel *lbDeadTime;

@property (weak, nonatomic) IBOutlet UITextView *tvZone;

@property (weak, nonatomic) IBOutlet UILabel *lbAmount;

@property (weak, nonatomic) IBOutlet UIImageView *ivBg;

@end
