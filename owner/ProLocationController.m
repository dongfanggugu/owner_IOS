//
//  ProLocationController.m
//  elevatorMan
//
//  Created by 长浩 张 on 2017/1/5.
//
//

#import <Foundation/Foundation.h>
#import "ProLocationController.h"
#import "AddressViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "HttpClient.h"
#import "AddressLocationController.h"


#pragma mark - ProLocationController

@interface ProLocationController () <BMKMapViewDelegate, AddressLocationControllerDelegate>

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (strong, nonatomic) UILabel *lbAddress;


@end

@implementation ProLocationController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"小区地址"];
    [self initNavRightWithText:@"修改"];

    [self initData];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initView];
}

- (void)onClickNavRight {
    AddressLocationController *controller = [[AddressLocationController alloc] init];
    controller.delegate = self;

    controller.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:controller animated:YES];
}

- (void)initData {

}

- (void)initView {
    _mapView.delegate = self;
    _mapView.zoomLevel = 15;
    _mapView.zoomEnabled = YES;
    [self markOnMap];

    _lbAddress = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 30)];
    _lbAddress.numberOfLines = 0;
    _lbAddress.lineBreakMode = NSLineBreakByWordWrapping;
    _lbAddress.text = [[Config shareConfig] getBranchAddress];
    _lbAddress.font = [UIFont systemFontOfSize:14];
    _lbAddress.backgroundColor = [UIColor whiteColor];
    _lbAddress.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:_lbAddress];
}

- (void)markOnMap {
    [_mapView removeAnnotations:_mapView.annotations];

    CGFloat lat = [[Config shareConfig] getLat];
    CGFloat lng = [[Config shareConfig] getLng];
    CLLocationCoordinate2D coor;
    coor.latitude = lat;
    coor.longitude = lng;

    [_mapView removeAnnotations:[_mapView annotations]];
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = coor;
    [_mapView addAnnotation:annotation];
    [_mapView setCenterCoordinate:coor];

}

#pragma mark - AddressLocationControllerDelegate

- (void)onChooseAddress:(NSString *)address Lat:(CGFloat)lat lng:(CGFloat)lng {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"address"] = address;
    params[@"lat"] = [NSNumber numberWithFloat:lat];
    params[@"lng"] = [NSNumber numberWithFloat:lng];

    [[HttpClient shareClient] post:URL_PERSON_MODIFY parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [[Config shareConfig] setBranchAddress:address];
        [[Config shareConfig] setLat:lat];
        [[Config shareConfig] setLng:lng];
        [HUDClass showHUDWithText:@"修改成功"];

        _lbAddress.text = address;

        [self markOnMap];
    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];

}

@end
