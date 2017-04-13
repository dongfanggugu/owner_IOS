//
//  MarketCell.h
//  owner
//
//  Created by 长浩 张 on 2017/1/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MarketCell_h
#define MarketCell_h

@interface MarketCell : UITableViewCell

+ (instancetype)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

@property (weak, nonatomic) IBOutlet UILabel *lbTile;

@property (weak, nonatomic) IBOutlet UILabel *lbTel;

@property (weak, nonatomic) IBOutlet UIImageView *ivIcon;

@property (weak, nonatomic) IBOutlet UIView *viewBg;

@end

#endif /* MarketCell_h */
