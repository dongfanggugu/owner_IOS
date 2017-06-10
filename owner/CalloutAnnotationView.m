//
//  CalloutAnnotationView.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/6/28.
//
//

#import <Foundation/Foundation.h>
#import "CalloutAnnotationView.h"
#import "WorkerInfoView.h"

@interface CalloutAnnotationView ()


@end

@implementation CalloutAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }

    return self;
}

- (id)initWithAnnotation:(id <BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //self.backgroundColor = [UIColor greenColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, 12);
        self.frame = CGRectMake(0, 0, 24, 24);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        imageView.image = [UIImage imageNamed:@"icon_around"];

        [self addSubview:imageView];
    }

    return self;
}

- (void)showInfoWindow
{
    _workerInfoView = [WorkerInfoView viewFromNib];
    _workerInfoView.backgroundColor = [UIColor clearColor];

    _workerInfoView.frame = CGRectMake(-98, -120, 210, 120);

    [self addSubview:_workerInfoView];

    NSString *project = [_info objectForKey:@"name"];
    NSString *name = [_info objectForKey:@"projectManagera"];
    NSString *tel = [_info objectForKey:@"projectTela"];

    _workerInfoView.lbProject.text = project;
    _workerInfoView.lbName.text = name;
    _workerInfoView.lbTel.text = tel;
}

- (void)hideInfoWindow
{
    [_workerInfoView removeFromSuperview];
}


/**
 *  解决自定义View里面事件被mapview截断的问题
 *
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = self.bounds;

    BOOL isInside = CGRectContainsPoint(rect, point);
    if (!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if (isInside)
            {
                return isInside;
            }
        }
    }

    return isInside;
}


@end
