//
//  MainOrderInfoView.h
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MainOrderInfoView_h
#define MainOrderInfoView_h

@protocol MainOrderInfoViewDelegate <NSObject>

- (void)onClickPayButton;

- (void)onClickOrderButton;

- (void)onClickDetailButton;

@end


@interface MainOrderInfoView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbPrice;

@property (weak, nonatomic) IBOutlet UILabel *lbInfo;

@property (weak, nonatomic) UIImage *image;

@property (weak, nonatomic) id<MainOrderInfoViewDelegate> delegate;

@end

#endif /* MainOrderInfoView_h */
