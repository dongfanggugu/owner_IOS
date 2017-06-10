//
//  OrderInfoCell.m
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderInfoCell.h"

@implementation OrderInfoCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderInfoCell" owner:nil options:nil];

    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

+ (NSString *)identifier
{
    return @"order_info_cell";
}

+ (CGFloat)cellHeight
{
    return 66;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _lbIndex.layer.masksToBounds = YES;
    _lbIndex.layer.cornerRadius = 12;
}

@end
