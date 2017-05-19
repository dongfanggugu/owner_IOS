//
//  LinkModifyController.h
//  owner
//
//  Created by 长浩 张 on 2017/5/19.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "BaseViewController.h"

@protocol LinkModifyControllerDelegate <NSObject>

- (void)onModifyComplete:(NSString *)name tel:(NSString *)tel;

@end

@interface LinkModifyController : BaseViewController

@property (weak, nonatomic) id<LinkModifyControllerDelegate> delegate;

@end
