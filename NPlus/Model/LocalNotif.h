//
//  LocalNotif.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/28/16.
//  Copyright © 2016 anhld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotif : NSObject

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *time;

@end
