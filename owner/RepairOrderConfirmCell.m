//
//  RepairOrderConfirmCell.m
//  owner
//
//  Created by 长浩 张 on 2017/6/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "RepairOrderConfirmCell.h"

@implementation RepairOrderConfirmCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RepairOrderConfirmCell" owner:nil options:nil];
    
    if (0 == array.count) {
        return nil;
    }
    
    return array[0];
}

+ (CGFloat)cellHeight
{
    return 500;
}

+ (NSString *)identifier
{
    return @"repair_order_confirm_cell";
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _btnPay.layer.masksToBounds = YES;
    
    _btnPay.layer.cornerRadius = 5;
    
    _lbCom1.userInteractionEnabled = YES;
    
    _lbCom2.userInteractionEnabled = YES;
    
    _lbCom3.userInteractionEnabled = YES;
    
    [_lbCom1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selCom1)]];
    
    [_lbCom2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selCom2)]];
    
    [_lbCom3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selCom3)]];
    
    
    [_btnAgreement addTarget:self action:@selector(clickAgreement) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnMoreCom addTarget:self action:@selector(clickMoreCom) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnPay addTarget:self action:@selector(clickPay) forControlEvents:UIControlEventTouchUpInside];
}


- (void)clickPay
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickPay)]) {
        [_delegate onClickPay];
    }
}

/**
 更多维保公司
 */
- (void)clickMoreCom
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickMoreCompany)]) {
        [_delegate onClickMoreCompany];
    }
}

/**
 三方协议
 */
- (void)clickAgreement
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickAgreement)]) {
        [_delegate onClickAgreement];
    }
}


/**
 选择公司1
 */
- (void)selCom1
{
    [self selCom:0];
    if (_delegate && [_delegate respondsToSelector:@selector(onChooseCompany:name:)]) {
        [_delegate onChooseCompany:0 name:_lbCom1.text];
    }
}


/**
 选择公司2
 */
- (void)selCom2
{
    [self selCom:1];
    
    if (_delegate && [_delegate respondsToSelector:@selector(onChooseCompany:name:)]) {
        [_delegate onChooseCompany:1 name:_lbCom2.text];
    }
}


/**
 选择公司3
 */
- (void)selCom3
{
    [self selCom:2];
    
    if (_delegate && [_delegate respondsToSelector:@selector(onChooseCompany:name:)]) {
        [_delegate onChooseCompany:2 name:_lbCom3.text];
    }
}


/**
 重置公司选择
 */
- (void)resetSel
{
    _lbCom1.textColor = [UIColor blackColor];
    
    _lbCom2.textColor = [UIColor blackColor];
    
    _lbCom3.textColor = [UIColor blackColor];
    
    _lbCompany.text = @"";
    
}


/**
 选择公司
 
 @param index 公司的排序
 */
- (void)selCom:(NSInteger)index
{
    [self resetSel];
    
    switch (index) {
        case 0:
            _lbCom1.textColor = [Utils getColorByRGB:@"#F5645F"];
            _lbCompany.text = _lbCom1.text;
            break;
            
        case 1:
            _lbCom2.textColor = [Utils getColorByRGB:@"#F5645F"];
            _lbCompany.text = _lbCom2.text;
            break;
        case 2:
            _lbCom3.textColor = [Utils getColorByRGB:@"#F5645F"];
            _lbCompany.text = _lbCom3.text;
            break;
            
        default:
            break;
    }
    
}


@end
