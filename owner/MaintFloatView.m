//
//  MaintFloatView.m
//  owner
//
//  Created by 长浩 张 on 2017/5/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "MaintFloatView.h"

@interface MaintFloatView ()

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UIButton *btnChange;

@property (weak, nonatomic) IBOutlet UIButton *btnDetail;

@property (weak, nonatomic) IBOutlet UIView *viewLevel1;

@property (weak, nonatomic) IBOutlet UIView *viewLevel2;

@property (weak, nonatomic) IBOutlet UIView *viewLevel3;

@property (assign, nonatomic) NSInteger curIndex;

@end

@implementation MaintFloatView

+ (instancetype)viewFromNib {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MaintFloatView" owner:nil options:nil];

    if (0 == array.count) {
        return nil;
    }

    return array[0];
}


- (void)onClickOrder {
    if (_delegate && [_delegate respondsToSelector:@selector(onClickOrder:index:)]) {
        [_delegate onClickOrder:self index:_curIndex];
    }
}

- (void)onClickDetail {
    if (_delegate && [_delegate respondsToSelector:@selector(onClickDetail:index:)]) {
        [_delegate onClickDetail:self index:_curIndex];
    }
}

- (void)onClickChange {
    if (_delegate && [_delegate respondsToSelector:@selector(onClickChange:)]) {
        [_delegate onClickChange:self];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];

    _btn.layer.masksToBounds = YES;
    _btn.layer.cornerRadius = 5;

    _btnChange.layer.masksToBounds = YES;
    _btnChange.layer.cornerRadius = 5;

    _btnDetail.layer.masksToBounds = YES;
    _btnDetail.layer.cornerRadius = 5;

    _viewLevel1.userInteractionEnabled = YES;
    [_viewLevel1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewSel1)]];

    _viewLevel2.userInteractionEnabled = YES;
    [_viewLevel2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewSel2)]];

    _viewLevel3.userInteractionEnabled = YES;
    [_viewLevel3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewSel3)]];


    [_btn addTarget:self action:@selector(onClickOrder) forControlEvents:UIControlEventTouchUpInside];

    [_btnChange addTarget:self action:@selector(onClickChange) forControlEvents:UIControlEventTouchUpInside];

    [_btnDetail addTarget:self action:@selector(onClickDetail) forControlEvents:UIControlEventTouchUpInside];

}


- (void)resetSel {
    _viewLevel1.backgroundColor = [UIColor whiteColor];

    _lbLevel1Top.textColor = [UIColor blackColor];

    _lbLevel1Mid.textColor = [UIColor blackColor];

    _lbLevel1Bottom.textColor = [UIColor blackColor];


    _viewLevel2.backgroundColor = [UIColor whiteColor];

    _lbLevel2Top.textColor = [UIColor blackColor];

    _lbLevel2Mid.textColor = [UIColor blackColor];

    _lbLevel2Bottom.textColor = [UIColor blackColor];


    _viewLevel3.backgroundColor = [UIColor whiteColor];

    _lbLevel3Top.textColor = [UIColor blackColor];

    _lbLevel3Mid.textColor = [UIColor blackColor];

    _lbLevel3Bottom.textColor = [UIColor blackColor];


}

- (void)viewSel1 {
    [self resetSel];

    _viewLevel1.backgroundColor = [Utils getColorByRGB:@"#f1f1f1"];

    _lbLevel1Top.textColor = [Utils getColorByRGB:TITLE_COLOR];

    _lbLevel1Mid.textColor = [Utils getColorByRGB:TITLE_COLOR];

    _lbLevel1Bottom.textColor = [Utils getColorByRGB:TITLE_COLOR];

    if (_delegate && [_delegate respondsToSelector:@selector(onClickView:index:)]) {
        [_delegate onClickView:self index:0];
    }

    _curIndex = 0;
}

- (void)viewSel2 {
    [self resetSel];

    _viewLevel2.backgroundColor = [Utils getColorByRGB:@"#f1f1f1"];

    _lbLevel2Top.textColor = [Utils getColorByRGB:TITLE_COLOR];

    _lbLevel2Mid.textColor = [Utils getColorByRGB:TITLE_COLOR];

    _lbLevel2Bottom.textColor = [Utils getColorByRGB:TITLE_COLOR];

    if (_delegate && [_delegate respondsToSelector:@selector(onClickView:index:)]) {
        [_delegate onClickView:self index:1];
    }

    _curIndex = 1;
}

- (void)viewSel3 {
    [self resetSel];

    _viewLevel3.backgroundColor = [Utils getColorByRGB:@"#f1f1f1"];

    _lbLevel3Top.textColor = [Utils getColorByRGB:TITLE_COLOR];

    _lbLevel3Mid.textColor = [Utils getColorByRGB:TITLE_COLOR];

    _lbLevel3Bottom.textColor = [Utils getColorByRGB:TITLE_COLOR];

    if (_delegate && [_delegate respondsToSelector:@selector(onClickView:index:)]) {
        [_delegate onClickView:self index:2];
    }

    _curIndex = 2;
}

- (void)defaultSel {
    [self viewSel1];
}

- (void)setChangeHiden:(BOOL)changeHiden {
    if (changeHiden) {
        _btnChange.hidden = YES;

    } else {
        _btnChange.hidden = NO;

    }
}

@end
