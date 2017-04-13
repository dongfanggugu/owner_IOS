//
//  MainOrderInfoView.h
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MainOrderInfoView_h
#define MainOrderInfoView_h


@interface MainOrderInfoView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) IBOutlet UILabel *lbCode;

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbPay;

@property (weak, nonatomic) IBOutlet UILabel *lbNameKey;

@property (weak, nonatomic) IBOutlet UILabel *lbPayKey;

@end

#endif /* MainOrderInfoView_h */
