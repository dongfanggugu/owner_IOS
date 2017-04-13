//
//  AlarmInfoView.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/6/28.
//
//

#import <Foundation/Foundation.h>
#import "WorkerInfoView.h"

@interface WorkerInfoView()

@property (weak, nonatomic) IBOutlet UIButton *btnTel;

@property (strong, nonatomic) void(^onClickTel)(NSString *tel);

@property (strong, nonatomic) void(^onClickApp)();

@property (weak, nonatomic) IBOutlet UIButton *btnApp;

@end

@implementation WorkerInfoView


+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"WorkerInfoView" owner:nil options:nil];
    if (0 == array.count)
    {
        return nil;
    }
    
    return [[array[0] subviews] objectAtIndex:0];
        
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _btnTel.layer.borderColor = [Utils getColorByRGB:TITLE_COLOR].CGColor;
    _btnTel.layer.borderWidth = 1;
    _btnTel.layer.masksToBounds = YES;
    _btnTel.layer.cornerRadius = 5;
    
    _btnApp.layer.borderColor = [Utils getColorByRGB:TITLE_COLOR].CGColor;
    _btnApp.layer.borderWidth = 1;
    _btnApp.layer.masksToBounds = YES;
    _btnApp.layer.cornerRadius = 5;
}

- (void)setOnClickTel:(void (^)(NSString *tel))clickTel
{
    _onClickTel = clickTel;
    _btnTel.userInteractionEnabled = YES;
    [_btnTel addTarget:self action:@selector(clickTel) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setOnClickApp:(void (^)())clickApp
{
    _onClickApp = clickApp;
    _btnApp.userInteractionEnabled = YES;
    [_btnApp addTarget:self action:@selector(clickApp) forControlEvents:UIControlEventTouchUpInside];
}


- (void)clickTel
{
    NSString *tel = _lbTel.text;
    _onClickTel(tel);
}

- (void)clickApp
{
    _onClickApp();
}


@end
