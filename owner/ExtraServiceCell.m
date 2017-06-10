//
//  ExtraServiceCell.m
//  owner
//
//  Created by 长浩 张 on 2017/5/5.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "ExtraServiceCell.h"

@interface ExtraServiceCell ()

@property (weak, nonatomic) IBOutlet UIButton *btnDetail;

@property (weak, nonatomic) IBOutlet UIButton *btnPay;

@property (weak, nonatomic) IBOutlet UIButton *btnLink;

@property (weak, nonatomic) IBOutlet UIButton *btnOrder;

@property (strong, nonatomic) void (^onClickDetail)();

@property (strong, nonatomic) void (^onClickPay)();

@property (strong, nonatomic) void (^onClickLink)();

@property (strong, nonatomic) void (^onClickOrder)();


@end

@implementation ExtraServiceCell


+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ExtraServiceCell" owner:nil options:nil];

    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

+ (CGFloat)cellHeight
{
    return 160;
}

+ (NSString *)identifier
{
    return @"extra_service_cell";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    _btnOrder.layer.masksToBounds = YES;
    _btnOrder.layer.cornerRadius = 5;
}


- (void)addOnClickDetailListener:(void (^)())onClickDetail
{
    _onClickDetail = onClickDetail;

    [_btnDetail addTarget:self action:@selector(clickDetail) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickDetail
{
    if (_onClickDetail)
    {
        _onClickDetail();
    }
}

- (void)addOnClickPayListener:(void (^)())onClickPay
{
    _onClickPay = onClickPay;

    [_btnPay addTarget:self action:@selector(clickPay) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickPay
{
    if (_onClickPay)
    {
        _onClickPay();
    }
}

- (void)addOnClickLinkListener:(void (^)())onClickLink
{
    _onClickLink = onClickLink;

    [_btnLink addTarget:self action:@selector(clickLink) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickLink
{
    if (_onClickLink)
    {
        _onClickLink();
    }
}

- (void)addOnClickOrderListener:(void (^)())onClickOrder
{
    _onClickOrder = onClickOrder;

    [_btnOrder addTarget:self action:@selector(clickOrder) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickOrder
{
    if (_onClickOrder)
    {
        _onClickOrder();
    }
}

@end
