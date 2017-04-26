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

@property (weak, nonatomic) IBOutlet UIButton *btn;

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
    
    _btn.layer.masksToBounds = YES;
    _btn.layer.cornerRadius = 5;
    
    [_btn addTarget:self action:@selector(onClickButton) forControlEvents:UIControlEventTouchUpInside];
}


- (void)onClickButton
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickButton)]) {
        [_delegate onClickButton];
    }
}

@end
