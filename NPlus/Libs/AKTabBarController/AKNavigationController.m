//
//  AKNavigationController.m
//  NPlus
//
//  Created by TEVI Team on 9/12/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "AKNavigationController.h"
@interface AKNavigationController ()

@end

@implementation AKNavigationController
-(void)viewDidLoad{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
}

- (BOOL)shouldAutorotate {
    if (self.topViewController != nil){
        if ([self.topViewController isKindOfClass:[NowPlayerVC class]] && !APPDELEGATE.nowPlayerVC.isShowNowPlaying) {
            return NO;
        }
        return [self.topViewController shouldAutorotate];
    }else
        return [super shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    if (self.topViewController != nil){
        if ([self.topViewController isKindOfClass:[NowPlayerVC class]] && !APPDELEGATE.nowPlayerVC.isShowNowPlaying) {
            return UIInterfaceOrientationMaskPortrait;
        }
        return [self.topViewController supportedInterfaceOrientations];
    }else
        return [super supportedInterfaceOrientations];
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (self.topViewController != nil)
        return [self.topViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    else
        return [super  willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

-(BOOL)prefersStatusBarHidden{
    if (self.topViewController != nil)
        return [self.topViewController prefersStatusBarHidden];
    else
        return [super  prefersStatusBarHidden];
}


@end
