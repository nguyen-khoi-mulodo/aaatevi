//
//  GooglePlusLoginTask.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/2/15.
//  Copyright (c) 2015 TEVI Team. All rights reserved.
//

#import "GooglePlusLoginTask.h"

static GooglePlusLoginTask *shareInstance = nil;

@implementation GooglePlusLoginTask

+ (GooglePlusLoginTask*)shareInstance {
    @synchronized(self){
        if (shareInstance == nil) {
            shareInstance = [[self alloc] init];
        }
    }
    return  shareInstance;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        [self initGooglePlus];
    }
    return self;
}

- (void) initGooglePlus{
    
}

- (BOOL) checkLoginedGooglePlus{
    return NO;
}

- (void)loginGooglePlus{
    
}

- (void)trySilentSignIn:(UIViewController*)vc {
    
}

- (void)logoutGooglePlus{
    
}

// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}


- (void)loginGooglePlusWithUserId:(NSString*)user_gpID avatar:(NSString*)user_gpAvatar fullname:(NSString*)gpFullname username:(NSString*)gpUserName accessKey:(NSString*)gpAccessKey email:(NSString*)gpEmail {
    [[APIController sharedInstance]loginWithGoogleUserId:user_gpID withAvatar:user_gpAvatar withFullName:gpFullname withUserName:gpUserName withAccessKey:gpAccessKey withEmail:gpEmail completed:^(User *result){
        if (result) {
            result.loginType = logingoogleplus;
            [APPDELEGATE setUser:result];
            [[NSNotificationCenter defaultCenter]postNotificationName:kDidLoginNotification object:nil userInfo:nil];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginSuccessWithTask:)]) {
            [self.delegate loginSuccessWithTask:self.theTask];
        }
        
    }failed:^(NSError *error){
        [self showMessage:@"Đăng nhập" withTitle:@"Đăng nhập không thành công!"];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(googlePlusLoginFailed)]) {
//            [self.delegate loginSuccessWithTask:self.theTask];
//        }
    }];
}

- (void)signout {
    
}

- (void)disconnect {
    
}
    
@end
