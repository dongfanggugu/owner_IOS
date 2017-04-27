//
//  PayInfoCellTableViewCell.m
//  owner
//
//  Created by 长浩 张 on 2017/4/27.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "PayInfoCell.h"


@interface PayInfoCell ()

@property (strong, nonatomic) void (^onClickPay) ();

@property (weak, nonatomic) IBOutlet UIButton *btnPay;

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
    return 153;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _btnPay.layer.masksToBounds = YES;
    
    _btnPay.layer.cornerRadius = 5;
}

- (void)addOnPayClickListener:(void(^)())onClickPay
{
    _onClickPay = onClickPay;
    
    [_btnPay addTarget:self action:@selector(clickPay) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickPay
{
    if (_onClickPay) {
        _onClickPay();
    }
}

- (void)setPayHiden:(BOOL)payHiden
{
    if (payHiden) {
        self.btnPay.hidden = YES;
    
    } else {
        self.btnPay.hidden = NO;
    
    }
}


@end
