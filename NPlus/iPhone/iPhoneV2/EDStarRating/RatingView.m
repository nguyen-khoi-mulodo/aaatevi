//
//  RatingView.m
//  NPlus
//
//  Created by Khoi Nguyen on 2/1/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "RatingView.h"

@implementation RatingView
- (void)tapGesture:(id)sender {
//    UIEvent *event = [[UIEvent alloc] init];
//    CGPoint location = [_gesture locationInView:self];
//    
//    //check actually view you hit via hitTest
//    UIView *view = [self hitTest:location withEvent:event];
//    
//    if ([view.gestureRecognizers containsObject:_gesture]) {
//        //your UIView
//        //do something
//        [self hiddenView];
//    }
//    else {
//        //your UITableView or some thing else...
//        //ignore
//        
//    }
    
}
- (IBAction)btnCancelAction:(id)sender {
    [self hiddenView];
}
- (IBAction)btnDanhgiaAction:(id)sender {
    [self hiddenView];
    [_delegate didSubmitRatingValue:_ratingValue];
    
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadView];
    }
    return self;
}

- (void) hiddenView {
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)loadView {
//    _gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
//    _gesture.delegate = self;
//    [self addGestureRecognizer:_gesture];
    self.translatesAutoresizingMaskIntoConstraints = YES;
    self.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
    _popupView.clipsToBounds = YES;
    _popupView.layer.cornerRadius = 8;
    [self bringSubviewToFront:_popupView];
    _ratingView.starImage = [UIImage imageNamed:@"icon-star3"];
    _ratingView.starHighlightedImage = [UIImage imageNamed:@"icon-star1"];
    _ratingView.maxRating = 5.0;
    _ratingView.delegate = self;
    _ratingView.horizontalMargin = 12;
    _ratingView.editable=YES;
    _ratingView.rating= 4.0;
    _ratingView.displayMode=EDStarRatingDisplayFull;
    [self starsSelectionChanged:_ratingView rating:0.0];
    // This one will use the returnBlock instead of the delegate
    _ratingView.returnBlock = ^(float rating )
    {
        //NSLog(@"ReturnBlock: Star rating changed to %.1f", rating);
        // For the sample, Just reuse the other control's delegate method and call it
        [self starsSelectionChanged:_ratingView rating:rating];
    };
    _lblLevel.text = @"Hay quá";
    _lblLevel.textColor = UIColorFromRGB(0x8BC34A);
    _btnDanhgia.layer.cornerRadius = 5;
    _btnCancel.layer.cornerRadius = 5;
    _btnCancel.clipsToBounds = YES;
    _btnCancel.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.7].CGColor;
    _btnCancel.layer.borderWidth = 0.5;
    self.alpha = 0.0f;
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    _ratingValue = rating;
    if (_ratingValue == 1) {
        _lblLevel.text = @"Dở tệ";
        _lblLevel.textColor = UIColorFromRGB(0x212121);
    } else if (_ratingValue == 2) {
        _lblLevel.text = @"Không hay lắm";
        _lblLevel.textColor = UIColorFromRGB(0x212121);
    } else if (_ratingValue == 3) {
        _lblLevel.text = @"Bình thường";
        _lblLevel.textColor = UIColorFromRGB(0x212121);
    } else if (_ratingValue == 4) {
        _lblLevel.text = @"Hay quá";
        _lblLevel.textColor = UIColorFromRGB(0x8BC34A);
    } else if (_ratingValue == 5) {
        _lblLevel.text = @"Tuyệt vời";
        _lblLevel.textColor = UIColorFromRGB(0xFF6029);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    return YES;
}

@end
