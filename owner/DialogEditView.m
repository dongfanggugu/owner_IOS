//
//  DialogEditView.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/1.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DialogEditView.h"

@interface DialogEditView ()

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@property (weak, nonatomic) IBOutlet UIButton *btnOK;

@property (strong, nonatomic) void (^onClickOk)(NSString *);

@property (strong, nonatomic) void (^onClickCancel)();

@end

@implementation DialogEditView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DialogEditView" owner:nil options:nil];

    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];

}

- (void)addOnClickOkListener:(void (^)(NSString *))onClickOk
{
    _onClickOk = onClickOk;

    [_btnOK addTarget:self action:@selector(clickOK) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addOnClickCancelListener:(void (^)())onClickCancel
{
    _onClickCancel = onClickCancel;

    [_btnCancel addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickOK
{
    if (_onClickOk)
    {
        _onClickOk(_tfContent.text);
    }

    [self removeFromSuperview];
}

- (void)show
{
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];

    self.frame = delegate.window.bounds;

    [delegate.window addSubview:self];

    [delegate.window bringSubviewToFront:self];
}

- (void)clickCancel
{
    if (_onClickCancel)
    {
        _onClickCancel();
    }
    [self removeFromSuperview];
}

@end
