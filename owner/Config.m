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

+ (instancetype)shareConfig {
    static Config *config = nil;

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        config = [[Config alloc] init];
    });

    return config;
}

- (void)setRole:(NSString *)role {
    [self setValue:role key:@"role"];
}

- (NSString *)getRole {
    return [self getValueWithKey:@"role"];
}


- (void)setToken:(NSString *)token {
    [self setValue:token key:@"token"];
}

- (NSString *)getToken {
    NSString *token = [self getValueWithKey:@"token"];

    if (nil == token) {
        token = @"";
    }

    return token;
}

- (void)setUserId:(NSString *)userId {
    [self setValue:userId key:@"user_id"];
}

- (NSString *)getUserId {
    NSString *userId = [self getValueWithKey:@"user_id"];

    if (nil == userId) {
        userId = @"";
    }
    return userId;
}

- (void)setName:(NSString *)name {
    [self setValue:name key:@"name"];
}

- (NSString *)getName {
    return [self getValueWithKey:@"name"];
}


- (void)setBranchId:(NSString *)branchId {
    [self setValue:branchId key:@"branch"];
}

- (NSString *)getBranchId {
    return [self getValueWithKey:@"branch"];
}

- (void)setType:(NSString *)type {
    [self setValue:type key:@"type"];
}

- (NSString *)getType {
    return [self getValueWithKey:@"type"];
}


- (void)setBranchName:(NSString *)branchName {
    [self setValue:branchName key:@"branch_name"];
}

- (NSString *)getBranchName {
    return [self getValueWithKey:@"branch_name"];
}

- (void)setBranchAddress:(NSString *)address {
    [self setValue:address key:@"branch_address"];
}

- (NSString *)getBranchAddress {
    return [self getValueWithKey:@"branch_address"];

}


- (void)setLat:(CGFloat)lat {
    [self setValue:[NSString stringWithFormat:@"%lf", lat] key:@"lat"];
}

- (CGFloat)getLat {
    return [[self getValueWithKey:@"lat"] floatValue];
}


- (void)setLng:(CGFloat)lng {
    [self setValue:[NSString stringWithFormat:@"%lf", lng] key:@"lng"];
}

- (CGFloat)getLng {
    return [[self getValueWithKey:@"lng"] floatValue];
}


//设置和获取性别
- (void)setSex:(NSString *)sex {
    [self setValue:sex key:@"sex"];
}

- (NSString *)getSex {
    return [self getValueWithKey:@"sex"];
}

//设置和获取电话
- (void)setTel:(NSString *)tel {
    [self setValue:tel key:@"tel"];
}

- (NSString *)getTel {
    return [self getValueWithKey:@"tel"];
}


//设置和获取电梯品牌
- (void)setBrand:(NSString *)brand {
    [self setValue:brand key:@"brand"];
}

- (NSString *)getBrand {
    return [self getValueWithKey:@"brand"];
}

//设置和获取电梯型号
- (void)setLiftType:(NSString *)type {
    [self setValue:type key:@"lift_type"];
}

- (NSString *)getLiftType {
    return [self getValueWithKey:@"lift_type"];
}

//设置和获取用户账号名
- (void)setUserName:(NSString *)userName {
    [self setValue:userName key:@"user_name"];
}

- (NSString *)getUserName {
    return [self getValueWithKey:@"user_name"];
}

//设置和获取短信验证码
- (void)setSMCode:(NSString *)code {
    [self setValue:code key:@"sms_code"];
}

- (NSString *)getSMSCode {
    return [self getValueWithKey:@"sms_code"];
}

//设置和获取联系人电话
- (void)setLinkTel:(NSString *)linkTel {
    [self setValue:linkTel key:@"link_tel"];
}

- (NSString *)linkTel {
    return [self getValueWithKey:@"link_tel"];
}

//设置和获取联系人姓名
- (void)setLinkName:(NSString *)linkName {
    [self setValue:linkName key:@"link_name"];
}

- (NSString *)linkName {
    return [self getValueWithKey:@"link_name"];
}


#pragma mark -- common method

- (void)setValue:(NSObject *)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

- (id)getValueWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

@end
