//
//  OrderAmountCell.m
//  owner
//
//  Created by 长浩 张 on 2017/4/25.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "OrderAmountCell.h"

@interface OrderAmountCell ()

@property (weak, nonatomic) IBOutlet UIButton *btnMinus;

@property (weak, nonatomic) IBOutlet UIButton *btnAdd;

@property (weak, nonatomic) IBOutlet UILabel *lbAmount;

@property (weak, nonatomic) IBOutlet UILabel *lbTotal;

@end

@implementation OrderAmountCell

+ (id)cellFromNib {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderAmountCell" owner:nil options:nil];

    if (0 == array.count) {
        return nil;
    }

    return array[0];
}

+ (NSString *)identifier {
    return @"order_amount_cell";
}

+ (CGFloat)cellHeight {
    return 44;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [_btnAdd addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];

    [_btnMinus addTarget:self action:@selector(minus) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)amount {
    if (_amount <= 0) {
        _amount = 1;
    }
    return _amount;
}

- (void)setPrice:(CGFloat)price {
    if (price <= 0) {
        return;
    }

    _price = price;

    CGFloat total = _price * self.amount;

    self.lbTotal.text = [NSString stringWithFormat:@"￥%.2lf", total];
}

- (void)add {
    //self.amount = [_lbAmount.text integerValue];
    self.amount++;

    self.lbAmount.text = [NSString stringWithFormat:@"%ld", self.amount];

    if (0 == self.price) {
        self.lbTotal.text = @"";
        return;
    }

    CGFloat total = _price * self.amount;

    self.lbTotal.text = [NSString stringWithFormat:@"￥%.2lf", total];

}

- (void)minus {
    self.amount = [_lbAmount.text integerValue];
    if (1 == self.amount) {
        return;
    }

    self.amount--;

    self.lbAmount.text = [NSString stringWithFormat:@"%ld", self.amount];

    if (0 == self.price) {
        self.lbTotal.text = @"";
        return;
    }

    CGFloat total = self.price * self.amount;

    self.lbTotal.text = [NSString stringWithFormat:@"￥%.2lf", total];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
