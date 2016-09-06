//
//  VideoHotCell.m
//  NPlus
//
//  Created by Vo Chuong Thien on 1/21/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "SeasonItemCell.h"

@implementation SeasonItemCell

- (void)awakeFromNib {
    // Initialization code
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self.lbTitle setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    [self.lbTitle sizeToFit];
    [self.lbVideos setFont:[UIFont fontWithName:kFontRegular size:13.0f]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setContentWithSeason:(Season*) season{
    [self.thumbImage setClipsToBounds:YES];
    [self.thumbImage setImageWithURL:[NSURL URLWithString:season.imgUrl] placeholderImage:[UIImage imageNamed:@"default-video-kenh-ipad"]];
    
    [self.lbTitle setText:season.seasonName];
    [self.lbVideos setText:[NSString stringWithFormat:@"%d videos", season.videosCount]];
}

@end
