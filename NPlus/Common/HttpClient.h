//
//  HttpClient.h
//  NPlus
//
//  Created by TEVI Team on 7/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpClient : NSObject
- (void)requestFromURL:(NSString*)url_string completed:(void(^)(id responseObject, NSString *json))_completed failed:(void (^)(NSError* error))_failed;
- (void)getWithURL:(NSString *)url_string withParams:(NSDictionary*)params completed:(void (^)(id responseObject, NSString *json))_completed failed:(void (^)(NSError* error))_failed;
- (void)postWithURL:(NSString *)url_string withParams:(NSDictionary*)params completed:(void (^)(id responseObject, NSString *json))_completed failed:(void (^)(NSError* error))_failed;
- (void)postWithNonSerializerURL:(NSString *)url_string withParams:(NSDictionary*)params completed:(void (^)(id responseObject, NSString *json))_completed failed:(void (^)(NSError* error))_failed;
@end
