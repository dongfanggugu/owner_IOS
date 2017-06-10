//
//  MainTaskDetailCell.m
//  owner
//
//  Created by 长浩 张 on 2017/5/25.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "MainTaskDetailCell.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface MainTaskDetailCell ()

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@end

@implementation MainTaskDetailCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MainTaskDetailCell" owner:nil options:nil];

    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

+ (CGFloat)cellHeight
{
    return 750;
}

+ (NSString *)identifier
{
    return @"main_task_detail_cell";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSeparatorStyleNone;

    _btnFinish.layer.masksToBounds = YES;

    _btnFinish.layer.cornerRadius = 5;

    _mapView.zoomLevel = 15;

    [_btnResult addTarget:self action:@selector(clickResult) forControlEvents:UIControlEventTouchUpInside];

    [_btnMore addTarget:self action:@selector(clickMore) forControlEvents:UIControlEventTouchUpInside];

    [_btnFinish addTarget:self action:@selector(clickFinish) forControlEvents:UIControlEventTouchUpInside];

    [_btnPlanDate addTarget:self action:@selector(clickPlan) forControlEvents:UIControlEventTouchUpInside];
}


/**
 修改计划时间
 */
- (void)clickPlan
{
    if (_onClickModify)
    {
        _onClickModify();
    }
}

- (void)clickFinish
{
    if (_onClickFinish)
    {
        _onClickFinish();
    }
}

- (void)clickResult
{
    if (_onClickResult)
    {
        _onClickResult();
    }
}

- (void)clickMore
{
    if (_onClickMore)
    {
        _onClickMore();
    }
}

- (void)markOnMapWithLat:(CGFloat)lat lng:(CGFloat)lng
{
    CLLocationCoordinate2D coor;
    coor.latitude = lat;
    coor.longitude = lng;


    [_mapView removeAnnotations:[_mapView annotations]];
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = coor;
    [_mapView addAnnotation:annotation];
    [_mapView showAnnotations:[NSArray arrayWithObjects:annotation, nil] animated:YES];
}

/**
 解决地图和tableview滑动冲突问题
 **/
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];

    UITableView *tableView = nil;
    for (UIView *next = [self superview];
            next;
            next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];

        if ([nextResponder isKindOfClass:[UITableView class]])
        {
            tableView = (UITableView *) nextResponder;
        }
    }

    if (tableView)
    {
        tableView.scrollEnabled = YES;

        if (hitView)
        {
            if (CGRectContainsPoint(_mapView.frame, point))
            {
                tableView.scrollEnabled = NO;
            }
        }
    }

    return hitView;
}


@end
