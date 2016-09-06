//
//  HotItemCell.m
//  NPlus
//
//  Created by Vo Chuong Thien on 10/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "VideoItemCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utilities.h"

@implementation VideoItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)init {
    
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, 250, 208);
        
        [[NSBundle mainBundle] loadNibNamed:@"VideoItemCell" owner:self options:nil];
        [self addSubview:self.view];
        
        [self.lbTitle setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
        [self.lbSubTitle setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
        [self.lbDesciption setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
        [self.lbViews setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
        [self.lbTime setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
    }
    
    return self;
    
}

- (void) setVideo:(Video*) item isShowActionView:(BOOL) isShow{
    [_imageIcon setClipsToBounds:YES];
    [_imageIcon setContentMode:UIViewContentModeScaleAspectFill];
    [_imageIcon setImageWithURL:[NSURL URLWithString:item.video_image] placeholderImage:[UIImage imageNamed:@"default-video-kenh-ipad"]];
    [_lbTitle setText:item.video_subtitle];
    [_lbSubTitle setText:item.video_title];
    [self setUILabelTextWithVerticalAlignTop:item.video_shortDes withLabel:_lbDesciption];
    [_vLuotXem setHidden:YES];
    [_lbViews setText:[Utilities convertToStringFromCount:item.viewCount]];
    [_lbTime setText:item.time];
    [_iconHD setHidden:!item.isHD];
    [self.actionView setHidden:!isShow];
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
