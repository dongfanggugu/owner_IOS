//
//  MainOrderConfirmCell.h
//  owner
//
//  Created by 长浩 张 on 2017/5/27.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainOrderConfirmCell : UITableViewCell

+ (id)cellFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;

@property (weak, nonatomic) IBOutlet UILabel *lbCode;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UITextView *lbContent;

@property (weak, nonatomic) IBOutlet UILabel *lbLinkName;

@property (weak, nonatomic) IBOutlet UILabel *lbLinkTel;

@property (weak, nonatomic) IBOutlet UILabel *lbBrand;

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@property (weak, nonatomic) IBOutlet UILabel *lbAmount;

@property (weak, nonatomic) IBOutlet UILabel *lbPrice;

@property (weak, nonatomic) IBOutlet UILabel *lbDiscourt;

@property (weak, nonatomic) IBOutlet UILabel *lbPay;

@property (weak, nonatomic) IBOutlet UIButton *moreComge;

@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
