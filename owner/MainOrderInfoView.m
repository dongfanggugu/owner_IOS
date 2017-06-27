//
//  MainOrderInfoView.m
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainOrderInfoView.h"

@interface MainOrderInfoView ()

@property (weak, nonatomic) IBOutlet UIButton *btnDetail;

@property (weak, nonatomic) IBOutlet UIButton *btnPay;

@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@property (weak, nonatomic) IBOutlet UIButton *btnOrder;

@property (weak, nonatomic) IBOutlet UIView *viewBottom;


@end

@implementation MainOrderInfoView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MainOrderInfoView" owner:nil options:nil];

    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    _btnOrder.layer.masksToBounds = YES;
    _btnOrder.layer.cornerRadius = 5;

    [_btnPay addTarget:self action:@selector(onClickPay) forControlEvents:UIControlEventTouchUpInside];

    [_btnBack addTarget:self action:@selector(onClickBack) forControlEvents:UIControlEventTouchUpInside];

    [_btnOrder addTarget:self action:@selector(onClickOrder) forControlEvents:UIControlEventTouchUpInside];

    [_btnDetail addTarget:self action:@selector(onClickDetail) forControlEvents:UIControlEventTouchUpInside];

    [_btnChange addTarget:self action:@selector(onClickChange) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)onClickPay
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickPayButton:)])
    {
        [_delegate onClickPayButton:self];
    }
}

- (void)onClickDetail
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickDetailButton:)])
    {
        [_delegate onClickDetailButton:self];
    }
}

- (void)onClickOrder
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickOrderButton:)])
    {
        [_delegate onClickOrderButton:self];
    }
}

- (void)onClickBack
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickBackButton:)])
    {
        [_delegate onClickBackButton:self];
    }
}

- (void)onClickChange
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickChangeButton:)])
    {
        [_delegate onClickChangeButton:self];
    }
}

- (void)setViewHidden:(BOOL)viewHidden
{
    _viewHidden = viewHidden;
    if (viewHidden)
    {
        _viewBottom.hidden = YES;

    }
    else
    {
        _viewBottom.hidden = NO;
    }
}

@end
