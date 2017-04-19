//
//  MainOrderInfoCell.m
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainOrderInfoCell.h"

@interface MainOrderInfoCell()
{
    void(^_onClickBtn)();
}

@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation MainOrderInfoCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MainOrderInfoCell" owner:nil options:nil];
    
    if (0 == array.count) {
        return nil;
    }
    
    return array[0];
}

+ (NSString *)identifier
{
    return @"main_order_info_cell";
}

+ (CGFloat)cellHeight
{
    return 66;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _btn.hidden = NO;
}

- (void)onClick
{
    if (_onClickBtn) {
        _onClickBtn();
    }
}

- (void)setOnClickListener:(void(^)())onClickBtn
{
    _onClickBtn = onClickBtn;
    
    [_btn addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
}

@end
