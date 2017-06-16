//
//  RepairOrderConfirmCell.h
//  owner
//
//  Created by 长浩 张 on 2017/6/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RepairOrderConfirmCellDelegate <NSObject>

- (void)onChooseCompany:(NSInteger)index name:(NSString *)name;

- (void)onClickMoreCompany;

- (void)onClickCoupon;

- (void)onClickAgreement;

- (void)onClickPay;

@end

@interface RepairOrderConfirmCell : UITableViewCell

+ (id)cellFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;

- (void)resetSel;

- (void)selCom1;

- (void)selCom2;

- (void)selCom3;

@property (weak, nonatomic) IBOutlet UILabel *lbIntroduce;

@property (weak, nonatomic) IBOutlet UILabel *lbCom1;

@property (weak, nonatomic) IBOutlet UILabel *lbCom2;

@property (weak, nonatomic) IBOutlet UILabel *lbCom3;

@property (weak, nonatomic) IBOutlet UILabel *lbCompany;

@property (weak, nonatomic) IBOutlet UIButton *btnMoreCom;

@property (weak, nonatomic) IBOutlet UIButton *btnCoupon;

@property (weak, nonatomic) IBOutlet UILabel *lbCoupon;

@property (weak, nonatomic) IBOutlet UILabel *lbFee;

@property (weak, nonatomic) IBOutlet UILabel *lbDiscount;

@property (weak, nonatomic) IBOutlet UILabel *lbPay;

@property (weak, nonatomic) IBOutlet UIButton *btnPay;

@property (weak, nonatomic) IBOutlet UIButton *btnAgreement;

@property (weak, nonatomic) id<RepairOrderConfirmCellDelegate> delegate;

@end
