//
//  ShareTask.h
//  NPlus
//
//  Created by TEVI Team on 12/7/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Video.h"
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface ShareTask :NSObject
+(ShareTask *) sharedInstance;
@property (nonatomic, assign) UIViewController *viewController;
- (void) shareFacebook :(id) obj;
- (void)shareFacebookWithURL:(NSString*) strURL;
- (void)loadDetailVideo:(NSString*)videoId;
@end
