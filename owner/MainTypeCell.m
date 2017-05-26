//
//  MainTypeCell.m
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainTypeCell.h"
#import "UIView+CornerRadius.h"

@interface MainTypeCell()
{
    void(^_onClickBtn)();
}

@end


@implementation MainTypeCell

@synthesize imageView;

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MainTypeCell" owner:nil options:nil];
    
    if (0 == array.count) {
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
    return 240;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _iv1.userInteractionEnabled = YES;
    
    [_iv1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click1)]];
    
    _iv2.userInteractionEnabled = YES;
    
    [_iv2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click2)]];
    
    _iv3.userInteractionEnabled = YES;
    
    [_iv3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click3)]];
    
    _iv4.userInteractionEnabled = YES;
    
    [_iv4 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click4)]];
    
    _iv5.userInteractionEnabled = YES;
    
    [_iv5 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click5)]];
}

- (void)click1
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClick1)]) {
        [_delegate onClick1];
    }
}

- (void)click2
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClick2)]) {
        [_delegate onClick2];
    }
}

- (void)click3
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClick3)]) {
        [_delegate onClick3];
    }
}

- (void)click4
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClick4)]) {
        [_delegate onClick4];
    }
}

- (void)click5
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClick5)]) {
        [_delegate onClick5];
    }
}


@end
