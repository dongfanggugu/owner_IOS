//
//  Utils.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef Utils_h
#define Utils_h

@interface Utils : NSObject

+ (NSString *)getServer;

+ (NSString *)md5:(NSString *)str;

+ (BOOL) isEmpty:(NSString *)string;

+ (UIColor *)getColorByRGB:(NSString *)RGB;

/**
 将字符串把给定的分隔符转换为回车换行
 **/
+ (NSString *)format:(NSString *)content with:(NSString *)seperator;


+ (BOOL)isLegalAge:(NSString *)age;

/**
 *  手机号码是否合法
 *
 *  @param phoneNumber <#phoneNumber description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)isCorrectPhoneNumberOf:(NSString *)phoneNumber;



+ (NSString *)getCurrentTime;

+ (NSString *)getIp;




/**
 截取字符串

 @param ch <#ch description#>
 @param string <#string description#>
 @return <#return value description#>
 */
+ (NSInteger)character:(NSString *)ch atIndexOfString:(NSString *)string;

+ (NSString *)string:(NSString *)string substringBeforeChar:(NSString *)ch;



/**
 图片转换为base64

 @return <#return value description#>
 */
+ (NSString *)image2Base64From:(UIImage *)image;

@end


#endif /* Utils_h */
