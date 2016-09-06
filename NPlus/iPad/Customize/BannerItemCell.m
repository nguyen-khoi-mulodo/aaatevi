//
//  HotItemCell.m
//  NPlus
//
//  Created by Vo Chuong Thien on 10/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "BannerItemCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation BannerItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.lbTitle setHidden:YES];
    [self.lbSubTitle setHidden:YES];
    [self.imageView setHidden:YES];
    
}

- (id)init {
    
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 550, 310);
    }
    return self;
}

// Note: You can customize the behavior after calling the super method

// Called when loading programatically
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        // Call a common method to setup gesture and state of UIView
        [self setup];
    }
    return self;
}

// Called when loading from embedded .xib UIView
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        // Call a common method to setup gesture and state of UIView
        [self setup];
    }
    return self;
}

- (void)setup {
    [self.lbTitle setFont:[UIFont fontWithName:kFontSemibold size:20.0f]];
    [self.lbSubTitle setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [self.btnPlay setHidden:YES];
    
//    UIImage* image;
//    image resizableImageWithCapInsets:<#(UIEdgeInsets)#> resizingMode:<#(UIImageResizingMode)#>
}

- (void) setContentVideo:(Video*) video{
    [self.lbTitle setText:video.video_title];
    [self.lbSubTitle setText:video.video_subtitle];
    [self.imageView setImageWithURL:[NSURL URLWithString:video.video_image] placeholderImage:[UIImage imageNamed:@"default-video-kenh-ipad"]];
    
//    self.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.imageView.layer.shadowOffset = CGSizeMake(0, 100);
//    self.imageView.layer.shadowOpacity = 10;
//    self.imageView.layer.shadowRadius = 10.0;
}


- (void) showButtonPlay:(BOOL) show{
    [self.btnPlay setHidden:!show];
}
@end
