//
//  PayInfoCellTableViewCell.m
//  owner
//
//  Created by 长浩 张 on 2017/4/27.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "PayInfoCell.h"


@interface PayInfoCell ()


@end

@implementation PayInfoCell

+ (instancetype)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PayInfoCell" owner:nil options:nil];
    
    if (0 == array.count) {
        return nil;
    }
    
    return array[0];
}

+ (NSString *)identifier
{
    return @"pay_info_cell";
}

+ (CGFloat)cellHeight
{
    return 75;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

@end
