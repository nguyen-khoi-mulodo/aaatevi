//
//  Artist.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 2/23/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Artist : NSObject

@property (nonatomic, assign) long artistId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *fullDes;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *blood;
@property (nonatomic, strong) NSString *national;
@property (nonatomic, strong) NSString *avatarImg;
@property (nonatomic, strong) NSString *coverImg;
@property (nonatomic, strong) NSString *shortLink;


@end
