//
//  UserDefaultManager.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/6/15.
//  Copyright (c) 2015 TEVI Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultManager : NSObject

+ (void)setAccessToken:(NSString*)accessToken;
+ (NSString*)getAccessToken;

@end
