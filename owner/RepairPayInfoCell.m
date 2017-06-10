//
//  RepairPayInfoCell.m
//  owner
//
//  Created by 长浩 张 on 2017/5/27.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "RepairPayInfoCell.h"

@implementation RepairPayInfoCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RepairPayInfoCell" owner:nil options:nil];

    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

+ (CGFloat)cellHeight
{
    return 50;
}

+ (NSString *)identifier
{
    return @"repair_pay_info_cell";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
