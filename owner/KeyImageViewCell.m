//
//  KeyImageViewCell.m
//  owner
//
//  Created by 长浩 张 on 2017/5/24.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "KeyImageViewCell.h"

@interface KeyImageViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;

@property (strong, nonatomic) void (^onClickImage)();

@property (strong, nonatomic) void (^onClickBtn)();

@end

@implementation KeyImageViewCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"KeyImageViewCell" owner:nil options:nil];

    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

+ (NSString *)identifier
{
    return @"key_image_view_cell";
}

+ (CGFloat)cellHeight
{
    return 140;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.hasImage = NO;
}

- (void)setHasImage:(BOOL)hasImage
{
    _hasImage = hasImage;

    if (hasImage)
    {
        _btnDel.hidden = NO;

    }
    else
    {
        _btnDel.hidden = YES;
    }
}


- (void)setOnClickImageListener:(void (^)())onClickImage
{
    _onClickImage = onClickImage;

    _ivPhoto.userInteractionEnabled = YES;

    [_ivPhoto addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)]];
}

- (void)setOnClickBtnListener:(void (^)())onClickBtn
{
    _onClickBtn = onClickBtn;

    [_btnDel addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickImage
{
    if (_onClickImage)
    {
        _onClickImage();
    }
}

- (void)clickBtn
{
    if (_onClickBtn)
    {
        _onClickBtn();
    }
}

- (void)setPhoto:(UIImage *)photo
{
    self.hasImage = YES;
    _ivPhoto.image = photo;
}

- (void)delPhoto
{
    self.hasImage = NO;
    _ivPhoto.image = [UIImage imageNamed:@"icon_photo"];
}

@end
