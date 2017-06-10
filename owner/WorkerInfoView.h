//
//  WorkerInfoView_h
//  elevatorMan
//
//  Created by 长浩 张 on 16/6/28.
//
//

#ifndef WorkerInfoView_h
#define WorkerInfoView_h

#import <UIKit/UIKit.h>

@interface WorkerInfoView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) IBOutlet UILabel *lbProject;

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbTel;

- (void)setOnClickTel:(void (^)(NSString *tel))clickTel;

- (void)setOnClickApp:(void (^)())clickApp;

@end


#endif /* WorkerInfoView_h */
