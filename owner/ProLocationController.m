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

#pragma mark - ProLocationCell

@interface ProLocationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@end

@implementation ProLocationCell


@end

#pragma mark - ProLocationController

@interface ProLocationController()<BMKMapViewDelegate>

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@end

@implementation ProLocationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"小区地址"];
    [self initNavRightWithText:@"修改"];
    
    [self initData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initView];
}

- (void)onClickNavRight
{
    AddressViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"address_controller"];
    controller.addType = TYPE_PRO;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)initData
{
    
}

- (void)initView
{
    _mapView.delegate = self;
    _mapView.zoomLevel = 15;
    _mapView.zoomEnabled = YES;
    
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
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width , 30)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = [[Config shareConfig] getBranchAddress];
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    CGSize size = [label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)];
    label.frame = CGRectMake(0, 64, self.view.bounds.size.width, size.height + 16);
    [self.view addSubview:label];
    
}


@end
