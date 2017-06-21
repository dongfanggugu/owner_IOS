//
//  HttpClient.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef HttpClient_h
#define HttpClient_h

#import <AFNetworking.h>

@interface HttpClient : AFHTTPSessionManager

+ (instancetype)shareClient;

- (void)post:(NSString *)url parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *task, id responseObject)) success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *errr)) failure;

- (void)bagpost:(NSString *)url parameters:(id)parameters
        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)post:(NSString *)url head:(id)head body:(id)body
     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


@end

#endif /* HttpClient_h */
