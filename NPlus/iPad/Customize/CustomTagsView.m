//
//  CustomTagsView.m
//  NPlus
//
//  Created by Admin on 3/8/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "CustomTagsView.h"
#import "Genre.h"

@implementation CustomTagsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithData:(NSArray *) array {
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, 349, 45)];
        listTags = [[NSMutableArray alloc] init];
        if (array.count > 0) {
            for (Genre* genre in array) {
                UILabel *label = [[UILabel alloc] init];
                label.text = genre.genreName;
                label.textAlignment = NSTextAlignmentCenter;
                [label setFont:[UIFont fontWithName:kFontRegular size:16.0f]];
                [label sizeToFit];
                CGRect lblFrame = label.frame;
                CGFloat width = lblFrame.size.width + 5;
                CGFloat height = lblFrame.size.height + 5;
                label.frame = CGRectMake(lblFrame.origin.x, lblFrame.origin.y, width, height);
                [label setTextColor:UIColorFromRGB(0x00adef)];
                label.clipsToBounds = YES;
                label.layer.cornerRadius = 5;
                [label.layer setBorderWidth:1.0f];
                [label.layer setBorderColor:[UIColorFromRGB(0x00adef) CGColor]];
                [label setTag:1];

                [self addSubview:label];
                [listTags addObject:label];
            }
        }
//        self.backgroundColor = [UIColor redColor];
        self.backgroundColor = UIColorFromRGB(0xfcfcfc);
        [self arrangeSubViews];
        lineView = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 10, 349, 10)];
        [lineView setText:@""];
        [lineView setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
        [self addSubview:lineView];
    }
    return self;
}

- (void) resetWithArray:(NSArray*) array {
    for (UILabel* lb in listTags) {
        [lb removeFromSuperview];
    }
    for (Genre* genre in array) {
        UILabel *label = [[UILabel alloc] init];
        label.text = genre.genreName;
        label.textAlignment = NSTextAlignmentCenter;
        [label setFont:[UIFont fontWithName:kFontRegular size:16.0f]];
        [label sizeToFit];
        CGRect lblFrame = label.frame;
        CGFloat width = lblFrame.size.width + 5;
        CGFloat height = lblFrame.size.height + 5;
        label.frame = CGRectMake(lblFrame.origin.x, lblFrame.origin.y, width, height);
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:UIColorFromRGB(0x00adef)];
        label.clipsToBounds = YES;
        label.layer.cornerRadius = 5;
        [label.layer setBorderWidth:1.0f];
        [label.layer setBorderColor:[UIColorFromRGB(0x00adef) CGColor]];
        [label setTag:1];
        [self addSubview:label];
        [listTags addObject:label];
    }
    [self arrangeSubViews];
    [lineView setFrame:CGRectMake(0, self.frame.size.height - 10, 349, 10)];
}

- (void) arrangeSubViews {
    float x = 5, y = 5, width = self.frame.size.width, rowHeight = 0;
    for (int i = 0; i < self.subviews.count; i++) {
        UIView *view = [self.subviews objectAtIndex:i];
        // only re-arrange user-added views (change condition as required)
        if (![view isKindOfClass:UILabel.class] || view.tag == 0) continue;
        float w = view.frame.size.width + 10, h = view.frame.size.height;
        bool fitsInRow = x + 5 + w <= width;
        if (!fitsInRow) {
            x = 5; y += rowHeight + 5; rowHeight = h;
        }
        
        view.frame = CGRectMake(x, y, w, h);
        x += w + 10;
        rowHeight = MAX(rowHeight, h);
        if (i == self.subviews.count -1) {
            self.frame = CGRectMake(0, 0, self.frame.size.width, y + h + 15);
        }
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewAtTag:)];
        [view addGestureRecognizer:gesture];
        
    }
}

- (void)tapViewAtTag:(int)viewTag {
//    if (_delegate && [_delegate respondsToSelector:@selector(didTappedWithGenre:)]) {
//        if (_data.count >= viewTag) {
//            Genre *genre = (Genre*)[_data objectAtIndex:viewTag -1];
//            [_delegate didTappedWithGenre:genre];
//        }
//    }
}


@end
