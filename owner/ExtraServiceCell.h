//
//  ExtraServiceCell.h
//  owner
//
//  Created by 长浩 张 on 2017/5/5.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"


@interface ExtraServiceCell : UITableViewCell

+ (id)cellFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;

- (void)addOnClickDetailListener:(void(^)())onClickDetail;

- (void)addOnClickLinkListener:(void(^)())onClickLink;

- (void)addOnClickOrderListener:(void(^)())onClickOrder;

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbInfo;


@end
