//
//  RepairInfoView.h
//  owner
//
//  Created by 长浩 张 on 2017/4/26.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+AFNetworking.h>

@interface RepairInfoView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) IBOutlet UILabel *lbCode;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbAppoint;

@property (weak, nonatomic) IBOutlet UILabel *lbFault;

@property (weak, nonatomic) IBOutlet UITextView *lbFaultDes;

@property (weak, nonatomic) IBOutlet UIImageView *ivFault;

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@property (weak, nonatomic) IBOutlet UILabel *lbBrand;

@property (weak, nonatomic) IBOutlet UILabel *lbWeight;

@end
