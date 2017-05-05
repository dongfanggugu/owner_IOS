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

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UIButton *btnDetail;

@property (weak, nonatomic) IBOutlet UIView *viewBg;

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
    return 140;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
        
    [self.viewBg layoutIfNeeded];
    
    [self.viewBg clipCornerWithTopLeft:YES andTopRight:YES andBottomLeft:NO andBottomRight:NO];
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setImage:(UIImage *)image
{
    imageView.image = image;
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
    
    [_btnDetail addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
}

@end
