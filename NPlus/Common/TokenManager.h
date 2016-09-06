//
//  TokenManager.h
//  NPlus
//
//  Created by TEVI Team on 10/23/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TokenInfo.h"
@interface TokenManager : NSObject
+(TokenManager *) sharedInstance;
@property (nonatomic, strong) TokenInfo *tokenInfo;
- (void)loadDataWithAccessToken:(void(^)(NSString* accessToken))_completed failed:(void (^)(NSError* error))_failed;
- (void)setToken:(TokenInfo*)info;
@end
