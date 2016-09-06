//
//  LoginAlertVC_iPad.h
//  NPlus
//
//  Created by Vo Chuong Thien on 4/8/15.
//  Copyright (c) 2015 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "TPFloatRatingView.h"

@protocol RatingAlertDelegate <NSObject>
- (void) doRateWithMark:(int) mark;
@end

@interface RatingAlertVC_iPad : UIViewController <UIGestureRecognizerDelegate, TPFloatRatingViewDelegate>
{
    IBOutlet TPFloatRatingView* ratingView;
    IBOutlet UILabel* lbStatus;
    IBOutlet UILabel* lbTitle;
    IBOutlet UIButton* btnHuy;
    IBOutlet UIButton* btnRate;
    float markCurrent;
}
@property (nonatomic, strong) id <RatingAlertDelegate> delegate;

@end
