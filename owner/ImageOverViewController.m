//
//  ImageOverViewController.m
//  owner
//
//  Created by changhaozhang on 2017/6/26.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "ImageOverViewController.h"

@interface ImageOverViewController ()

@end

@implementation ImageOverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"图片预览"];
    [self initView];
}

- (void)initView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    
    if (_image)
    {
        imageView.image = _image;
    }
    else if (_imagePath.length > 0)
    {
        imageView.image = [UIImage imageWithContentsOfFile:_imagePath];
    }
    else if (_url.length > 0)
    {
        [imageView setImageWithURL:[NSURL URLWithString:_url]];
    }
    
    [self.view addSubview:imageView];
}


@end
