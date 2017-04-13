//
//  CalloutAnnotationView.h
//  elevatorMan
//
//  Created by 长浩 张 on 16/6/28.
//
//

#ifndef CalloutAnnotationView_h
#define CalloutAnnotationView_h

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "WorkerInfoView.h"

@interface CalloutAnnotationView : BMKAnnotationView

@property (strong, nonatomic) WorkerInfoView *workerInfoView;

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) NSMutableDictionary *info;

- (void)showInfoWindow;

- (void)hideInfoWindow;

@end



#endif /* CalloutAnnotationView_h */
