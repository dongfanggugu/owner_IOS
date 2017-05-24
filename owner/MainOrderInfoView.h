//
//  MainOrderInfoView.h
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MainOrderInfoView_h
#define MainOrderInfoView_h

#import "UIImageView+AFNetworking.h"

@class MainOrderInfoView;

@protocol MainOrderInfoViewDelegate <NSObject>

- (void)onClickPayButton:(MainOrderInfoView *)view;

- (void)onClickBackButton:(MainOrderInfoView *)view;

- (void)onClickOrderButton:(MainOrderInfoView *)view;

- (void)onClickDetailButton:(MainOrderInfoView *)view;

- (void)onClickChangeButton:(MainOrderInfoView *)view;

@end


@interface MainOrderInfoView : UIView

+ (id)viewFromNib;


@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbPrice;

@property (weak, nonatomic) IBOutlet UILabel *lbInfo;

@property (weak, nonatomic) UIImage *image;

@property (weak, nonatomic) id<MainOrderInfoViewDelegate> delegate;

@property (strong, nonatomic) NSDictionary *data;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (assign, nonatomic) BOOL viewHidden;

@end

#endif /* MainOrderInfoView_h */
