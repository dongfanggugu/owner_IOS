//
//  OrderInfoCell.h
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef OrderInfoCell_h
#define OrderInfoCell_h

@interface OrderInfoCell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

@property (weak, nonatomic) IBOutlet UILabel *lbIndex;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet UILabel *lbState;

@property (weak, nonatomic) IBOutlet UILabel *lbContent;

@end


#endif /* OrderInfoCell_h */
