//
//  User.h
//  NhacCuaTui
//
//  Created by Nguyen Chinh Ngoc Lam on 2/3/13.
//  Copyright (c) 2013 NCT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"

@interface User : NSObject
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * passWord;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * userID;
@property (nonatomic)         BOOL powerUser;
@property (nonatomic, strong) NSString * expire;
@property (nonatomic, strong) NSString * fullName;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * accesskey;
@property (nonatomic, strong) NSString * displayName;
@property (nonatomic) Login_Type loginType;
@end
