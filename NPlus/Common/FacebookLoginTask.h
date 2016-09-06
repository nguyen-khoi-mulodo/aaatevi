//
//  FacebookLoginTask.h
//
//  Created by Vo Chuong Thien on 12/30/14.
//  Copyright (c) 2014 Facebook Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FacebookLoginTaskDelegate <NSObject>
- (void) loginSuccessWithTask:(NSString*) task;
@optional
- (void) loginFailWithTask:(NSString*) task;
@end

@interface FacebookLoginTask : NSObject{
    id <FacebookLoginTaskDelegate> delegate;
}
@property (nonatomic, strong) id <FacebookLoginTaskDelegate> delegate;
@property (copy, nonatomic) NSString *theTask;

+(FacebookLoginTask *) sharedInstance;
- (BOOL) checkLoginedFacebook;
- (void) loginFacebook;
- (void) logoutFacebook;
@end
