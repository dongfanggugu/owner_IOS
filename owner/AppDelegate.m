//
//  AppDelegate.m
//  owner
//
//  Created by 长浩 张 on 2017/1/6.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "NSArray+Log.h"
#import <IQKeyboardManager.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "JPUSHService.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max

#import <UserNotifications/UserNotifications.h>

#endif


@interface AppDelegate () {
    BMKMapManager *_mapManager;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor whiteColor];

    [_window makeKeyAndVisible];

    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _window.rootViewController = [board instantiateViewControllerWithIdentifier:@"launcher_controller"];



//    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    _window.rootViewController = [board instantiateViewControllerWithIdentifier:@"main_tab_bar_controller"];

    // [self checkUpdate];

    //键盘处理
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;

    //百度地图处理
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:BM_APPKEY generalDelegate:nil];

    if (!ret) {
        NSLog(@"manager start failed");
    } else {
        NSLog(@"manager start succeffully");
    }

    [self registerJPushWithOptions:launchOptions];


    //UIDevice *device = [UIDevice currentDevice];

    //if ([[device model] isEqualToString:@"iPhone"])
    //{
    //[self redirectNSLogToDocumentFolder];
    //}

    return YES;
}


- (void)redirectNSLogToDocumentFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,
            YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"dr.log"];
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];

    //NSFileManager *defaultManager = [NSFileManager defaultManager];
    //[defaultManager removeItemAtPath:logFilePath error:nil];

    //output the log to the file
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
//{
//    NSString *str = url.resourceSpecifier;
//    NSLog(@"url:%@", str);
//    return YES;
//}


- (void)registerJPushWithOptions:(NSDictionary *)launchOptions {

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1

    CGFloat version = [[UIDevice currentDevice].systemVersion floatValue];
    
    if (version >= 10.0)
    {
        [JPUSHService
         registerForRemoteNotificationTypes:UNAuthorizationOptionSound | UNAuthorizationOptionAlert
         categories:nil];
    }
    else if (version >= 8.0)
    {
        [JPUSHService
         registerForRemoteNotificationTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert
         categories:nil];
    }
    else
    {
        [JPUSHService
         registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert
         categories:nil];
        
    }


#else

    [JPUSHService
            registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert
                                    categories:nil];

#endif

    [JPUSHService setupWithOption:launchOptions appKey:JPUSH_APPKEY channel:@"ios" apsForProduction:0];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
    NSLog(@"fail to register for remote notifications with error:%@", error);
}

- (void)   application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"remote notificaiton:%@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}


@end
