//
//  PersonInfoView.h
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef PersonInfoView_h
#define PersonInfoView_h

@protocol PersonInfoViewDelegate <NSObject>

- (void)onClickView;

@end

@interface PersonInfoView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) id<PersonInfoViewDelegate> delegate;

@end

#endif /* PersonInfoView_h */
