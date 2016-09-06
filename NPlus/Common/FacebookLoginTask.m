//
//  FacebookLoginTask.m
//
//  Created by Vo Chuong Thien on 12/30/14.
//  Copyright (c) 2014 Facebook Inc. All rights reserved.
//

#import "FacebookLoginTask.h"
#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation FacebookLoginTask
@synthesize delegate;
@synthesize theTask;

static  FacebookLoginTask *sharedInstance = nil;

+(FacebookLoginTask *) sharedInstance{
    @synchronized(self){
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    return  sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

- (BOOL) checkLoginedFacebook{
    
    if ([FBSDKAccessToken currentAccessToken]) {
        return YES;
    }
    return NO;
}

-(void)loginFacebook
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [login
        logInWithReadPermissions: @[@"public_profile",@"email",@"user_friends"]
        fromViewController:(id)self.delegate
        handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error) {
                NSLog(@"Process error");
                //[self logoutFacebook];
                if ([FBSDKAccessToken currentAccessToken]) {
                    [self refreshFBToken];
                }
                [APPDELEGATE showToastWithMessage:@"Đăng nhập không thành công!" position:@"top" type:errorImage];
                if (self.delegate && [self.delegate respondsToSelector:@selector(loginFailWithTask:)]) {
                    [self.delegate loginFailWithTask:self.theTask];
                }
            } else if (result.isCancelled) {
                NSLog(@"Cancelled");
            } else {
                NSLog(@"Logged in");
                [self getFacebokkProfiles];
            }
        }];
}

- (void)getFacebokkProfiles {
    
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields": @"name,picture.width(160).height(160),email"}];
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if(result)
        {
            NSString *email = @"";
            NSString *name = @"";
            NSString *avatar = @"";
            NSString *fbId = @"";
            NSString *fbAccessKey = [FBSDKAccessToken currentAccessToken].tokenString;
            NSLog(@"FB AccessToken: %@",fbAccessKey);
            if ([result objectForKey:@"email"]) {
                email = [result objectForKey:@"email"];
                NSLog(@"Email: %@",email);
            }
            if ([result objectForKey:@"name"]) {
                name = [result objectForKey:@"name"];
                NSLog(@"Name : %@",name);
            }
            if ([result objectForKey:@"picture"]) {
                NSDictionary *picDict = [result objectForKey:@"picture"];
                NSDictionary *data = [picDict objectForKey:@"data"];
                avatar = [data objectForKey:@"url"];
                NSLog(@"User avatar : %@",avatar);
            }
            if ([result objectForKey:@"id"]) {
                fbId = [result objectForKey:@"id"];
                NSLog(@"FB Id: %@",fbId);
            }
            [self loginWithFacebookUserId:fbId fullname:name email:email fbAvatar:avatar];
        }
    }];
    [connection start];
}

- (void)refreshFBToken {
    [FBSDKAccessToken refreshCurrentAccessToken:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if(result)
        {
            NSString *email = @"";
            NSString *name = @"";
            NSString *avatar = @"";
            NSString *fbId = @"";
            NSString *fbAccessKey = [FBSDKAccessToken currentAccessToken].tokenString;
            NSLog(@"FB AccessToken: %@",fbAccessKey);
            if ([result objectForKey:@"email"]) {
                email = [result objectForKey:@"email"];
                NSLog(@"Email: %@",email);
            }
            if ([result objectForKey:@"name"]) {
                name = [result objectForKey:@"name"];
                NSLog(@"Name : %@",name);
            }
            if ([result objectForKey:@"picture"]) {
                NSDictionary *picDict = [result objectForKey:@"picture"];
                NSDictionary *data = [picDict objectForKey:@"data"];
                avatar = [data objectForKey:@"url"];
                NSLog(@"User avatar : %@",avatar);
            }
            if ([result objectForKey:@"id"]) {
                fbId = [result objectForKey:@"id"];
                NSLog(@"FB Id: %@",fbId);
            }
            [self loginWithFacebookUserId:fbId fullname:name email:email fbAvatar:avatar];
        }
    }];
}

- (void) logoutFacebook{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    APPDELEGATE.user = nil;
    APPDELEGATE.isLogined = NO;
    [Utilities setLogined:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidLogoutNotification object:nil];
}

- (void)loginWithFacebookUserId:(NSString*)fbUserId fullname:(NSString*)fbFullname email:(NSString*)fbEmail fbAvatar:(NSString*) fbAvatar{
    [[APIController sharedInstance]loginWithFacebookUserId:fbUserId withFullName:fbFullname withEmail:fbEmail completed:^(User *result) {
        if (result) {
            APPDELEGATE.isLogined = YES;
            [Utilities setLogined:YES];
            [Utilities setUserInfoWithEmail:fbEmail name:result.displayName fbUsername:result.userName avatar:fbAvatar];
            result.avatar = fbAvatar;
            [APPDELEGATE setUser:result];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidLoginNotification object:nil];
            if (self.delegate && [self.delegate respondsToSelector:@selector(loginSuccessWithTask:)]) {
                [self.delegate loginSuccessWithTask:self.theTask];
            }
        } else {
            APPDELEGATE.isLogined = NO;
            [Utilities setLogined:NO];
            APPDELEGATE.user = nil;
            [APPDELEGATE showToastWithMessage:@"Đăng nhập không thành công!" position:@"top" type:errorImage];
            if (self.delegate && [self.delegate respondsToSelector:@selector(loginFailWithTask:)]) {
                [self.delegate loginFailWithTask:self.theTask];
            }
        }
        
    } failed:^(NSError *error) {
        APPDELEGATE.isLogined = NO;
        [Utilities setLogined:NO];
        APPDELEGATE.user = nil;
        [APPDELEGATE showToastWithMessage:@"Đăng nhập không thành công!" position:@"top" type:errorImage];
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginFailWithTask:)]) {
            [self.delegate loginFailWithTask:self.theTask];
        }
    }];
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

@end
