//
//  SelectableCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/9.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SelectableCell_h
#define SelectableCell_h

#import "ListDialogView.h"


@interface SelectableCell : UITableViewCell


+ (id)cellFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;

- (void)setData:(NSArray<id<ListDialogDataDelegate>> *)arrayData;

- (NSString *)getContentValue;

- (void)setContentValue:(NSString *)content;

- (NSString *)getKeyValue;

- (void)setKeyValue:(NSString *)key;

- (void)setAfterSelectedListener:(void(^)(NSString *key, NSString *content))selection;

- (void)setBeforeSelectedListener:(void (^)(NSString *, NSString *))selection;

@property (assign, nonatomic) BOOL showable;

@property (weak, nonatomic) IBOutlet UILabel *lbKey;

@property (weak, nonatomic) IBOutlet UILabel *lbContent;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyWidth;

@end

#endif /* SelectableCell_h */
