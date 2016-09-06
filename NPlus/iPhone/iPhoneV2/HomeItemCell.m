//
//  HomeItemCell.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/25/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "HomeItemCell.h"

@implementation HomeItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _btnItem1.exclusiveTouch = YES;
    _btnItem2.exclusiveTouch = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadContentViewWithType:(TypeCell)type {
    _typeCell = type;
    if (type == typeVideo) {
        _lblDuration1.hidden = NO;
        _lblDuration2.hidden = NO;
        _lblRating1.hidden = YES;
        _lblRating2.hidden = YES;
        if (_video1) {
            [_img1 setImageWithURL:[NSURL URLWithString:_video1.video_image] placeholderImage:[UIImage imageNamed:kDefault_Video_Img]];
            _lblDuration1.text = [_video1.time description];
            _title1.text = _video1.video_subtitle;
            _subTitle1.text = _video1.video_title;
            _subTitle1.hidden = NO;
            _iconView1.hidden = YES;
            _lblView1.hidden = YES;
            _iconHD1.hidden = !_video1.isHD;
        }
        if (_video2) {
            [_img2 setImageWithURL:[NSURL URLWithString:_video2.video_image] placeholderImage:[UIImage imageNamed:kDefault_Video_Img]];
            _lblDuration2.text = [_video2.time description];
            _title2.text = _video2.video_subtitle;
            _subTitle2.text = _video2.video_title;
            _subTitle2.hidden = NO;
            _iconView2.hidden = YES;
            _lblView2.hidden = YES;
            _iconHD2.hidden = !_video2.isHD;
        }
    } else if (type == typeChannel) {
        _lblDuration1.hidden = YES;
        _lblDuration2.hidden = YES;
        _lblRating1.hidden = NO;
        _lblRating2.hidden = NO;
        _iconHD1.hidden = YES;
        _iconHD2.hidden = YES;
        if (_channel1) {
            [_img1 setImageWithURL:[NSURL URLWithString:_channel1.thumb] placeholderImage:[UIImage imageNamed:kDefault_Video_Img]];
            _title1.text = _channel1.channelName;
            _subTitle1.hidden = YES;
            _iconView1.hidden = NO;
            _lblView1.hidden = NO;
            _lblView1.text = [Utilities convertToStringFromCount:_channel1.view];
            _lblRating1.text = [NSString stringWithFormat:@"%.1lf",_channel1.rating];
        }
        if (_channel2) {

            [_img2 setImageWithURL:[NSURL URLWithString:_channel2.thumb] placeholderImage:[UIImage imageNamed:kDefault_Video_Img]];
            _title2.text = _channel2.channelName;
            _subTitle2.hidden = YES;
            _iconView2.hidden = NO;
            _lblView2.hidden = NO;
            _lblView2.text = [Utilities convertToStringFromCount:_channel2.view];
            _lblRating2.text = [NSString stringWithFormat:@"%.1lf",_channel2.rating];
        } else {
            _imgTransfer.hidden = YES;
        }
    }
}
- (IBAction)btnItemAction:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if (_typeCell == typeVideo) {
        NSLog(@"VideoTapped");
        if ([_delegate respondsToSelector:@selector(itemTapped:)]) {
            if (btn.tag == 0) {
                [_delegate itemTapped:_video1];
            } else if (btn.tag ==1){
                [_delegate itemTapped:_video2];
            }
        }
    } else if (_typeCell == typeChannel) {
        NSLog(@"ChannelTapped");
        if ([_delegate respondsToSelector:@selector(itemTapped:)]) {
            if (btn.tag == 0) {
                [_delegate itemTapped:_channel1];
            } else if (btn.tag ==1){
                [_delegate itemTapped:_channel2];
            }
        }
    }
}

@end
