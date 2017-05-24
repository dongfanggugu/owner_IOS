//
//  HouseChangeView.m
//  owner
//
//  Created by 长浩 张 on 2017/5/24.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "HouseChangeView.h"

@interface HouseChangeView ()

@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation HouseChangeView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HouseChangeView" owner:nil options:nil];
    
    if (0 == array.count) {
        return nil;
    }
    
    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _btn.layer.masksToBounds = YES;
    _btn.layer.cornerRadius = 5;
    
    [_btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickBtn
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickBtn:)]) {
        [_delegate onClickBtn:self];
    }
}

@end
