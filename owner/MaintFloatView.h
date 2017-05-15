//
//  MaintFloatView.h
//  owner
//
//  Created by 长浩 张 on 2017/5/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MaintFloatView;

@protocol MaintFloatViewDelegate <NSObject>

- (void)onClickView:(MaintFloatView *)view index:(NSInteger)index;

- (void)onClickDetail:(MaintFloatView *)view index:(NSInteger)index;

- (void)onClickOrder:(MaintFloatView *)view index:(NSInteger)index;

@end

@interface MaintFloatView : UIView

+ (instancetype)viewFromNib;

- (void)defaultSel;

@property (weak, nonatomic) id<MaintFloatViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *lbLocation;

@property (weak, nonatomic) IBOutlet UILabel *lbLevel1Top;

@property (weak, nonatomic) IBOutlet UILabel *lbLevel1Mid;

@property (weak, nonatomic) IBOutlet UILabel *lbLevel1Bottom;

@property (weak, nonatomic) IBOutlet UILabel *lbLevel2Top;

@property (weak, nonatomic) IBOutlet UILabel *lbLevel2Mid;

@property (weak, nonatomic) IBOutlet UILabel *lbLevel2Bottom;

@property (weak, nonatomic) IBOutlet UILabel *lbLevel3Top;

@property (weak, nonatomic) IBOutlet UILabel *lbLevel3Mid;

@property (weak, nonatomic) IBOutlet UILabel *lbLevel3Bottom;

@property (weak, nonatomic) IBOutlet UILabel *lbDetail;

@end
