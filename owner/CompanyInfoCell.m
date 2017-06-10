//
//  CompanyInfoCell.m
//  owner
//
//  Created by 长浩 张 on 2017/6/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "CompanyInfoCell.h"

@implementation CompanyInfoCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CompanyInfoCell" owner:nil options:nil];

    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

+ (CGFloat)cellHeight
{
    return 44;
}

+ (NSString *)identifier
{
    return @"company_info_cell";
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _lbIndex.layer.masksToBounds = YES;

    _lbIndex.layer.cornerRadius = 10;

    [_btnDetail addTarget:self action:@selector(clickDetail) forControlEvents:UIControlEventTouchUpInside];

}

- (void)clickDetail
{
    if (_onClickDetail)
    {
        _onClickDetail();
    }
}


@end
