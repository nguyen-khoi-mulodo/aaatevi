//
//  VideoHotCell.m
//  NPlus
//
//  Created by Vo Chuong Thien on 1/21/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "VideoSuggestItemCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation VideoSuggestItemCell

- (void)awakeFromNib {
    // Initialization code
    [self setBackgroundColor:[UIColor clearColor]];
    [lbTitle setFont:[UIFont fontWithName:kFontSemibold size:16.0f]];
    [lbSubTitle setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    [lbLuotXem setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
    [lbTime setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setContentWithVideo:(Video*) video{
    [thumbImageView setClipsToBounds:YES];
    [thumbImageView setContentMode:UIViewContentModeScaleAspectFill];
    [thumbImageView setImageWithURL:[NSURL URLWithString:video.video_image] placeholderImage:[UIImage imageNamed:@"default-video-kenh-ipad"]];
    
    [lbTitle setText:video.video_subtitle];
    [lbSubTitle setText:video.video_title];
    [imvHD setHidden:!video.isHD];
    [lbLuotXem setText:[Utilities convertToStringFromCount:video.viewCount]];
    [lbTime setText:video.time];
}

@end
