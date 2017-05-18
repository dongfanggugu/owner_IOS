//
//  MainTypeCell.h
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MainTypeCell_h
#define MainTypeCell_h

#import "UIImageView+AFNetworking.h"

@interface MainTypeCell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

- (void)setOnClickListener:(void(^)())onClickBtn;

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbPrice;

@property (weak, nonatomic) IBOutlet UILabel *lbContent;

@property (weak, nonatomic) UIImage *image;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *viewBottom;

@end

#endif /* MainTypeCell_h */
