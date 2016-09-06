//
//  UserDefaultManager.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/6/15.
//  Copyright (c) 2015 TEVI Team. All rights reserved.
//

#import "UserDefaultManager.h"

@implementation UserDefaultManager

+ (void)setAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (NSString*)getAccessToken {
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"accessToken"]) {
        return [[NSUserDefaults standardUserDefaults]objectForKey:@"accessToken"];
    }
    return nil;
}
@end
