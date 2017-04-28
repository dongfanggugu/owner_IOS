//
//  ServiceHistoryCell.h
//  owner
//
//  Created by 长浩 张 on 2017/4/28.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceHistoryCell : UITableViewCell

+ (id)cellFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;

- (void)addOnClickBtnListener:(void(^)())onClickBtn;

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbContent;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) UIImage *image;

@end
