//
//  TokenInfo.h
//  NPlus
//
//  Created by TEVI Team on 10/23/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TokenInfo : NSObject
@property (nonatomic, strong) NSString *token;
@property (nonatomic, assign) long long timeExpire;
@property (nonatomic, strong) NSString *strExpire;
@property (nonatomic, strong) NSString *refToken;
@end
