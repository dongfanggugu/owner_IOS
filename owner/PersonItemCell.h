//
//  PersonItemCell.h
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef PersonItemCell_h
#define PersonItemCell_h

@interface PersonItemCell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

@property (weak, nonatomic) IBOutlet UIImageView *ivIcon;

@property (weak, nonatomic) IBOutlet UILabel *lbItem;

@end

#endif /* PersonItemCell_h */
