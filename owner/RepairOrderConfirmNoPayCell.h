//
// Created by changhaozhang on 2017/6/12.
// Copyright (c) 2017 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RepairOrderConfirmNoPayCellDelegate <NSObject>

- (void)onClickAgreement;

- (void)onClickSubmit;

@end

@interface RepairOrderConfirmNoPayCell : UITableViewCell

+ (id)cellFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;


@property (weak, nonatomic) IBOutlet UITextView *lbIntroduce;

@property (weak, nonatomic) IBOutlet UILabel *lbCompany;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (weak, nonatomic) IBOutlet UIButton *btnAgreement;

@property (weak, nonatomic) id<RepairOrderConfirmNoPayCellDelegate> delegate;

@end