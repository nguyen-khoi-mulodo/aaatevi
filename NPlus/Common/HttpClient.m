//
//  HttpClient.m
//  NPlus
//
//  Created by TEVI Team on 7/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "HttpClient.h"
#import "AFNetworking.h"

@implementation HttpClient
-(void)requestFromURL:(NSString *)url_string completed:(void (^)(id, NSString *))_completed failed:(void (^)(NSError *))_failed{
#if DEBUG_URL
    NSLog(@"url: %@", url_string);
#endif
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:url_string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _completed(responseObject, operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _failed(error);
    }];
}
-(void)getWithURL:(NSString *)url_string withParams:(NSDictionary *)params completed:(void (^)(id, NSString *))_completed failed:(void (^)(NSError *))_failed{
#if DEBUG_URL
    NSLog(@"url: %@", url_string);
#endif
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:url_string parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _completed(responseObject, operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *er = [NSError errorWithDomain:error.domain code:operation.response.statusCode userInfo:operation.responseObject];
        _failed(er);
    }];
}
-(void)postWithURL:(NSString *)url_string withParams:(NSDictionary *)params completed:(void (^)(id, NSString *))_completed failed:(void (^)(NSError *))_failed{
#if DEBUG_URL
    NSLog(@"url: %@", url_string);
#endif
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:url_string parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _completed(responseObject, operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *er = [NSError errorWithDomain:error.domain code:operation.response.statusCode userInfo:operation.responseObject];
        _failed(er);
    }];
}

-(void)postWithNonSerializerURL:(NSString *)url_string withParams:(NSDictionary *)params completed:(void (^)(id, NSString *))_completed failed:(void (^)(NSError *))_failed {
#if DEBUG_URL
    NSLog(@"url: %@", url_string);
#endif
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:url_string parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _completed(responseObject, operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *er = [NSError errorWithDomain:error.domain code:operation.response.statusCode userInfo:operation.responseObject];
        _failed(er);
    }];
}

@end
