//
//  VideoHotCell.m
//  NPlus
//
//  Created by Vo Chuong Thien on 1/21/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "ChannelRelatedItemCell.h"

@implementation ChannelRelatedItemCell

- (void)awakeFromNib {
    // Initialization code
    [self setBackgroundColor:[UIColor clearColor]];
    [self.lbTitle setFont:[UIFont fontWithName:kFontRegular size:16.0f]];
    [self.lbSubTitle setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    [self.lbTime setFont:[UIFont fontWithName:kFontSemibold size:14.0f]];
}

- (void) commonInit{
    self.mContentView.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setContent:(Video*) video{
    [self.thumbImage setClipsToBounds:YES];
    [self.thumbImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.thumbImage setImageWithURL:[NSURL URLWithString:video.video_image] placeholderImage:[UIImage imageNamed:@"default-video-kenh-ipad"]];
    [self.lbTitle setText:video.video_subtitle];
    [self.lbSubTitle setText:video.video_title];
    [_lbTime setText:video.time];
    [_imvHD setHidden:!video.isHD];
//    [self.lbTitle setFrame:CGRectMake(self.lbTitle.frame.origin.x, self.lbTitle.frame.origin.y, self.lbTitle.frame.size.width, height)];
//    [self setUILabelTextWithVerticalAlignTop:channel.channelName withLabel:self.lbTitle];
}

- (void)setUILabelTextWithVerticalAlignTop:(NSString *)theText withLabel:(UILabel*) label{
    [label setText:theText];
//     set number line = 0 to show full text
    CGSize theStringSize = [label sizeThatFits:CGSizeMake(label.frame.size.width, CGFLOAT_MAX)];
    float X = label.frame.origin.x;
    float width = label.frame.size.width;
    label.frame = CGRectMake(X, label.frame.origin.y, width, theStringSize.height);
}

@end
