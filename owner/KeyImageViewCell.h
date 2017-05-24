//
//  KeyImageViewCell.h
//  owner
//
//  Created by 长浩 张 on 2017/5/24.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyImageViewCell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

- (void)delPhoto;

- (void)setOnClickImageListener:(void(^)())onClickImage;

- (void)setOnClickBtnListener:(void(^)())onClickBtn;

@property (weak, nonatomic) IBOutlet UIButton *btnDel;

@property (weak, nonatomic) UIImage *photo;

@property (assign, nonatomic) BOOL hasImage;

@end
