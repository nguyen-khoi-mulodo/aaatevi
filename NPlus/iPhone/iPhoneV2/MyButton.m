//
//  MyButton.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 12/30/15.
//  Copyright © 2015 TEVI Team. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        [self setBackgroundColor:UIColorFromRGB(0x00adef)];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    } else {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTitleColor:UIColorFromRGB(0xa4a4a4) forState:UIControlStateNormal];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.clipsToBounds = YES;
    self.layer.cornerRadius =  5;
    self.layer.borderColor = [UIColor colorWithWhite:0.6f alpha:0.5f].CGColor;
    self.layer.borderWidth = 1.0f;
}


@end
