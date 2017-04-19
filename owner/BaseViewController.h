//
//  BaseViewController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/22.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef BaseViewController_h
#define BaseViewController_h

@interface BaseViewController : UIViewController

- (void)setNavTitle:(NSString *)title;

-  (void)initNavRightWithText:(NSString *)text;

- (void)onClickNavRight;


@property (assign, nonatomic) CGFloat screenWidth;

@property (assign, nonatomic) CGFloat screenHeight;

@property (assign, nonatomic) BOOL login;

@end


#endif /* BaseViewController_h */
