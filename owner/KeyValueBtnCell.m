//
//  KeyValueBtnCell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/1.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyValueBtnCell.h"

@interface KeyValueBtnCell ()
{
    void(^_onClick)();
}

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;

@end


@implementation KeyValueBtnCell


+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"KeyValueBtnCell" owner:nil options:nil];

    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

+ (CGFloat)cellHeight
{
    return 44;
}

+ (NSString *)identifier
{
    return @"key_value_btn_cell";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _btn.layer.masksToBounds = YES;
    _btn.layer.cornerRadius = 5;
}

- (void)addOnClickListener:(void (^)())onClick
{
    _onClick = onClick;

    [_btn addTarget:self action:@selector(onClickBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClickBtn
{
    if (_onClick)
    {
        _onClick();
    }
}

- (void)setBtnTitle:(NSString *)btnTitle
{
    [_btn setTitle:btnTitle forState:UIControlStateNormal];
}

- (void)hideBtn
{
    // _btn.hidden = YES;

    _btnWidth.constant = 0;
}

@end
