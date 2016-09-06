//
//  LoginAlertVC_iPad.h
//  NPlus
//
//  Created by Vo Chuong Thien on 4/8/15.
//  Copyright (c) 2015 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@protocol LoginAlertDelegate <NSObject>
- (void) loginSuccessWithTask:(NSString *)task;
- (void) loginWithTask:(NSString*) task;
@end

@interface LoginAlertVC_iPad : UIViewController <UIGestureRecognizerDelegate,FacebookLoginTaskDelegate>
{
    IBOutlet UIView* loginAlertView;
    IBOutlet UILabel* lbTitleHeader;
    IBOutlet UILabel* lbNotifLogin;

}
@property (nonatomic, strong) id <LoginAlertDelegate> delegate;
@property (nonatomic, strong) NSString* task;
@property (nonatomic, strong) id viewcontroller;
@end
