//
//  HotItemCell.m
//  NPlus
//
//  Created by Vo Chuong Thien on 10/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "ChannelItemCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ChannelItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)init {
    
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, 250, 208);
        
        [[NSBundle mainBundle] loadNibNamed:@"ChannelItemCell" owner:self options:nil];
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.view];
        
        [self.lbTitle setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
        [self.lbDesciption setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
        [self.lbUsersView setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
        [self.lbRating setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
    }
    return self;
    
}

-(void) setContentChannel:(Channel *) channel{
    [_imageIcon setClipsToBounds:YES];
    [_imageIcon setContentMode:UIViewContentModeScaleAspectFill];
    [_imageIcon setImageWithURL:[NSURL URLWithString:channel.fullImg] placeholderImage:[UIImage imageNamed:@"default-video-kenh-ipad"]];
    [self.lbTitle setText:channel.channelName];
    [self setUILabelTextWithVerticalAlignTop:channel.channelDes withLabel:self.lbDesciption];
    [self.vFollow setHidden:NO];
//    [self.vRating setHidden:NO];
    [self.lbRating setText:[NSString stringWithFormat:@"%0.1f", channel.rating]];
    [self.lbUsersView setText:[Utilities convertToStringFromCount:channel.view]];
    
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
