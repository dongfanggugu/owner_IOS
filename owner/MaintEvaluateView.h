//
//  MaintEvaluateView.h
//  owner
//
//  Created by changhaozhang on 2017/6/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MaintEvaluateViewDelegate <NSObject>

- (void)onSubmit:(NSInteger)star content:(NSString *)content;

@end

@interface MaintEvaluateView : UIView

+ (id)viewFromNib;

@property (weak ,nonatomic) IBOutlet UILabel *lbStart;

@property (weak ,nonatomic) IBOutlet UILabel *lbEnd;

@property (weak, nonatomic) id<MaintEvaluateViewDelegate> delegate;


@end
