//
//  OrderAmountCell.h
//  owner
//
//  Created by 长浩 张 on 2017/4/25.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderAmountCell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

@property (assign, nonatomic) NSInteger amount;

@end
