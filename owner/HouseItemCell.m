//
//  HouseItemCell.m
//  owner
//
//  Created by 长浩 张 on 2017/5/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "HouseItemCell.h"

@interface HouseItemCell ()

@property (weak, nonatomic) IBOutlet UIButton *btnEdit;

@property (weak, nonatomic) IBOutlet UIButton *btnDel;

@property (strong, nonatomic) void (^onClickEdit)();

@property (strong, nonatomic) void (^onClickDel)();

@end

@implementation HouseItemCell

+ (id)cellFromNib {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HouseItemCell" owner:nil options:nil];

    if (0 == array.count) {
        return nil;
    }

    return array[0];
}

+ (CGFloat)cellHeight {
    return 135;
}

+ (NSString *)identifier {
    return @"house_item_cell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _lbAddress.userInteractionEnabled = NO;

}

- (void)setOnClickEditListener:(void (^)())onClickEdit {
    _onClickEdit = onClickEdit;

    [_btnEdit addTarget:self action:@selector(clickEdit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setOnClickDelListener:(void (^)())onClickDel {
    _onClickDel = onClickDel;

    [_btnDel addTarget:self action:@selector(clickDel) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickEdit {
    if (_onClickEdit) {
        _onClickEdit();
    }
}

- (void)clickDel {
    if (_onClickDel) {
        _onClickDel();
    }
}

@end
