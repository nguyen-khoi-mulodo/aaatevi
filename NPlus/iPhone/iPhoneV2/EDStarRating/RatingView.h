//
//  RatingView.h
//  NPlus
//
//  Created by Khoi Nguyen on 2/1/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"
#import "EDStarRating.h"

@protocol RatingViewDelegate <NSObject>

- (void)didSubmitRatingValue:(float)value;

@end

@interface RatingView : UIView <EDStarRatingProtocol,UIGestureRecognizerDelegate> {
    UITapGestureRecognizer *_gesture;
}
@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel;
@property (weak, nonatomic) IBOutlet EDStarRating *ratingView;
@property (weak, nonatomic) IBOutlet MyButton *btnDanhgia;
@property (weak, nonatomic) IBOutlet MyButton *btnCancel;


@property (strong, nonatomic) id<RatingViewDelegate> delegate;
@property float ratingValue;

- (id)initWithFrame:(CGRect)frame;
- (void)loadView;
- (void)hiddenView;

@end
