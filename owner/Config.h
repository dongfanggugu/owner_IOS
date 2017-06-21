//
//  Config.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/28.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef Config_h
#define Config_h

@interface Config : NSObject

+ (instancetype)shareConfig;

- (void)clearUserInfo;

//设置和获取accessToken
- (void)setToken:(NSString *)token;

- (NSString *)getToken;


//设置和获取userId
- (void)setUserId:(NSString *)userId;

- (NSString *)getUserId;

//设置和获取用户姓名
- (void)setName:(NSString *)name;

- (NSString *)getName;


//设置和获取用户账号名
- (void)setUserName:(NSString *)userName;

- (NSString *)getUserName;


//设置和获取电话
- (void)setTel:(NSString *)tel;

- (NSString *)getTel;


//设置和获取短信验证码
- (void)setSMCode:(NSString *)code;

- (NSString *)getSMSCode;

@end


#endif /* Config_h */
