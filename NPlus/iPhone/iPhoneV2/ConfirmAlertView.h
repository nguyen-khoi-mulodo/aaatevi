//
//  ConfirmAlertView.h
//  NPlus
//
//  Created by Admin on 5/16/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConfirmAlertDelegate <NSObject>

- (void) cancel;
- (void) remove;

@end

@interface ConfirmAlertView : UIViewController<UIGestureRecognizerDelegate> {
    IBOutlet UIView* infoView;
    IBOutlet UIButton* btnCancel;
    IBOutlet UIButton* btnRemove;
}
@property (nonatomic, strong) id <ConfirmAlertDelegate> delegate;
@end
