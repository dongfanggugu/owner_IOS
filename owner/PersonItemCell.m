//
//  PersonItemCell.m
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonItemCell.h"

@implementation PersonItemCell

+ (id)cellFromNib {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PersonItemCell" owner:nil options:nil];

    if (0 == array.count) {
        return nil;
    }

    return array[0];
}

+ (NSString *)identifier {
    return @"person_item_cell";
}

+ (CGFloat)cellHeight {
    return 55;
}

@end
