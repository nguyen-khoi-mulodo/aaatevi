//
//  MoreOptionView.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 2/17/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHeightMoreOptionRow 60

@protocol MoreOptionViewDelegate <NSObject>

- (void)didTappedButtonIndex:(int)index object:(id)object linkShare:(NSString*)linkShare title:(NSString*)title;

@end

@interface MoreOptionView : UIView <UIGestureRecognizerDelegate> {
    UIView *view;
    CGRect originFrame;
}
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString* objectKey;
@property (nonatomic, strong) NSString* linkShare;
@property (nonatomic, strong) id<MoreOptionViewDelegate> delegate;
// type : 1-channel theo doi 2-video downloaded 3-video xem sau 4-chat luong download 5-chia se
- (id)initWithFrame:(CGRect)frame type:(int)type object:(id)object linkShare:(NSString*)linkShare;
- (id)initWithFrame:(CGRect)frame type:(int)type object:(id)object linkShare:(NSString*)linkShare numOfItem:(int)numOfItem arrayTitle:(NSArray*)arrayTitle;
- (void)tapGesture;
@end
