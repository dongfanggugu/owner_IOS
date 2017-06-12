//
// Created by changhaozhang on 2017/6/12.
// Copyright (c) 2017 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "RepairOrderConfirmNoPayCell.h"


@implementation RepairOrderConfirmNoPayCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RepairOrderConfirmNoPayCell" owner:nil options:nil];

    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

+ (CGFloat)cellHeight
{
    return 550;
}

+ (NSString *)identifier
{
    return @"repair_order_confirm_no_pay_cell";
}


- (void)awakeFromNib
{
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _btnSubmit.layer.masksToBounds = YES;

    _btnSubmit.layer.cornerRadius = 5;


    [_btnAgreement addTarget:self action:@selector(clickAgreement) forControlEvents:UIControlEventTouchUpInside];


    [_btnSubmit addTarget:self action:@selector(clickSubmit) forControlEvents:UIControlEventTouchUpInside];
}


- (void)clickSubmit
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickSubmit)])
    {
        [_delegate onClickSubmit];
    }
}

/**
 三方协议
 */
- (void)clickAgreement
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickAgreement)])
    {
        [_delegate onClickAgreement];
    }
}



@end