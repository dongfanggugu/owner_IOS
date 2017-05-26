//
//  MainTypeCell.h
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MainTypeCell_h
#define MainTypeCell_h


@protocol MainTypeCellDelegate <NSObject>

- (void)onClick1;

- (void)onClick2;

- (void)onClick3;

- (void)onClick4;

- (void)onClick5;

@end

@interface MainTypeCell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

@property (weak, nonatomic) IBOutlet UIImageView *iv1;

@property (weak, nonatomic) IBOutlet UIImageView *iv2;

@property (weak, nonatomic) IBOutlet UIImageView *iv3;

@property (weak, nonatomic) IBOutlet UIImageView *iv4;

@property (weak, nonatomic) IBOutlet UIImageView *iv5;

@property (weak, nonatomic) id<MainTypeCellDelegate> delegate;


@end

#endif /* MainTypeCell_h */
