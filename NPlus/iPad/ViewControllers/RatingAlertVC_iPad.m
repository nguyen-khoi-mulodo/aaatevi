//
//  LoginAlertVC_iPad.m
//  NPlus
//
//  Created by Vo Chuong Thien on 4/8/15.
//  Copyright (c) 2015 TEVI Team. All rights reserved.
//

#import "RatingAlertVC_iPad.h"


@interface RatingAlertVC_iPad ()

@end

@implementation RatingAlertVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    ratingView.layer.cornerRadius = 10.0f;
    ratingView.layer.masksToBounds = YES;
    ratingView.delegate = self;
    ratingView.emptySelectedImage = [UIImage imageNamed:@"icon-star3"];
    ratingView.fullSelectedImage = [UIImage imageNamed:@"icon-star1"];
    ratingView.contentMode = UIViewContentModeScaleAspectFill;
    ratingView.maxRating = 5;
    ratingView.minRating = 1;
    ratingView.rating = 4;
    [lbStatus setText:@"Hay"];
    ratingView.editable = YES;
    ratingView.halfRatings = NO;
    ratingView.floatRatings = NO;
    
    [lbTitle setFont:[UIFont fontWithName:kFontSemibold size:20.0f]];
    [lbStatus setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [btnHuy.titleLabel setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [btnRate.titleLabel setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [btnHuy.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [btnHuy.layer setBorderWidth:1.0f];
    btnHuy.layer.cornerRadius = 5.0;
    [btnHuy setClipsToBounds:YES];
    [btnRate.layer setBorderColor:[[UIColor clearColor] CGColor]];
    [btnRate.layer setBorderWidth:1.0f];
    btnRate.layer.cornerRadius = 5.0;
    [btnRate setClipsToBounds:YES];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapClose:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleTapClose: (UITapGestureRecognizer *)recognizer
{
    [self hideRatingView];
}

- (void) hideRatingView{
    [self.view removeFromSuperview];
}

// Implement the UIGestureRecognizerDelegate method
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // Determine if the touch is inside the custom subview
    if ([touch view] == ratingView){
        // If it is, prevent all of the delegate's gesture recognizers
        // from receiving the touch
        return NO;
    }
    return YES;
}

- (IBAction) doClose:(id)sender{
    [self hideRatingView];
}

- (IBAction) doRate:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(doRateWithMark:)]) {
        [self.delegate doRateWithMark:(int)ratingView.rating];
    }
    [self hideRatingView];
}

#pragma mark - TPFloatRatingViewDelegate

- (void)floatRatingView:(TPFloatRatingView *)ratingView ratingDidChange:(CGFloat)rating
{
//    self.ratingLabel.text = [NSString stringWithFormat:@"%.2f", rating];
}

- (void)floatRatingView:(TPFloatRatingView *)ratingView continuousRating:(CGFloat)rating
{
    NSString* status = @"Hay";
    if (rating == 1.0) {
        status = @"Dở tệ";
    }else if (rating == 2.0){
        status = @"Không hay lắm";
    }else if (rating == 3.0){
        status = @"Xem được";
    }else if (rating == 4.0){
        status = @"Hay";
    }else if (rating == 5.0){
        status = @"Xuất sắc";
    }
    lbStatus.text = status;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
