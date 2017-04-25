//
//  MainOrderInfoCell.h
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MainOrderInfoCell_h
#define MainOrderInfoCell_h

@interface MainOrderInfoCell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbContent;

@end


#endif /* MainOrderInfoCell_h */
