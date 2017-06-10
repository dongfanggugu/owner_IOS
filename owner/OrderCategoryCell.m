//
// Created by changhaozhang on 2017/6/10.
// Copyright (c) 2017 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "OrderCategoryCell.h"


@implementation OrderCategoryCell
{

}


+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderCategoryCell" owner:nil options:nil];
    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

+ (CGFloat)cellHeight
{
    return 66;
}

+ (NSString *)identifier
{
    return @"order_category_cell";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end