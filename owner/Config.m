//
//  Config.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/28.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"

@implementation Config

+ (instancetype)shareConfig
{
    static Config *config = nil;

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        config = [[Config alloc] init];
    });

    return config;
}

- (void)clearUserInfo
{
    [self setToken:@""];
    [self setUserId:@""];
    [self setUserName:@""];
    [self setName:@""];
    [self setTel:@""];
}

- (void)setToken:(NSString *)token
{
    [self setValue:token key:@"token"];
}

- (NSString *)getToken
{
    NSString *token = [self getValueWithKey:@"token"];

    if (nil == token)
    {
        token = @"";
    }

    return token;
}

- (void)setUserId:(NSString *)userId
{
    [self setValue:userId key:@"user_id"];
}

- (NSString *)getUserId
{
    NSString *userId = [self getValueWithKey:@"user_id"];

    if (nil == userId)
    {
        userId = @"";
    }
    return userId;
}

- (void)setName:(NSString *)name
{
    [self setValue:name key:@"name"];
}

- (NSString *)getName
{
    return [self getValueWithKey:@"name"];
}

//设置和获取电话
- (void)setTel:(NSString *)tel
{
    [self setValue:tel key:@"tel"];
}

- (NSString *)getTel
{
    return [self getValueWithKey:@"tel"];
}

//设置和获取用户账号名
- (void)setUserName:(NSString *)userName
{
    [self setValue:userName key:@"user_name"];
}

- (NSString *)getUserName
{
    return [self getValueWithKey:@"user_name"];
}

//设置和获取短信验证码
- (void)setSMCode:(NSString *)code
{
    [self setValue:code key:@"sms_code"];
}

- (NSString *)getSMSCode
{
    return [self getValueWithKey:@"sms_code"];
}


#pragma mark -- common method

- (void)setValue:(NSObject *)value key:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

- (id)getValueWithKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

@end
