//
//  MainTypeCell.m
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainTypeCell.h"

@interface MainTypeCell()
{
    void(^_onClickBtn)();
}

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UIButton *btnInner;

@end

@implementation MainTypeCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MainTypeCell" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

+ (NSString *)identifier
{
    return @"main_type_cell";
}

+ (CGFloat)cellHeight
{
    return 108;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _btnInner.userInteractionEnabled = NO;
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
