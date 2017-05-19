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


//设置和获取机构名称
- (void)setBranchName:(NSString *)branchName;

- (NSString *)getBranchName;

//设置和获取机构地址
- (void)setBranchAddress:(NSString *)address;

- (NSString *)getBranchAddress;

//设置和获取纬度
- (void)setLat:(CGFloat)lat;

- (CGFloat)getLat;

//设置和获取经度
- (void)setLng:(CGFloat)lng;

- (CGFloat)getLng;

//设置和获取性别
- (void)setSex:(NSString *)sex;

- (NSString *)getSex;

//设置和获取电话
- (void)setTel:(NSString *)tel;

- (NSString *)getTel;

//设置和获取电梯品牌
- (void)setBrand:(NSString *)brand;

- (NSString *)getBrand;

//设置和获取电梯型号
- (void)setLiftType:(NSString *)type;

- (NSString *)getLiftType;

//设置和获取短信验证码
- (void)setSMCode:(NSString *)code;

- (NSString *)getSMSCode;

@property (copy, nonatomic) NSString *linkName;

@property (copy, nonatomic) NSString *linkTel;

@end


#endif /* Config_h */
