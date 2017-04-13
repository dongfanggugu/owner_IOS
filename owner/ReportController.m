//
//  ReportController.m
//  owner
//
//  Created by 长浩 张 on 2017/1/6.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReportController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "HttpClient.h"
#import "CalloutAnnotationView.h"
#import "CalloutMapAnnotation.h"
#import "AppReportController.h"


@interface ReportController ()<BMKMapViewDelegate>

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (strong, nonatomic) CalloutAnnotationView *calloutView;

@property (strong, nonatomic) NSMutableArray *arrayProject;

@end

@implementation ReportController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"电梯报修"];
    [self initView];
    [self initData];
}


- (void)initView
{
    _mapView.delegate = self;
    _mapView.zoomLevel = 15;
    _mapView.zoomEnabled = YES;
    [self markOnMap];
}

- (void)initData
{
    _arrayProject = [NSMutableArray array];
    [self getProjectInfo];
}

- (void)getProjectInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [[HttpClient shareClient] view:self.view post:@"getAllCommunitysByProperty" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [weakSelf.arrayProject removeAllObjects];
        [weakSelf.arrayProject addObjectsFromArray:[responseObject objectForKey:@"body"]];
        [weakSelf showProjects];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
    
}

- (void)showProjects
{
    for (NSInteger i = 0; i < _arrayProject.count; i++)
    {
        CGFloat lat = [[_arrayProject[i] objectForKey:@"lat"] floatValue];
        CGFloat lng = [[_arrayProject[i] objectForKey:@"lng"] floatValue];
        CalloutMapAnnotation *marker = [[CalloutMapAnnotation alloc] init];
        marker.latitude = lat;
        marker.longitude = lng;
        marker.info = _arrayProject[i];
        [_mapView addAnnotation:marker];
    }
}

- (void)markOnMap
{
    
    CGFloat lat = [[Config shareConfig] getLat];
    CGFloat lng = [[Config shareConfig] getLng];
    CLLocationCoordinate2D coor;
    coor.latitude = lat;
    coor.longitude = lng;
    
    
    [_mapView removeAnnotations:[_mapView annotations]];
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = coor;
    [_mapView addAnnotation:annotation];
    [_mapView showAnnotations:[NSArray arrayWithObjects:annotation, nil] animated:YES];
}

#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CalloutMapAnnotation class]])
    {
        CalloutMapAnnotation *ann = (CalloutMapAnnotation *)annotation;
        CalloutAnnotationView *calloutView = (CalloutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"calloutview"];
        if (nil == calloutView)
        {
            calloutView = [[CalloutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"calloutview"];
        }
        
        calloutView.info = ann.info;
        
        return calloutView;
    }
    
    return nil;
}


- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    CalloutAnnotationView *calloutView = (CalloutAnnotationView *)view;
    
    if (_calloutView == calloutView)
    {
        return;
    }
    
    if (nil == _calloutView)
    {
        _calloutView = calloutView;
    }
    else
    {
        [_calloutView hideInfoWindow];
        _calloutView = calloutView;
    }
    
    [_calloutView showInfoWindow];

    __weak typeof(self) weakSelf = self;
    
    [_calloutView.workerInfoView setOnClickApp:^{
        AppReportController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"app_report"];
        controller.projectId = [weakSelf.calloutView.info objectForKey:@"id"];
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
    
    [_calloutView.workerInfoView setOnClickTel:^(NSString *tel) {
        NSLog(@"tel:%@", tel);
        
        if (0 == tel.length)
        {
            [HUDClass showHUDWithLabel:@"非法的手机号码,无法拨打!" view:weakSelf.view];
            return;
        }
        
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", tel]];
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [webView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
        [weakSelf.view addSubview:webView];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"communityId"] = [weakSelf.calloutView.info objectForKey:@"id"];
        params[@"type"] = @"1";
        [[HttpClient shareClient] view:nil post:@"addRepair" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            
        } failure:^(NSURLSessionDataTask *task, NSError *errr) {
            
        }];
        
    }];
    
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    if (nil == _calloutView)
    {
        return;
    }
    
    [_calloutView hideInfoWindow];
    _calloutView = nil;
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    if (nil == _calloutView)
    {
        return;
    }
    
    [_calloutView hideInfoWindow];
    _calloutView = nil;
}

@end
