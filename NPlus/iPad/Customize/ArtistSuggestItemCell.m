//
//  HotItemCell.m
//  NPlus
//
//  Created by Vo Chuong Thien on 10/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "ArtistSuggestItemCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ArtistSuggestItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)init {
    
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 140, 144);
        [[NSBundle mainBundle] loadNibNamed:@"ArtistSuggestItemCell" owner:self options:nil];
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.view];
        
        [_lbName setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
    }
    return self;
}

- (void) setContentArtist:(Artist *) artist{
    [_imageIcon setClipsToBounds:YES];
    [_imageIcon setContentMode:UIViewContentModeScaleAspectFill];
    [_imageIcon setImageWithURL:[NSURL URLWithString:artist.avatarImg] placeholderImage:[UIImage imageNamed:@"default-dienvien-ipad"]];
    _imageIcon.layer.cornerRadius = 44.0f;
    [_lbName setText:artist.name];
}
@end
