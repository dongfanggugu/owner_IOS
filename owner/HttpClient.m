//
//  HttpClient.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "Config.h"

@interface HttpClient ()

@end

@implementation HttpClient


+ (instancetype)shareClient
{
    static HttpClient *shareClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        shareClient = [[HttpClient alloc] initWithBaseURL:[NSURL URLWithString:[Utils getServer]]];
        shareClient.requestSerializer = [AFJSONRequestSerializer serializer];
        shareClient.responseSerializer = [AFJSONResponseSerializer serializer];
        shareClient.responseSerializer.acceptableContentTypes
                = [shareClient.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    });

    return shareClient;
}

- (void)post:(NSString *)url parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableDictionary *head = [[NSMutableDictionary alloc] init];

    [head setObject:@"1" forKey:@"osType"];
    [head setObject:@"1.0" forKey:@"version"];
    [head setObject:@"" forKey:@"deviceId"];

    if ([[Config shareConfig] getToken].length > 0)
    {
        [head setObject:[[Config shareConfig] getToken] forKey:@"accessToken"];
    }

    if ([[Config shareConfig] getUserId].length > 0)
    {
        [head setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
    }

    [self post:url head:head body:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];

}

- (void)post:(NSString *)url head:(id)head body:(id)body
     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];

    if (head)
    {
        param[@"head"] = head;
    }

    if (body)
    {
        param[@"body"] = body;
    }

    NSLog(@"zhenhao-----request:%@", param);

    MBProgressHUD *hud = [HUDClass showLoadingHUD];

    [self POST:url parameters:param success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        NSLog(@"zhenhao-----response:%@", responseObject);

        if (hud)
        {
            [HUDClass hideLoadingHUD:hud];
        }

        if ([[[responseObject objectForKey:@"head"] objectForKey:@"rspCode"] isEqualToString:@"0"])
        {
            success(task, responseObject);
        }
        else
        {
            //根据错误信息提示用户
            NSString *msg = nil;
            NSString *rspMsg = [[responseObject objectForKey:@"head"] objectForKey:@"rspMsg"];

            if ([rspMsg containsString:@"系统错误"])
            {
                msg = [rspMsg substringFromIndex:5];
            }
            else
            {
                msg = rspMsg;
            }

            [HUDClass showHUDWithText:msg];


            NSString *msgCode = [[responseObject objectForKey:@"head"] objectForKey:@"rspCode"];

            if ([msgCode isEqualToString:@"-9"])
            {
                [[Config shareConfig] clearUserInfo];
                [self performSelector:@selector(backToLogin) withObject:nil afterDelay:1.0f];
            }
        }

    }  failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"zhenhao-----error:%@", error);
        [HUDClass hideLoadingHUD:hud];
        failure(task, error);
    }];
}

- (void)bagpost:(NSString *)url parameters:(id)parameters
        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *head = [[NSMutableDictionary alloc] init];

    [head setObject:@"1" forKey:@"osType"];
    [head setObject:@"1.0" forKey:@"version"];
    [head setObject:@"" forKey:@"deviceId"];

    if ([[Config shareConfig] getToken].length > 0)
    {
        [head setObject:[[Config shareConfig] getToken] forKey:@"accessToken"];
    }

    if ([[Config shareConfig] getUserId].length > 0)
    {
        [head setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
    }

    if (parameters)
    {
        [param setObject:parameters forKey:@"body"];
    }

    [param setObject:head forKey:@"head"];

    NSLog(@"zhenhao-----background request:%@", param);

    [self POST:url parameters:param success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        NSLog(@"zhenhao-----background response:%@", responseObject);

        if ([[[responseObject objectForKey:@"head"] objectForKey:@"rspCode"] isEqualToString:@"0"])
        {
            success(task, responseObject);

        }
        else
        {
            //根据错误信息提示用户
            NSString *msg = nil;
            NSString *rspMsg = [[responseObject objectForKey:@"head"] objectForKey:@"rspMsg"];

            if ([rspMsg containsString:@"系统错误"])
            {
                msg = [rspMsg substringFromIndex:5];
            }
            else
            {
                msg = rspMsg;
            }

            NSLog(@"backgound error msg:%@", msg);

            NSString *msgCode = [[responseObject objectForKey:@"head"] objectForKey:@"rspCode"];
        }

    }  failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"zhenhao-----background error:%@", error);
        failure(task, error);
    }];
}



- (void)backToLogin
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *controller = [board instantiateViewControllerWithIdentifier:@"main_tab_bar_controller"];
    [UIApplication sharedApplication].keyWindow.rootViewController = controller;
    [controller setSelectedIndex:2];
}


@end
