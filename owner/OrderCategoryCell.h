//
// Created by changhaozhang on 2017/6/10.
// Copyright (c) 2017 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OrderCategoryCell : UITableViewCell

+ (id)cellFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;

@property (weak, nonatomic) IBOutlet UIImageView *ivCategory;

@property (weak, nonatomic) IBOutlet UILabel *lbItem;

@end