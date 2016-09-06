//
//  ShareTask.m
//  NPlus
//
//  Created by TEVI Team on 12/7/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "ShareTask.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface ShareTask()
@end
@implementation ShareTask
@synthesize viewController = _viewController;
static  ShareTask *sharedInstance = nil;
+(ShareTask *) sharedInstance{
    @synchronized(self){
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    return  sharedInstance;
}
+(id) allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return  sharedInstance;
        }
    }
    return nil;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        NSLog(@"ShareTask init");
    }
    return self;
}

- (void)shareFacebookWithURL:(NSString*) strURL {
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:strURL];
    content.contentTitle = @"TeVi APP";
    [FBSDKShareDialog showFromViewController:self.viewController
                                 withContent:content
                                    delegate:nil];
}

- (void)shareFacebook:(id)obj{
    if (APPDELEGATE.nowPlayerVC) {
        [APPDELEGATE.nowPlayerVC trackScreen:@"iOS_share_on_facebook"];
    }
    if ([obj isKindOfClass:[Video class]])
    {
        Video *item =  (Video *) obj;
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [mySLComposerSheet setInitialText:item.video_title];
            
            [mySLComposerSheet addURL:[NSURL URLWithString:item.link_share]];
            
            [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
//                        [APPDELEGATE showToastMessage:@"Quá trình chia sẻ thất bại, vui lòng thử lại!"];
                        break;
                    case SLComposeViewControllerResultDone:
//                        NSLog(@"Post Sucessful");
                        [APPDELEGATE showToastWithMessage:@"Bạn đã chia sẻ video lên facebook thành công" position:@"top" type:doneImage];
                        break;
                        
                    default:
                        break;
                }
                [self.viewController dismissViewControllerAnimated:YES completion:^{
                    if (!IS_IPAD) {
                        [APPDELEGATE.nowPlayerVC presentViewFromPlayer:NO];
                    }
                }];
            }];
            
            [self.viewController presentViewController:mySLComposerSheet animated:YES completion:^{
                if (!IS_IPAD) {
                    //[APPDELEGATE.nowPlayerVC willRotateTo:[[UIApplication sharedApplication] statusBarOrientation]];
                    //[APPDELEGATE.nowPlayerVC didRotateTo];
                    [APPDELEGATE.nowPlayerVC presentViewFromPlayer:YES];
                }
            }];
        }else{
            NSString *msg = @"Hãy vui lòng vào \"Settings -> Facebook\" đăng nhập tài khoản để chia sẻ cho bạn bè.";
            [APPDELEGATE showToastWithMessage:msg position:@"top" type:doneImage];
        }
    } else if ([obj isKindOfClass:[Channel class]]) {
        Channel *item = (Channel*)obj;
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [mySLComposerSheet setInitialText:item.channelName];
            
            [mySLComposerSheet addURL:[NSURL URLWithString:item.linkShare]];
            
            [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
                        //                        [APPDELEGATE showToastMessage:@"Quá trình chia sẻ thất bại, vui lòng thử lại!"];
                        break;
                    case SLComposeViewControllerResultDone:
                        //                        NSLog(@"Post Sucessful");
                        [APPDELEGATE showToastWithMessage:@"Bạn đã chia sẻ kênh lên facebook thành công" position:@"top" type:doneImage];
                        break;
                        
                    default:
                        break;
                }
                [self.viewController dismissViewControllerAnimated:YES completion:^{
                    if (!IS_IPAD) {
                        [APPDELEGATE.nowPlayerVC presentViewFromPlayer:NO];
                    }
                }];
            }];
            
            [self.viewController presentViewController:mySLComposerSheet animated:YES completion:^{
                if (!IS_IPAD) {
                    //[APPDELEGATE.nowPlayerVC willRotateTo:[[UIApplication sharedApplication] statusBarOrientation]];
                    //[APPDELEGATE.nowPlayerVC didRotateTo];
                    [APPDELEGATE.nowPlayerVC presentViewFromPlayer:YES];
                }
            }];
        }else{
            NSString *msg = @"Hãy vui lòng vào \"Settings -> Facebook\" đăng nhập tài khoản để chia sẻ cho bạn bè.";
            [APPDELEGATE showToastWithMessage:msg position:@"top" type:doneImage];
        }
    } else if ([obj isKindOfClass:[Artist class]]) {
        Artist *item = (Artist*)obj;
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [mySLComposerSheet setInitialText:item.name];
            
            [mySLComposerSheet addURL:[NSURL URLWithString:item.shortLink]];
            
            [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
                        //                        [APPDELEGATE showToastMessage:@"Quá trình chia sẻ thất bại, vui lòng thử lại!"];
                        break;
                    case SLComposeViewControllerResultDone:
                        //                        NSLog(@"Post Sucessful");
                        [APPDELEGATE showToastWithMessage:@"Bạn đã chia sẻ nghệ sĩ này lên facebook thành công" position:@"top" type:doneImage];
                        break;
                        
                    default:
                        break;
                }
                [self.viewController dismissViewControllerAnimated:YES completion:^{
                    if (!IS_IPAD) {
                        [APPDELEGATE.nowPlayerVC presentViewFromPlayer:NO];
                    }
                }];
            }];
            
            [self.viewController presentViewController:mySLComposerSheet animated:YES completion:^{
                if (!IS_IPAD) {
                    [APPDELEGATE.nowPlayerVC presentViewFromPlayer:YES];
                }
            }];
        }else{
            NSString *msg = @"Hãy vui lòng vào \"Settings -> Facebook\" đăng nhập tài khoản để chia sẻ cho bạn bè.";
            [APPDELEGATE showToastWithMessage:msg position:@"top" type:doneImage];
        }
    }
}

- (void)loadDetailVideo:(NSString*)videoId {
    [[APIController sharedInstance]getVideoDetailWithKey:videoId completed:^(int code, Video *results) {
        if (results) {
            [self shareFacebook:results];
        }
    } failed:^(NSError *error) {
        
    }];
}

@end
