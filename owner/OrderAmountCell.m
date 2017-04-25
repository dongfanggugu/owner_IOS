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

@end

@implementation OrderAmountCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderAmountCell" owner:nil options:nil];
    
    if (0 == array.count) {
        return nil;
    }
    
    return array[0];
}

+ (NSString *)identifier
{
    return @"order_amount_cell";
}

+ (CGFloat)cellHeight
{
    return 44;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [_btnAdd addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnMinus addTarget:self action:@selector(minus) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)amount
{
    return _amount;
}

- (void)add
{
    self.amount = [_lbAmount.text integerValue];
    self.amount++;
    
    self.lbAmount.text = [NSString stringWithFormat:@"%ld", self.amount];
    
    NSLog(@"amount:%ld", self.amount);
}

- (void)minus
{
    self.amount = [_lbAmount.text integerValue];
    if (1 == self.amount) {
        return;
    }
    
    self.amount--;
    
    self.lbAmount.text = [NSString stringWithFormat:@"%ld", self.amount];
    
    NSLog(@"amount:%ld", self.amount);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
