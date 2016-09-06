//
//  VersionEntity.h
//  NPlus
//
//  Created by TEVI Team on 12/2/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionEntity : NSObject
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, assign) BOOL foreUpdate;
@property (nonatomic, strong) NSString* news;
@property (nonatomic, assign) BOOL isUpdate;
@end
