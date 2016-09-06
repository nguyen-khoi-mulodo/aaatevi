//
//  UILabelViewFlowLayout.m
//  AFTabledCollectionView
//
//  Created by Khoi Nguyen Nguyen on 1/7/16.
//  Copyright © 2016 Ash Furrow. All rights reserved.
//

#import "UILabelViewFlowLayout.h"

@implementation UILabelViewFlowLayout

- (id)initWithData:(NSArray *)array {
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, SCREEN_SIZE.width - 10, 50)];
        if (array.count > 0) {
            _data = array;
            for (Genre *genre in array) {

                UILabel *label = [[UILabel alloc]init];
                label.text = genre.genreName;
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont fontWithName:kFontRegular size:16];
                [label sizeToFit];
                CGRect lblFrame = label.frame;
                CGFloat width = lblFrame.size.width + 10;
                CGFloat height = lblFrame.size.height + 10;
                label.frame = CGRectMake(lblFrame.origin.x, lblFrame.origin.y, width, height);
//                [label setBackgroundColor:UIColorFromRGB(0xfcfcfc)];
//                label.clipsToBounds = YES;
//                label.layer.cornerRadius = 3;
//                label.layer.borderColor = UIColorFromRGB(0x00adef).CGColor;
//                label.layer.borderWidth = 1;
//                label.textColor = UIColorFromRGB(0x00adef);
                
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, label.frame.size.width, label.frame.size.height)];
                btn.tag = [array indexOfObject:genre];
                [btn setTitle:genre.genreName forState:UIControlStateNormal];
                [btn setBackgroundColor:UIColorFromRGB(0xfcfcfc)];
                btn.clipsToBounds = YES;
                btn.layer.cornerRadius = 3;
                btn.layer.borderColor = UIColorFromRGB(0x00adef).CGColor;
                btn.layer.borderWidth = 1;
                [btn setTitleColor:UIColorFromRGB(0x00adef) forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont fontWithName:kFontRegular size:16];
                [btn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
                
                [self addSubview:btn];

            }
        }
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)arrangeSubViews {
    float x = 10, y = 5, width = self.frame.size.width, rowHeight = 0;
    NSLog(@"%d",(int)self.subviews.count);
    for (int i = 0; i < self.subviews.count; i++) {
        UIView *view = [self.subviews objectAtIndex:i];
        // only re-arrange user-added views (change condition as required)
        if (![view isKindOfClass:UIButton.class]) continue;
        float w = view.frame.size.width+10, h = view.frame.size.height;
        bool fitsInRow = x + 10 + w <= width;
        if (!fitsInRow) {
            x = 10; y += rowHeight+5; rowHeight = h;
        }
        
        view.frame = CGRectMake(x, y, w, h);
        x += w+10;
        rowHeight = MAX(rowHeight, h);
        if (i == self.subviews.count -1) {
            self.frame = CGRectMake(0, 0, self.frame.size.width, y + h +10);
        }
        [view setTag:i];
    }
}

- (void)btnTapped:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if (_delegate && [_delegate respondsToSelector:@selector(didTappedWithGenre:)]) {
        if (_data.count > btn.tag) {
            Genre *genre = (Genre*)[_data objectAtIndex:btn.tag];
            [_delegate didTappedWithGenre:genre];
        }
    }
}

@end
