//
//  HotItemCell.m
//  NPlus
//
//  Created by Vo Chuong Thien on 10/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "HomeItemViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utilities.h"

@implementation HomeItemViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)init {
    
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, 250, 208);
        
        [[NSBundle mainBundle] loadNibNamed:@"HomeItemViewCell" owner:self options:nil];
        [self addSubview:self.view];
        
        [self.lbTitle setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
        [self.lbSubTitle setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
        [self.lbViews setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
        [self.lbTime setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
    }
    
    return self;
    
}

- (void) setItem:(id) item{
    [_imageIcon setClipsToBounds:YES];
    [_imageIcon setContentMode:UIViewContentModeScaleAspectFill];
    if ([item isKindOfClass:[Video class]]) {
        Video* video = (Video*)item;
        [_imageIcon setImageWithURL:[NSURL URLWithString:video.video_image] placeholderImage:[UIImage imageNamed:@"default-video-kenh-ipad"]];
        [_lbTitle setText:video.video_subtitle];
        [_lbSubTitle setHidden:NO];
        [_lbSubTitle setText:video.video_title];
        [_vLuotXem setHidden:YES];
        [_lbTime setTextColor:[UIColor whiteColor]];
        [_lbTime setText:video.time];
        [_iconHD setHidden:!video.isHD];
    }else{
        Channel* channel = (Channel*)item;
        [_imageIcon setImageWithURL:[NSURL URLWithString:channel.fullImg] placeholderImage:[UIImage imageNamed:@"default-video-kenh-ipad"]];
        [self.lbTitle setText:channel.channelName];
        [_lbSubTitle setHidden:YES];
        [_vLuotXem setHidden:NO];
        [self.lbViews setText:[Utilities convertToStringFromCount:channel.view]];
        [_lbTime setTextColor:UIColorFromRGB(0xffcc10)];
        [_lbTime setText:[NSString stringWithFormat:@"%0.1f", channel.rating]];
        [_iconHD setHidden:YES];
    }
}

- (void)setUILabelTextWithVerticalAlignTop:(NSString *)theText withLabel:(UILabel*) label{
    [label setText:theText];
    // set number line = 0 to show full text
    CGSize theStringSize = [label sizeThatFits:CGSizeMake(label.frame.size.width, CGFLOAT_MAX)];
    float X = label.frame.origin.x;
    float width = label.frame.size.width;
    label.frame = CGRectMake(X, label.frame.origin.y, width, theStringSize.height);
}

@end
