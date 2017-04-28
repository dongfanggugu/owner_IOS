//
//  ServiceHistoryCell.m
//  owner
//
//  Created by 长浩 张 on 2017/4/28.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "ServiceHistoryCell.h"

@interface ServiceHistoryCell ()

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UIImageView *ivBg;

@property (strong, nonatomic) void(^onClickBtn)();

@end

@implementation ServiceHistoryCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ServiceHistoryCell" owner:nil options:nil];
    
    if (0 == array.count) {
        return nil;
    }
    
    return array[0];
}

+ (NSString *)identifier
{
    return @"service_history_cell";
}

+ (CGFloat)cellHeight
{
    return 150;
}


- (void)setImage:(UIImage *)image
{
    _ivBg.image = image;
}

- (void)addOnClickBtnListener:(void (^)())onClickBtn
{
    _onClickBtn = onClickBtn;
    [_btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickBtn
{
    if (_onClickBtn) {
        _onClickBtn();
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
