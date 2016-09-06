//
//  HotItemCell.m
//  NPlus
//
//  Created by Vo Chuong Thien on 10/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "ArtistItemCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ArtistItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)init {
    
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 328, 266);
        [[NSBundle mainBundle] loadNibNamed:@"ArtistItemCell" owner:self options:nil];
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.view];
        
        [self.lbName setFont:[UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:18.0f]];
    }
    return self;
}

- (void) setContentWithArtist:(Artist*) artist{
    [_imageIcon setClipsToBounds:YES];
    [_imageIcon setContentMode:UIViewContentModeScaleAspectFill];
    [_imageIcon setImageWithURL:[NSURL URLWithString:artist.avatarImg] placeholderImage:[UIImage imageNamed:@"default-dienvien-ipad"]];
    _imageIcon.layer.cornerRadius = 75.0f;
    [self.lbName setText:artist.name];

}

- (void) setVideo:(Video*) item isShowActionView:(BOOL) isShow{
    [_imageIcon setClipsToBounds:YES];
    [_imageIcon setContentMode:UIViewContentModeScaleAspectFill];
    //    [_imageIcon setImageWithURL:[NSURL URLWithString:item.video_image] placeholderImage:[UIImage imageNamed:@"default_video_ipad"]];
    [_imageIcon setImage:[UIImage imageNamed:@"demo-img-video_ipad"]];

//    [self.actionView setHidden:!isShow];
}

- (void) setUILabelTextWithVerticalAlignTop:(NSString *)theText withLabel:(UILabel*) label{
    CGSize labelSize = label.frame.size;
    CGSize theStringSize = [theText sizeWithFont:label.font constrainedToSize:labelSize lineBreakMode:label.lineBreakMode];
    float X = label.frame.origin.x;
    float width;
    if ((label.frame.size.width/2 - theStringSize.width/2) > 0) {
        X = label.frame.origin.x + (label.frame.size.width/2 - theStringSize.width/2);
        width = self.frame.size.width - 2 * X;
    }else{
        width = label.frame.size.width;
    }
    label.frame = CGRectMake(X, label.frame.origin.y, width, theStringSize.height);
    label.text = theText;
}

-(void) setContent:(Channel *) item{
//    [_imageIcon setClipsToBounds:YES];
//    [_imageIcon setContentMode:UIViewContentModeScaleAspectFill];
//    [_imageIcon setImageWithURL:[NSURL URLWithString:item.image_thumb] placeholderImage:[UIImage imageNamed:@"default_video_ipad"]];
}

@end
