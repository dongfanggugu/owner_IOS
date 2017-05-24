//
//  HouseChangeView.h
//  owner
//
//  Created by 长浩 张 on 2017/5/24.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HouseChangeView;

@protocol HouseChangeViewDelegate <NSObject>

- (void)onClickBtn:(HouseChangeView *)view;

@end

@interface HouseChangeView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) IBOutlet UILabel *lbContent;

@property (weak, nonatomic) id<HouseChangeViewDelegate> delegate;

@end
