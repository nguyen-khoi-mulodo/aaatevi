//
//  ChannelHeaderCell.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 7/7/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "ChannelHeaderCell.h"

@implementation ChannelHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imvThumb.clipsToBounds = YES;
    _imvThumb.layer.cornerRadius = _imvThumb.frame.size.width/2;
}

- (void)configCell {
    if (_channel) {
        [_imvThumb setImageWithURL:[NSURL URLWithString:_channel.thumb] placeholderImage:[UIImage imageNamed:kDefault_Video_Img]];
        _lblName.text = _channel.channelName;
        _lblFollowNum.text = [NSString stringWithFormat:@"%@ lượt theo dõi",[Utilities convertToStringFromCount:_channel.view]];
    }
}
- (IBAction)btnMoreAction:(id)sender {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
