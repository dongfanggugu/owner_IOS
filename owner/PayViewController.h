//
//  PayViewController.h
//  owner
//
//  Created by 长浩 张 on 2017/5/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol PayViewControllerDelegate <NSObject>

- (void)clickBack;

@end

@interface PayViewController : BaseViewController

@property (copy, nonatomic) NSString *urlStr;

@property (weak, nonatomic) id<PayViewControllerDelegate> delegate;

@end
