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
#import "MaintFloatView.h"
#import "Location.h"
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import "MainOrderController.h"
#import "MainTypeListResponse.h"
#import "MainTypeDetailController.h"
#import "ListDialogData.h"
#import "ListDialogView.h"
#import "MainOrderLoginController.h"
#import "LoginController.h"


@interface ReportController () <BMKMapViewDelegate, BMKGeoCodeSearchDelegate, MaintFloatViewDelegate, ListDialogViewDelegate>

@property (strong, nonatomic) IBOutlet BMKMapView *mapView;

@property (strong, nonatomic) CalloutAnnotationView *calloutView;

@property (strong, nonatomic) NSMutableArray *arrayProject;

@property (strong, nonatomic) MaintFloatView *floatView;

@property (strong, nonatomic) Location *location;

@property (strong, nonatomic) NSMutableArray<MainTypeInfo *> *arrayMaint;

@property (strong, nonatomic) NSMutableArray *arrayHouse;

@property (weak, nonatomic) NSDictionary *curHouse;

@end

@implementation ReportController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"电梯管家"];
    [self initNavRightWithText:@"联系我们"];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMainType];
}

- (Location *)location
{
    if (!_location)
    {
        _location = [[Location alloc] initLocationWith:nil];
    }

    return _location;
}

- (NSMutableArray *)arrayHouse
{
    if (!_arrayHouse)
    {
        _arrayHouse = [NSMutableArray array];
    }

    return _arrayHouse;
}

- (void)onClickNavRight
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", Custom_Service]];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [webView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:webView];
}

- (NSMutableArray<MainTypeInfo *> *)arrayMaint
{
    if (!_arrayMaint)
    {
        _arrayMaint = [NSMutableArray array];
    }

    return _arrayMaint;
}

- (void)initView
{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    [self.view addSubview:_mapView];

    _mapView.delegate = self;
    _mapView.zoomLevel = 15;
    _mapView.zoomEnabled = YES;

}

- (void)initMaintTypeView
{

    if (self.arrayMaint.count != 3)
    {
        return;
    }

    _floatView = [MaintFloatView viewFromNib];

    _floatView.delegate = self;

    _floatView.frame = CGRectMake(8, self.screenHeight - 190, self.screenWidth - 16, 170);

    [self.view addSubview:_floatView];

    if (self.login)
    {
        _floatView.changeHiden = NO;
        [self getHouses];

    }
    else
    {
        _floatView.changeHiden = YES;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationComplete:) name:Custom_Location_Complete object:nil];

        [self.location startLocationService];
    }


    for (MainTypeInfo *info in self.arrayMaint)
    {

        if (1 == info.typeId.integerValue)
        {
            _floatView.lbLevel1Top.text = @"一级管家";
            _floatView.lbLevel1Mid.text = info.name;
            _floatView.lbLevel1Bottom.text = [NSString stringWithFormat:@"￥%.2lf", info.price];

        }
        else if (2 == info.typeId.integerValue)
        {
            _floatView.lbLevel2Top.text = @"二级管家";
            _floatView.lbLevel2Mid.text = info.name;
            _floatView.lbLevel2Bottom.text = [NSString stringWithFormat:@"￥%.2lf", info.price];

        }
        else if (3 == info.typeId.integerValue)
        {
            _floatView.lbLevel3Top.text = @"三级管家";
            _floatView.lbLevel3Mid.text = info.name;
            _floatView.lbLevel3Bottom.text = [NSString stringWithFormat:@"￥%.2lf", info.price];
        }
    }

    [_floatView defaultSel];
}

- (NSMutableArray *)arrayProject
{
    if (!_arrayProject)
    {
        _arrayProject = [NSMutableArray array];
    }

    return _arrayProject;
}


- (void)onLocationComplete:(NSNotification *)notify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Custom_Location_Complete object:nil];
    if (!notify.userInfo)
    {
        return;
    }

    BMKUserLocation *location = notify.userInfo[User_Location];

    [self markOnMapWithLat:location.location.coordinate.latitude lng:location.location.coordinate.longitude];

    [self codeSearchWithLat:location.location.coordinate.latitude lng:location.location.coordinate.longitude];

    [self getProjectInfo];
}

- (void)codeSearchWithLat:(CLLocationDegrees)lat lng:(CLLocationDegrees)lng
{
    BMKGeoCodeSearch *search = [[BMKGeoCodeSearch alloc] init];
    search.delegate = self;

    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    option.reverseGeoPoint = CLLocationCoordinate2DMake(lat, lng);

    BOOL flag = [search reverseGeoCode:option];

    if (flag)
    {
        NSLog(@"反编码启动成功!");

    }
    else
    {
        NSLog(@"反编码启动失败");

    }

}

#pragma mark - BMKGeoCodeSearchDelegate

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR)
    {
        _floatView.lbLocation.text = result.address;

    }
    else
    {
        NSLog(@"反编码 error code:%u", error);
    }
}

#pragma mark - Network Request

- (void)getMainType
{
    [[HttpClient shareClient] bagpost:URL_MAIN_TYPE parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        MainTypeListResponse *response = [[MainTypeListResponse alloc] initWithDictionary:responseObject];

        [self.arrayMaint removeAllObjects];

        [self.arrayMaint addObjectsFromArray:[response getMainTypeList]];
        [self initMaintTypeView];

    }                         failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}

- (void)getProjectInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [[HttpClient shareClient] bagpost:@"getAllCommunitysByPropertyOnOwner" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {

        [weakSelf.arrayProject removeAllObjects];
        [weakSelf.arrayProject addObjectsFromArray:[responseObject objectForKey:@"body"]];
        [weakSelf showProjects];
    }                         failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];

}

- (void)showProjects
{
    for (NSInteger i = 0;
            i < self.arrayProject.count;
            i++)
    {
        CGFloat lat = [[self.arrayProject[i] objectForKey:@"lat"] floatValue];
        CGFloat lng = [[self.arrayProject[i] objectForKey:@"lng"] floatValue];

        CLLocationCoordinate2D coorProject;
        coorProject.latitude = lat;
        coorProject.longitude = lng;

        CLLocationCoordinate2D coorCenter;

        coorCenter.latitude = _mapView.centerCoordinate.latitude;
        coorCenter.longitude = _mapView.centerCoordinate.longitude;


        CLLocationDistance distance = [Location distancePoint:coorProject with:coorCenter];


        if (distance < 5 * 1000)
        {

            NSLog(@"distance:%lf", distance);
            CalloutMapAnnotation *marker = [[CalloutMapAnnotation alloc] init];
            marker.latitude = lat;
            marker.longitude = lng;
            marker.info = self.arrayProject[i];
            [_mapView addAnnotation:marker];
        }
    }
}

- (void)markOnMapWithLat:(CGFloat)lat lng:(CGFloat)lng;
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

#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CalloutMapAnnotation class]])
    {
        CalloutMapAnnotation *ann = (CalloutMapAnnotation *) annotation;
        CalloutAnnotationView *calloutView = (CalloutAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"calloutview"];
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

}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{

}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{

}

#pragma mark - MaintFloatViewDelegate

- (void)onClickView:(MaintFloatView *)view index:(NSInteger)index
{
    for (MainTypeInfo *info in self.arrayMaint)
    {
        NSInteger i = info.typeId.integerValue;

        if ((i - 1) == index)
        {
            view.lbDetail.text = info.content;
            break;
        }
    }
}

- (void)onClickDetail:(MaintFloatView *)view index:(NSInteger)index
{
    for (MainTypeInfo *info in self.arrayMaint)
    {
        NSInteger i = info.typeId.integerValue;

        if ((i - 1) == index)
        {
            MainTypeDetailController *controller = [[MainTypeDetailController alloc] init];
            controller.detail = info.content;

            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            return;
        }
    }
}

- (void)onClickOrder:(MaintFloatView *)view index:(NSInteger)index
{
    if (!self.login)
    {
        [self showLoginInfo];
        return;
    }

    for (MainTypeInfo *info in self.arrayMaint)
    {
        NSInteger i = info.typeId.integerValue;

        if ((i - 1) == index)
        {
            if (self.login)
            {
                MainOrderLoginController *controller = [[MainOrderLoginController alloc] init];
                controller.mainInfo = info;
                controller.houseInfo = _curHouse;

                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];

            }
        }
    }
}

- (void)onClickChange:(MaintFloatView *)view
{
    if (!self.login)
    {
        return;
    }

    [self selectHouse];
}

- (void)showHouseList
{
    if (0 == self.arrayHouse.count)
    {
        return;
    }
    else
    {
        if (1 == self.arrayHouse.count)
        {
            _floatView.changeHiden = YES;
        }
        else
        {
            _floatView.changeHiden = NO;
        }

        _curHouse = self.arrayHouse[0];
        _floatView.lbLocation.text = self.arrayHouse[0][@"cellName"];
        [self markOnMapWithLat:[[self.arrayHouse[0] objectForKey:@"lat"] floatValue]
                           lng:[[self.arrayHouse[0] objectForKey:@"lng"] floatValue]];

        [self getProjectInfo];
        return;
    }
}

- (void)selectHouse
{
    NSMutableArray *array = [NSMutableArray array];

    for (NSDictionary *info in self.arrayHouse)
    {
        ListDialogData *data = [[ListDialogData alloc] initWithKey:info[@"id"] content:info[@"cellName"]];
        [array addObject:data];
    }

    ListDialogView *dialog = [ListDialogView viewFromNib];
    dialog.delegate = self;
    [dialog setData:array];
    [dialog show];
}

#pragma mark - LisDialogViewDelegate

- (void)onSelectItem:(NSString *)key content:(NSString *)content
{
    for (NSDictionary *info in self.arrayHouse)
    {
        if ([key isEqualToString:info[@"id"]])
        {

            _curHouse = info;
            _floatView.lbLocation.text = info[@"cellName"];
            [self markOnMapWithLat:[info[@"lat"] floatValue] lng:[info[@"lng"] floatValue]];

            [self getProjectInfo];
            break;
        }
    }
}

- (void)onDismiss
{
    //[self.navigationController popViewControllerAnimated:YES];
}

/**
 villaId
 brand
 model
 cellName
 address
 lng
 lat
 weight
 layerAmount
 contacts
 contactsTel
 */
- (void)getHouses
{
    [[HttpClient shareClient] post:URL_GET_HOUSE parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.arrayHouse removeAllObjects];
        [self.arrayHouse addObjectsFromArray:responseObject[@"body"]];
        [self showHouseList];

    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}

- (void)showLoginInfo
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"您需要登录才能购买管家服务" preferredStyle:UIAlertControllerStyleAlert];

    __weak typeof(self) weakSelf = self;
    [controller addAction:[UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *handler) {
        [weakSelf goToLogin];
    }]];

    [controller addAction:[UIAlertAction actionWithTitle:@"暂不登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction *handler) {

    }]];

    [self presentViewController:controller animated:YES completion:nil];
}

- (void)goToLogin
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"login_controller"];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


@end
