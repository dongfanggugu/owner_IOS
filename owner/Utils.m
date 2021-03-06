//
//  Utils.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Utils

+ (NSString *)getServer
{
    return [NSString stringWithFormat:@"%@mobile/", [Utils getIp]];
}

+ (NSString *)getIp
{
    return @"http://www.chorstar.com:8081/";
    //return @"http://192.168.0.82:8080/";
}



/**
 *  MD5加密
 */
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
    ];
}

+ (BOOL)isEmpty:(NSString *)string
{
    return !string.length;
}


+ (UIColor *)getColorByRGB:(NSString *)RGB
{

    if (RGB.length != 7)
    {
        NSLog(@"illegal RGB value!");
        return [UIColor clearColor];
    }

    if (![RGB hasPrefix:@"#"])
    {
        NSLog(@"illegal RGB value!");
        return [UIColor clearColor];
    }

    NSString *colorString = [RGB substringFromIndex:1];

    NSRange range;
    range.location = 0;
    range.length = 2;

    NSString *red = [colorString substringWithRange:range];

    range.location = 2;
    NSString *green = [colorString substringWithRange:range];

    range.location = 4;
    NSString *blue = [colorString substringWithRange:range];

    unsigned int r, g, b;
    [[NSScanner scannerWithString:red] scanHexInt:&r];
    [[NSScanner scannerWithString:green] scanHexInt:&g];
    [[NSScanner scannerWithString:blue] scanHexInt:&b];
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0];
}


+ (NSString *)format:(NSString *)content with:(NSString *)seperator
{
    return [content stringByReplacingOccurrencesOfString:seperator withString:@"\n"];
}


/**
 *  检测是否为合法的年龄 1-99
 *

 */
+ (BOOL)isLegalAge:(NSString *)age
{
    NSString *ageRegex = @"^([1-9]\\d{0,1})$";
    NSPredicate *ageTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ageRegex];
    return [ageTest evaluateWithObject:age];
}

/**
 *  手机号码是否合法

 */
+ (BOOL)isCorrectPhoneNumberOf:(NSString *)phoneNumber
{

    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,5-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phoneNumber];
}

+ (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [format stringFromDate:date];

    return dateStr;
}

+ (NSString *)getCurrentTime
{
    NSDate *date = [[NSDate alloc] init];
    return [self formatDate:date];
}

+ (NSInteger)character:(NSString *)ch atIndexOfString:(NSString *)string
{
    if (ch.length != 1)
    {
        return -1;
    }

    NSRange range = [string rangeOfString:ch];

    return range.location;
}

+ (NSString *)string:(NSString *)string substringBeforeChar:(NSString *)ch
{
    NSInteger index = [self character:ch atIndexOfString:string];

    NSRange range = NSMakeRange(0, index);

    return [string substringWithRange:range];
}

/** 图片转换为base64码 **/
+ (NSString *)image2Base64From:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSString *base64Code = [data base64Encoding];
    return base64Code;
}

@end
