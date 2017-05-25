//
//  RepairInfoView.m
//  owner
//
//  Created by 长浩 张 on 2017/4/26.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "RepairInfoView.h"

@interface RepairInfoView ()

@property (weak, nonatomic) IBOutlet UILabel *lbTitleOrder;

@property (weak, nonatomic) IBOutlet UILabel *lbTitleTask;

@property (weak, nonatomic) IBOutlet UIButton *btnOrder;

@property (weak, nonatomic) IBOutlet UIButton *btnEvaluate;

@end

@implementation RepairInfoView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RepairInfoView" owner:nil options:nil];
    
    if (0 == array) {
        return nil;
    }
    
    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _lbFaultDes.userInteractionEnabled = NO;
    
    _lbFaultDes.layer.masksToBounds = YES;
    _lbFaultDes.layer.cornerRadius = 5;
    
    _lbFaultDes.layer.borderColor = [Utils getColorByRGB:@"#999999"].CGColor;
    
    _lbFaultDes.layer.borderWidth = 1;
    
    _btnOrder.layer.masksToBounds = YES;
    _btnOrder.layer.cornerRadius = 5;
    

    _lbTitleOrder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_blue"]];
    _lbTitleTask.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_red"]];
}

@end
