//
//  MaintEvaluateView.m
//  owner
//
//  Created by changhaozhang on 2017/6/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "MaintEvaluateView.h"



@interface MaintEvaluateView ()

@property (weak, nonatomic) IBOutlet UIButton *btnStar1;

@property (weak, nonatomic) IBOutlet UIButton *btnStar2;

@property (weak, nonatomic) IBOutlet UIButton *btnStar3;

@property (weak, nonatomic) IBOutlet UIButton *btnStar4;

@property (weak, nonatomic) IBOutlet UIButton *btnStar5;

@property (weak, nonatomic) IBOutlet UITextView *tvContent;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (assign, nonatomic) NSInteger starCount;

@end

@implementation MaintEvaluateView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MaintEvaluateView" owner:nil options:nil];
    
    if (0 == array.count) {
        return nil;
    }
    
    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _btnSubmit.layer.masksToBounds = YES;
    _btnSubmit.layer.cornerRadius = 3;
    
    [_btnStar1 addTarget:self action:@selector(clickBtn1) forControlEvents:UIControlEventTouchUpInside];
    [_btnStar2 addTarget:self action:@selector(clickBtn2) forControlEvents:UIControlEventTouchUpInside];
    [_btnStar3 addTarget:self action:@selector(clickBtn3) forControlEvents:UIControlEventTouchUpInside];
    [_btnStar4 addTarget:self action:@selector(clickBtn4) forControlEvents:UIControlEventTouchUpInside];
    [_btnStar5 addTarget:self action:@selector(clickBtn5) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnSubmit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    
    _tvContent.layer.masksToBounds = YES;
    _tvContent.layer.cornerRadius = 5;
    _tvContent.layer.borderWidth = 1;
    _tvContent.layer.borderColor = [UIColor grayColor].CGColor;
    
    //默认三星
    _starCount = 3;
    
    [_btnStar1 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar2 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar3 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar4 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    [_btnStar5 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    
}

- (void)clickBtn1
{
    [_btnStar1 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar2 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    [_btnStar3 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    [_btnStar4 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    [_btnStar5 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    _starCount = 1;
}

- (void)clickBtn2
{
    [_btnStar1 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar2 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar3 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    [_btnStar4 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    [_btnStar5 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    _starCount = 2;
}

- (void)clickBtn3
{
    [_btnStar1 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar2 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar3 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar4 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    [_btnStar5 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    
    _starCount = 3;
}

- (void)clickBtn4
{
    [_btnStar1 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar2 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar3 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar4 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar5 setImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    
    _starCount = 4;
    
}

- (void)clickBtn5
{
    [_btnStar1 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar2 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar3 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar4 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    [_btnStar5 setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    
    _starCount = 5;
}
- (void)submit
{
    if (_delegate) {
        [_delegate onSubmit:_starCount content:_tvContent.text];
    }
}

@end
