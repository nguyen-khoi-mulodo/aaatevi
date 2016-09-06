//
//  MoreOptionButton.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/9/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "MoreOptionButton.h"

@implementation MoreOptionButton

- (id)initWithFrame:(CGRect)frame iconDefault:(NSString*)iconName iconSelected:(NSString*)iconSelectedName title:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        _iconDefaultName = iconName;
        _iconSelectedName = iconSelectedName;
        self.backgroundColor = [UIColor whiteColor];
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(15, (kHeightMoreOptionRow - 25)/2, 25, 25)];
        [_icon setImage:[UIImage imageNamed:_iconDefaultName]];
        _lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, SCREEN_SIZE.width - 60, frame.size.height)];
        _lblTitle.textColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        _lblTitle.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:17];
        _lblTitle.text = title;
        if (![title isEqualToString:@"Hủy"]) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height -0.5, frame.size.width, 1)];
            line.backgroundColor = UIColorFromRGB(0xf0f0f0);
            [self addSubview:line];
        }
        [self addSubview:_icon];
        [self addSubview:_lblTitle];
        //_icon.center = CGPointMake(_icon.center.x, self.center.y);
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        _lblTitle.textColor = UIColorFromRGB(0x00adef);
        [_icon setImage:[UIImage imageNamed:_iconSelectedName]];
    } else {
        _lblTitle.textColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        [_icon setImage:[UIImage imageNamed:_iconDefaultName]];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted) {
        _lblTitle.textColor = UIColorFromRGB(0x00adef);
        [_icon setImage:[UIImage imageNamed:_iconSelectedName]];
    } else {
        _lblTitle.textColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        [_icon setImage:[UIImage imageNamed:_iconDefaultName]];
    }
}

@end
