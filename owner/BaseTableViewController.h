//
//  BaseTableViewController.h
//  elevatorMan
//
//  Created by 长浩 张 on 16/7/7.
//
//

#ifndef BaseTableViewController_h
#define BaseTableViewController_h

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController

- (void)setNavTitle:(NSString *)title;

- (void)initNavRightWithImage:(UIImage *)image;

@property (assign, nonatomic) CGFloat screenWidth;

@property (assign, nonatomic) CGFloat screenHeight;

@end


#endif /* BaseTableViewController_h */
