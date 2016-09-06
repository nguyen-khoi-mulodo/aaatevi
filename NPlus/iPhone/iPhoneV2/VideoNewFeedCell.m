//
//  VideoNewFeedCell.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 7/7/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "VideoNewFeedCell.h"


@implementation VideoNewFeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCell {
    if (_video) {
        [self.imvThumb setImageWithURL:[NSURL URLWithString:_video.video_image] placeholderImage:[UIImage imageNamed:kDefault_Video_Img]];
        self.lblName.text = _video.video_title;
        self.lblFollowNum.text = [Utilities convertToStringFromCount:_video.viewCount];
        [self updateLayout];
    }
}

- (void)updateLayout {
    CGFloat width = SCREEN_SIZE.width - 193;
    
    CGFloat heightTitle = [Utilities heightForCellWithContent:_lblName.text font:_lblName.font width:width];
    if (heightTitle > 36) {
        heightTitle = 36;
    }
    _lblName.translatesAutoresizingMaskIntoConstraints = YES;
    _lblName.frame = CGRectMake(_lblName.frame.origin.x, _lblName.frame.origin.y, width, heightTitle);
}

@end
