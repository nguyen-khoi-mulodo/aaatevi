//
//  VideoHotCell.m
//  NPlus
//
//  Created by Vo Chuong Thien on 1/21/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "ChannelSuggestItemCell.h"

@implementation ChannelSuggestItemCell

- (void)awakeFromNib {
    // Initialization code
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self.lbTitle setFont:[UIFont fontWithName:kFontSemibold size:17.0f]];
    [self.lbUsersView setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
    [self.lbRating setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setContentWithChannel:(Channel*) channel{
    [self.thumbImage setClipsToBounds:YES];
    [self.thumbImage setImageWithURL:[NSURL URLWithString:channel.fullImg] placeholderImage:[UIImage imageNamed:@"default-video-kenh-ipad"]];

    [self.lbTitle setText:channel.channelName];
    [self.vFollow setHidden:NO];
    [self.vRating setHidden:NO];
    [self.lbRating setText:[NSString stringWithFormat:@"%0.1f", channel.rating]];
    [self.lbUsersView setText:[Utilities convertToStringFromCount:channel.view]];
}

@end
