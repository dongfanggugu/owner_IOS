//
//  CouponCell.m
//  owner
//
//  Created by 长浩 张 on 2017/6/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "CouponCell.h"

@implementation CouponCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CouponCell" owner:nil options:nil];

    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

+ (CGFloat)cellHeight
{
    return 140;
}


+ (NSString *)identifier
{
    return @"coupon_cell";
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _tfAmount.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    _tfAmount.userInteractionEnabled = NO;

    _tvZone.userInteractionEnabled = NO;

}

@end
