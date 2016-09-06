//
//  UIView+Toast.m
//  Toast
//  Version 2.2
//
//  Copyright 2013 Charles Scalesse.
//

#import "UIView+Toast.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

/*
 *  CONFIGURE THESE VALUES TO ADJUST LOOK & FEEL,
 *  DISPLAY DURATION, ETC.
 */

// general appearance
static const CGFloat CSToastMaxWidth            = 1.0;      // 80% of parent view width
static const CGFloat CSToastMaxHeight           = 0.8;      // 80% of parent view height
static const CGFloat CSToastHorizontalPadding   = 10.0;
static const CGFloat CSToastVerticalPadding     = 10.0;
static const CGFloat CSToastCornerRadius        = 0.0;
static const CGFloat CSToastOpacity             = 0.7;
static const CGFloat CSToastFontSize            = 18.0;
static const CGFloat CSToastMaxTitleLines       = 0;
static const CGFloat CSToastMaxMessageLines     = 0;
static const NSTimeInterval CSToastFadeDuration = 0.2;

// shadow appearance
static const CGFloat CSToastShadowOpacity       = 0.8;
static const CGFloat CSToastShadowRadius        = 6.0;
static const CGSize  CSToastShadowOffset        = { 4.0, 4.0 };
static const BOOL    CSToastDisplayShadow       = NO;

// display duration and position
static const NSString * CSToastDefaultPosition  = @"bottom";
static const NSTimeInterval CSToastDefaultDuration  = 3.0;

// image view size
static const CGFloat CSToastImageViewWidth      = 80.0;
static const CGFloat CSToastImageViewHeight     = 80.0;

// activity
static const CGFloat CSToastActivityWidth       = 100.0;
static const CGFloat CSToastActivityHeight      = 100.0;
static const NSString * CSToastActivityDefaultPosition = @"center";

// interaction
static const BOOL CSToastHidesOnTap             = YES;     // excludes activity views

// associative reference keys
static const NSString * CSToastTimerKey         = @"CSToastTimerKey";
static const NSString * CSToastActivityViewKey  = @"CSToastActivityViewKey";
@interface UIView (ToastPrivate)

- (void)hideToast:(UIView *)toast;
- (void)toastTimerDidFinish:(NSTimer *)timer;
- (void)handleToastTapped:(UITapGestureRecognizer *)recognizer;
- (CGPoint)centerPointForPosition:(id)position withToast:(UIView *)toast;
- (UIView *)viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image;
- (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end


@implementation UIView (Toast)

#pragma mark - Toast Methods

- (void)makeToast:(NSString *)message {
    [self makeToast:message duration:CSToastDefaultDuration position:CSToastDefaultPosition];
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position {
    UIView *toast = [self viewForMessage:message title:nil image:nil];
    [toast setTag:2000];
    [self showToast:toast duration:duration position:position];
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position title:(NSString *)title {
    UIView *toast = [self viewForMessage:message title:title image:nil];
    [self showToast:toast duration:duration position:position];
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position image:(UIImage *)image {
    UIView *toast = [self viewForMessage:message title:nil image:image];
    [self showToast:toast duration:duration position:position];  
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration  position:(id)position title:(NSString *)title image:(UIImage *)image {
    UIView *toast = [self viewForMessage:message title:title image:image];
    [self showToast:toast duration:duration position:position];  
}

- (void)showToast:(UIView *)toast {
    [self showToast:toast duration:CSToastDefaultDuration position:CSToastDefaultPosition];
}

- (void)showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(id)point {
    toast.center = [self centerPointForPosition:point withToast:toast];
    toast.alpha = 0.0;
    
    if (CSToastHidesOnTap) {
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:toast action:@selector(handleToastTapped:)];
        [toast addGestureRecognizer:recognizer];
        toast.userInteractionEnabled = YES;
        toast.exclusiveTouch = YES;
    }
    UIView* oldToast = [self viewWithTag:2000];
    if (oldToast) {
        [oldToast removeFromSuperview];
    }
    [self addSubview:toast];
    
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(toastTimerDidFinish:) userInfo:toast repeats:NO];
                         // associate the timer with the toast view
                         objc_setAssociatedObject (toast, &CSToastTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
    
}

- (void)hideToast:(UIView *)toast {
    APPDELEGATE.isShowingNotif = NO;
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         toast.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [toast removeFromSuperview];
                     }];
}

#pragma mark - Events

- (void)toastTimerDidFinish:(NSTimer *)timer {
    [self hideToast:(UIView *)timer.userInfo];
}

- (void)handleToastTapped:(UITapGestureRecognizer *)recognizer {
    NSTimer *timer = (NSTimer *)objc_getAssociatedObject(self, &CSToastTimerKey);
    [timer invalidate];
    
    [self hideToast:recognizer.view];
}

#pragma mark - Toast Activity Methods

- (void)makeToastActivity {
    [self makeToastActivity:CSToastActivityDefaultPosition];
}

- (void)makeToastActivity:(id)position {
    // sanity
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &CSToastActivityViewKey);
    if (existingActivityView != nil) return;
    
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CSToastActivityWidth, CSToastActivityHeight)];
    activityView.center = [self centerPointForPosition:position withToast:activityView];
    activityView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:CSToastOpacity];
    activityView.alpha = 0.0;
    activityView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    activityView.layer.cornerRadius = CSToastCornerRadius;
    
    if (CSToastDisplayShadow) {
        activityView.layer.shadowColor = [UIColor blackColor].CGColor;
        activityView.layer.shadowOpacity = CSToastShadowOpacity;
        activityView.layer.shadowRadius = CSToastShadowRadius;
        activityView.layer.shadowOffset = CSToastShadowOffset;
    }
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = CGPointMake(activityView.bounds.size.width / 2, activityView.bounds.size.height / 2);
    [activityView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    // associate the activity view with self
    objc_setAssociatedObject (self, &CSToastActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:activityView];
    
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         activityView.alpha = 1.0;
                     } completion:nil];
}

- (void)hideToastActivity {
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &CSToastActivityViewKey);
    if (existingActivityView != nil) {
        [UIView animateWithDuration:CSToastFadeDuration
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             existingActivityView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [existingActivityView removeFromSuperview];
                             objc_setAssociatedObject (self, &CSToastActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }];
    }
}

#pragma mark - Helpers

- (CGPoint)centerPointForPosition:(id)point withToast:(UIView *)toast {
    if([point isKindOfClass:[NSString class]]) {
        // convert string literals @"top", @"bottom", @"center", or any point wrapped in an NSValue object into a CGPoint
        if([point caseInsensitiveCompare:@"top"] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width/2, (toast.frame.size.height / 2) + CSToastVerticalPadding*2);
        } else if([point caseInsensitiveCompare:@"bottom"] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width/2, (self.bounds.size.height - (toast.frame.size.height / 2)) - (IS_IPAD ? 70 : 50));
        } else if([point caseInsensitiveCompare:@"center"] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        }
    } else if ([point isKindOfClass:[NSValue class]]) {
        return [point CGPointValue];
    }
    
    NSLog(@"Warning: Invalid position for toast.");
    return [self centerPointForPosition:CSToastDefaultPosition withToast:toast];
}

- (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        CGRect boundingRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
    }

    return [string sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:lineBreakMode];
}

- (UIView *)viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image {
    // sanity
    if((message == nil) && (title == nil) && (image == nil)) return nil;

    // dynamically build a toast view with any combination of message, title, & image.
    UILabel *messageLabel = nil;
    //UILabel *titleLabel = nil;
    UIImageView *imageView = nil;
    UIImageView *cancelImg = nil;
    
    // create the parent view
    ToasView *wrapperView = [[ToasView alloc] init];
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = CSToastCornerRadius;
    
    if (CSToastDisplayShadow) {
        wrapperView.layer.shadowColor = [UIColor blackColor].CGColor;
        wrapperView.layer.shadowOpacity = CSToastShadowOpacity;
        wrapperView.layer.shadowRadius = CSToastShadowRadius;
        wrapperView.layer.shadowOffset = CSToastShadowOffset;
    }

    wrapperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:CSToastOpacity];
    
    if(image != nil) {
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(CSToastHorizontalPadding, CSToastVerticalPadding, 30, 30);
    }
    
    cancelImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-x-w-v2"]];
    cancelImg.contentMode = UIViewContentModeScaleAspectFit;
    cancelImg.frame = CGRectMake(SCREEN_SIZE.width - 38, 15, 18, 18);
    
    CGFloat imageWidth, imageHeight, imageLeft;
    
    // the imageView frame values will be used to size & position the other views
    if(imageView != nil) {
        imageWidth = imageView.bounds.size.width;
        imageHeight = imageView.bounds.size.height;
        imageLeft = CSToastHorizontalPadding;
    } else {
        imageWidth = imageHeight = imageLeft = 0.0;
    }
    
    if (title != nil) {
//        titleLabel = [[UILabel alloc] init];
//        titleLabel.numberOfLines = CSToastMaxTitleLines;
////        titleLabel.font = [UIFont boldSystemFontOfSize:CSToastFontSize];
//        titleLabel.textAlignment = NSTextAlignmentLeft;
//        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        titleLabel.textColor = [UIColor whiteColor];
//        titleLabel.backgroundColor = [UIColor clearColor];
//        titleLabel.alpha = 1.0;
//        titleLabel.text = title;
//        
//        // size the title label according to the length of the text
//        CGSize maxSizeTitle = CGSizeMake((self.bounds.size.width * CSToastMaxWidth) - imageWidth - cancelImg.frame.size.width, self.bounds.size.height * CSToastMaxHeight);
//        CGSize expectedSizeTitle = [self sizeForString:title font:titleLabel.font constrainedToSize:maxSizeTitle lineBreakMode:titleLabel.lineBreakMode];
//        titleLabel.frame = CGRectMake(0.0, 0.0, expectedSizeTitle.width, expectedSizeTitle.height);
    }
    
    if (message != nil) {
        messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = CSToastMaxMessageLines;
//        messageLabel.font = [UIFont systemFontOfSize:CSToastFontSize];
        [messageLabel setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        if (IS_IPAD) {
            messageLabel.textAlignment = NSTextAlignmentCenter;
        }else{
            messageLabel.textAlignment = NSTextAlignmentLeft;
        }
        messageLabel.alpha = 1.0;
        messageLabel.text = message;
        
        // size the message label according to the length of the text
        CGSize maxSizeMessage = CGSizeMake((self.bounds.size.width * CSToastMaxWidth) - imageWidth - cancelImg.frame.size.width -50, self.bounds.size.height * CSToastMaxHeight);
        CGSize expectedSizeMessage = [self sizeForString:message font:messageLabel.font constrainedToSize:maxSizeMessage lineBreakMode:messageLabel.lineBreakMode];
        if (IS_IPAD) {
            messageLabel.frame = CGRectMake(0.0, 0.0, expectedSizeMessage.width, expectedSizeMessage.height);
        }else{
            messageLabel.frame = CGRectMake(0.0, 0.0, maxSizeMessage.width, expectedSizeMessage.height);
        }
    }
    
    // titleLabel frame values
    CGFloat titleWidth, titleHeight, titleTop, titleLeft;
    
//    if(titleLabel != nil) {
//        titleWidth = titleLabel.bounds.size.width;
//        titleHeight = titleLabel.bounds.size.height;
//        titleTop = CSToastVerticalPadding;
//        titleLeft = imageLeft + imageWidth + CSToastHorizontalPadding;
//    } else {
//        titleWidth = titleHeight = titleLeft = 0.0;
//        titleTop = 2;
//    }
    
    // messageLabel frame values
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;

    if(messageLabel != nil) {
        messageWidth = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLeft = imageLeft + imageWidth + CSToastHorizontalPadding;
        messageTop = CSToastVerticalPadding;
    } else {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }

    CGFloat longerWidth = MAX(titleWidth, messageWidth);
    CGFloat longerLeft = MAX(titleLeft, messageLeft);
    
    // wrapper width uses the longerWidth or the image width, whatever is larger. same logic applies to the wrapper height
    CGFloat wrapperWidth;

    CGFloat wrapperWidth1;
    CGFloat wrapperHeight = MAX((messageTop + messageHeight + CSToastVerticalPadding), (imageHeight + (CSToastVerticalPadding * 2)));
    
    if (!IS_IPAD) {
        wrapperWidth = SCREEN_SIZE.width;
        wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
//        wrapperWidth1 = MAX((imageWidth + (CSToastHorizontalPadding * 2)), (longerLeft + longerWidth + CSToastHorizontalPadding));
        wrapperWidth1 = SCREEN_SIZE.width;
        UIView *subWrapper = [[UIView alloc]initWithFrame:CGRectMake(0, 0, wrapperWidth1, wrapperHeight)];
        subWrapper.backgroundColor = [UIColor clearColor];
        subWrapper.center = wrapperView.center;
//        if(titleLabel != nil) {
//            titleLabel.frame = CGRectMake(titleLeft, titleTop, titleWidth, titleHeight);
//            [subWrapper addSubview:titleLabel];
//        }
        
        if(messageLabel != nil) {
            messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
            CGFloat centerY = subWrapper.center.y;
            messageLabel.center = CGPointMake(messageLabel.center.x, centerY);
            [subWrapper addSubview:messageLabel];
        }
        
        if(imageView != nil) {
            [subWrapper addSubview:imageView];
        }
        CGFloat centerY = subWrapper.center.y;
        cancelImg.center = CGPointMake(cancelImg.center.x, centerY);
        [subWrapper addSubview:cancelImg];
        [wrapperView addSubview:subWrapper];
    }else{
        wrapperWidth = MAX((imageWidth + (CSToastHorizontalPadding * 2)), (longerLeft + longerWidth + CSToastHorizontalPadding));
        if (wrapperWidth > SCREEN_SIZE.width) {
            wrapperWidth = SCREEN_SIZE.width;
        }
//        wrapperWidth = SCREEN_SIZE.width;
        wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
//        if(titleLabel != nil) {
//            titleLabel.frame = CGRectMake(titleLeft, titleTop, titleWidth, titleHeight);
//            [wrapperView addSubview:titleLabel];
//        }
        
        if(messageLabel != nil) {
            messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
//            messageLabel.center = CGPointMake(messageLabel.center.x, centerY);
            [wrapperView addSubview:messageLabel];
        }
        
        if(imageView != nil) {
            [wrapperView addSubview:imageView];
        }
    }
    
    if ([title isEqualToString:@"Success"]) {
        wrapperView.backgroundColor = UIColorFromRGB(0x00adef);
    } else if ([title isEqualToString:@"Warning"]){
        wrapperView.backgroundColor = UIColorFromRGB(0xFC1D00);
    }
    
    return wrapperView;
}


@end

@implementation ToasView

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}

@end
