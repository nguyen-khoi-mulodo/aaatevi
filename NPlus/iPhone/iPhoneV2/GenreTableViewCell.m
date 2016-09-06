//
//  GenreTableViewCell.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 12/23/15.
//  Copyright © 2015 TEVI Team. All rights reserved.
//

#import "GenreTableViewCell.h"

@implementation GenreTableViewCell

- (void)awakeFromNib {
    _imgView.layer.cornerRadius = _imgView.frame.size.width/2;
    _imgView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadContentViewArtist {
    if (_artist) {
        [_imgView setImageWithURL:[NSURL URLWithString:_artist.avatarImg] placeholderImage:[UIImage imageNamed:kDefault_Actor_Img]];
        //_imgView.image = [Utilities getRoundedRectImageFromImage:[UIImage imageNamed:@"demo-dienvien"] onReferenceView:_imgView withCornerRadius:_imgView.frame.size.width/2];
        _title.text = _artist.alias;
    }
}

@end
