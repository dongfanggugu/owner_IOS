//
//  MainTaskDetailCell.h
//  owner
//
//  Created by 长浩 张 on 2017/5/25.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTaskDetailCell : UITableViewCell

+ (id)cellFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;

- (void)markOnMapWithLat:(CGFloat)lat lng:(CGFloat)lng;

@property (weak, nonatomic) IBOutlet UILabel *lbPlanDate;

@property (weak, nonatomic) IBOutlet UIButton *btnPlanDate;

@property (weak, nonatomic) IBOutlet UITextView *lbContent;

@property (weak, nonatomic) IBOutlet UILabel *lbWorker;

@property (weak, nonatomic) IBOutlet UILabel *lbTel;

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@property (weak, nonatomic) IBOutlet UIButton *btnResult;

@property (weak, nonatomic) IBOutlet UIButton *btnMore;

@property (weak, nonatomic) IBOutlet UIButton *btnFinish;

@property (strong, nonatomic) void(^onClickModify)();

@property (strong, nonatomic) void(^onClickResult)();

@property (strong, nonatomic) void(^onClickMore)();

@property (strong, nonatomic) void(^onClickFinish)();


@end
