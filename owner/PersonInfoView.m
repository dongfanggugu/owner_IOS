//
//  PersonInfoView.m
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonInfoView.h"

@implementation PersonInfoView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PersonInfoView" owner:nil options:nil];

    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView)]];
}

- (void)clickView
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickView)])
    {
        [_delegate onClickView];
    }
}
@end
