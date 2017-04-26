//
//  RepairInfoView.m
//  owner
//
//  Created by 长浩 张 on 2017/4/26.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "RepairInfoView.h"

@implementation RepairInfoView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RepairInfoView" owner:nil options:nil];
    
    if (0 == array) {
        return nil;
    }
    
    return array[0];
}


@end
