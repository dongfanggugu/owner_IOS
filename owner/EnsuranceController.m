//
//  EnsuranceController.m
//  owner
//
//  Created by 长浩 张 on 2017/3/7.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnsuranceController.h"

@interface EnsuranceController()<UIScrollViewDelegate>
{
    CGRect _oldFrame;    //保存图片原来的大小
    CGRect _largeFrame;  //确定图片放大最大的程度
    
    CGFloat _viewWidth;
    
    CGFloat _viewHeight;
    
    NSInteger _currentPage;
}

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIImageView *view1;

@property (strong, nonatomic) UIImageView *view2;

@property (strong, nonatomic) UIImageView *view3;

@property (strong, nonatomic) UIImageView *view4;

@property (strong, nonatomic) UIImageView *view5;

@property (strong, nonatomic) UIImageView *view6;

@property (strong, nonatomic) UIImageView *view7;

@property (strong, nonatomic) UIImageView *view8;

@property (strong, nonatomic) UILabel *lbPage;

@end


@implementation EnsuranceController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"保险条款"];
    [self initData];
    [self initView];
}

- (void)initData
{
    _currentPage = 0;
}

- (void)initPageView
{
    _viewWidth = [UIScreen mainScreen].bounds.size.width;
    _viewHeight = [UIScreen mainScreen].bounds.size.height - 64;
    
    //设置scrollview
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, _viewWidth, _viewHeight)];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(_viewWidth * 8, _viewHeight);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:_scrollView];
    
    _lbPage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    
    _lbPage.center = CGPointMake(_viewWidth / 2, _viewHeight + 64 - 49);
    
    _lbPage.layer.masksToBounds = YES;
    _lbPage.layer.cornerRadius = 10;
    
    _lbPage.font = [UIFont systemFontOfSize:13];
    _lbPage.textAlignment = NSTextAlignmentCenter;
    
    _lbPage.textColor = [UIColor whiteColor];
    
    _lbPage.text = @"1/8";
    
    _lbPage.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [self.view addSubview:_lbPage];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initPageView];
    
     _oldFrame = CGRectMake(0, 0, _viewWidth, _viewHeight);
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    _largeFrame = CGRectMake(0 - screenSize.width, 0 - screenSize.height, 3 * _oldFrame.size.width, 3 * _oldFrame.size.height);

    
    _view1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
    _view1.image = [UIImage imageNamed:@"page_1.jpg"];
    [self initImageView:_view1];
    
    _view2 = [[UIImageView alloc] initWithFrame:CGRectMake(_viewWidth, 0, _viewWidth, _viewHeight)];
    _view2.image = [UIImage imageNamed:@"page_2.jpg"];
    [self initImageView:_view2];
    
    _view3 = [[UIImageView alloc] initWithFrame:CGRectMake(_viewWidth * 2, 0, _viewWidth, _viewHeight)];
    [self initImageView:_view3];
    
    _view4 = [[UIImageView alloc] initWithFrame:CGRectMake(_viewWidth * 3, 0, _viewWidth, _viewHeight)];
    [self initImageView:_view4];
    
    _view5 = [[UIImageView alloc] initWithFrame:CGRectMake(_viewWidth * 4, 0, _viewWidth, _viewHeight)];
    [self initImageView:_view5];
    
    _view6 = [[UIImageView alloc] initWithFrame:CGRectMake(_viewWidth * 5, 0, _viewWidth, _viewHeight)];
    [self initImageView:_view6];
    
    _view7 = [[UIImageView alloc] initWithFrame:CGRectMake(_viewWidth * 6, 0, _viewWidth, _viewHeight)];
    [self initImageView:_view7];
    
    _view8 = [[UIImageView alloc] initWithFrame:CGRectMake(_viewWidth * 7, 0, _viewWidth, _viewHeight)];
    [self initImageView:_view8];
    
    [_scrollView addSubview:_view1];
    [_scrollView addSubview:_view2];
    [_scrollView addSubview:_view3];
    [_scrollView addSubview:_view4];
    [_scrollView addSubview:_view5];
    [_scrollView addSubview:_view6];
    [_scrollView addSubview:_view7];
    [_scrollView addSubview:_view8];
    
}


- (void)initImageView:(UIImageView *)imageView
{
    imageView.multipleTouchEnabled = YES;
    
    imageView.userInteractionEnabled = YES;
    
    [self addGestureRecognizerToView:imageView];
}


// 添加所有的手势
- (void) addGestureRecognizerToView:(UIView *)view
{
    // 旋转手势
//    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
//    [view addGestureRecognizer:rotationGestureRecognizer];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [view addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
//    [view addGestureRecognizer:panGestureRecognizer];
}

// 处理旋转手势
- (void) rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        
        if (view.frame.size.width < _oldFrame.size.width)
        {
            NSInteger x = (NSInteger) (view.frame.origin.x / _viewWidth);
        
            CGRect frame = CGRectMake(x * _viewWidth, _oldFrame.origin.y, _oldFrame.size.width, _oldFrame.size.height);
            view.frame = frame;
        }
        pinchGestureRecognizer.scale = 1;
    }
}

// 处理拖拉手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}


#pragma mark - ScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    //得到当前页数
    _currentPage = (NSInteger) (_scrollView.contentOffset.x / _viewWidth) + 1;
    
    _lbPage.text = [NSString stringWithFormat:@"%ld/8", _currentPage];
    
    switch (_currentPage) {
        case 0:
            
            break;
        case 1:
            break;
        case 2:
            
            if (!_view3.image)
            {
                _view3.image = [UIImage imageNamed:@"page_3.jpg"];
            }
            
            break;
        case 3:
            
            if (!_view3.image)
            {
                _view3.image = [UIImage imageNamed:@"page_3.jpg"];
            }
            
            if (!_view4.image)
            {
                _view4.image = [UIImage imageNamed:@"page_4.jpg"];
            }
            
            break;
        case 4:
            
            if (!_view4.image)
            {
                _view4.image = [UIImage imageNamed:@"page_4.jpg"];
            }
            if (!_view5.image)
            {
                _view5.image = [UIImage imageNamed:@"page_5.jpg"];
            }
            
            if (!_view6.image)
            {
                _view6.image = [UIImage imageNamed:@"page_6.jpg"];
            }
            
            break;
        case 5:
            
            if (!_view5.image)
            {
                _view5.image = [UIImage imageNamed:@"page_5.jpg"];
            }
            
            if (!_view6.image)
            {
                _view6.image = [UIImage imageNamed:@"page_6.jpg"];
            }

            
            break;
        case 6:
            
            if (!_view6.image)
            {
                _view6.image = [UIImage imageNamed:@"page_6.jpg"];
            }
            
            if (!_view7.image)
            {
                _view7.image = [UIImage imageNamed:@"page_7.jpg"];
            }
            
            break;
        case 7:
            
            if (!_view7.image)
            {
                _view7.image = [UIImage imageNamed:@"page_7.jpg"];
            }
            
            if (!_view8.image)
            {
                _view8.image = [UIImage imageNamed:@"page_8.jpg"];
            }
            
            break;
        case 8:
           
            if (!_view8.image)
            {
                _view8.image = [UIImage imageNamed:@"page_8.jpg"];
            }
            break;
            
        default:
            break;
    }
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

@end
