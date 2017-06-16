//
//  CompanyListController.h
//  owner
//
//  Created by 长浩 张 on 2017/6/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "BaseViewController.h"

@protocol CompanyListControllerDelegate <NSObject>

- (void)onChoose:(NSInteger)index name:(NSString *)name;

@end

@interface CompanyListController : BaseViewController

@property (strong, nonatomic) NSArray *arrayBranch;

@property (weak, nonatomic) id<CompanyListControllerDelegate> delegate;

@end
