//
//  PayInfoCellTableViewCell.h
//  owner
//
//  Created by 长浩 张 on 2017/4/27.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayInfoCell : UITableViewCell

+ (instancetype)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

@property (weak, nonatomic) IBOutlet UILabel *lbCode;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbPayType;


@property (weak, nonatomic) IBOutlet UILabel *lbState;


@end
