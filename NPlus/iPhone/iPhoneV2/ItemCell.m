//
//  ItemCell.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/29/16.
//  Copyright © 2016 anhld. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell



- (void)awakeFromNib {
    [super awakeFromNib];
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    // Configure the view for the selected state
//}
//- (IBAction)btnSelectAction:(id)sender {
//    NSLog(@"select");
//}

- (void) setContent:(CDHistory*) item{
    [_lblSubTitle setFrame:CGRectMake(_lblSubTitle.frame.origin.x, _lblSubTitle.frame.origin.y, _lblSubTitle.frame.size.width, 42)];
    [_lblSubTitle setNumberOfLines:2];
    [_thumbImg setImageWithURL:[NSURL URLWithString:item.videoImage] placeholderImage:[UIImage imageNamed:kDefault_Video_Img]];
    [_lblTitle setText:item.videoTitle];
    [_lblSubTitle setText:item.videoSubTitle];
    [_lblDuration setText:item.time];
    
    [self updateLayout];
}


- (void)loadContentWithType:(TypeCell)typeCell {
    _typeCell = typeCell;
    if (typeCell == typeVideoInSeason || typeCell == typeVideoInSeasonFullScreen) {
        for (NSLayoutConstraint *widthConstraint in _btnMore.constraints) {
            if (widthConstraint.constant == 1) {
                widthConstraint.constant = 30;
                [_btnMore setNeedsLayout];
                [_btnMore layoutIfNeeded];
                [self setNeedsLayout];
                [self layoutIfNeeded];
                break;
            }
        }
        
        _lblSubTitle.hidden = YES;
        _lblViewCount.hidden = NO;
        _viewIcon.hidden = NO;
        _lblTitle.text = _video.video_subtitle;
        _lblDuration.text = _video.time;
        NSString *view = [Utilities convertToStringFromCount:_video.viewCount];
        NSString *time = [Utilities stringRelatedDateFromMiliseconds:_video.dateCreated/1000];
        _lblViewCount.text = [NSString stringWithFormat:@"%@ - %@",view,time];
        [_thumbImg setImageWithURL:[NSURL URLWithString:_video.video_image] placeholderImage:[UIImage imageNamed:kDefault_Video_Img]];
        _iconHD.hidden = !_video.isHD;
    }
    else if (typeCell == typeSuggestionVideo) {
        _lblSubTitle.hidden = NO;
        _lblViewCount.hidden = YES;
        _viewIcon.hidden = YES;
        _lblTitle.text = _video.video_subtitle;
        _lblSubTitle.text = _video.video_title;
        _lblDuration.text = _video.time;
        //_lblViewCount.text = [Utilities convertToStringFromCount:_video.viewCount];
        [_thumbImg setImageWithURL:[NSURL URLWithString:_video.video_image] placeholderImage:[UIImage imageNamed:kDefault_Video_Img]];
        _iconHD.hidden = !_video.isHD;
    }
    else if (typeCell == typeChannel) {
        _lblSubTitle.hidden = YES;
        _lblViewCount.hidden = NO;
        _viewIcon.hidden = NO;
        _lblTitle.text = _channel.channelName;
        _lblViewCount.text = [Utilities convertToStringFromCount:_channel.view];
        _lblDuration.text = [NSString stringWithFormat:@"%.01lf",_channel.rating];
        _lblDuration.textColor = UIColorFromRGB(0xFEC311);
        [_thumbImg setImageWithURL:[NSURL URLWithString:_channel.thumb] placeholderImage:[UIImage imageNamed:kDefault_Video_Img]];
    }
    else if (typeCell == typeFollow) {
        _lblSubTitle.hidden = YES;
        _lblViewCount.hidden = NO;
        _viewIcon.hidden = NO;
        _lblTitle.text = _channel.channelName;
        _lblViewCount.text = [Utilities convertToStringFromCount:_channel.view];
        _lblDuration.text = [NSString stringWithFormat:@"%.01lf",_channel.rating];
        _lblDuration.textColor = UIColorFromRGB(0xFEC311);
        [_thumbImg setImageWithURL:[NSURL URLWithString:_channel.thumb] placeholderImage:[UIImage imageNamed:kDefault_Video_Img]];
        for (NSLayoutConstraint *widthConstraint in _btnMore.constraints) {
            if (widthConstraint.constant == 1) {
                widthConstraint.constant = 30;
                [_btnMore setNeedsLayout];
                [_btnMore layoutIfNeeded];
                [self setNeedsLayout];
                [self layoutIfNeeded];
                break;
            }
        }
    }
    else if (typeCell == typeWatchLater) {
        _lblSubTitle.hidden = NO;
        _lblViewCount.hidden = YES;
        _viewIcon.hidden = YES;
        _lblTitle.text = _video.video_subtitle;
        _lblSubTitle.text = _video.video_title;
        _lblDuration.text = _video.time;
        [_thumbImg setImageWithURL:[NSURL URLWithString:_video.video_image] placeholderImage:[UIImage imageNamed:kDefault_Video_Img]];
        for (NSLayoutConstraint *widthConstraint in _btnMore.constraints) {
            if (widthConstraint.constant == 1) {
                widthConstraint.constant = 30;
                [_btnMore setNeedsLayout];
                [_btnMore layoutIfNeeded];
                [self setNeedsLayout];
                [self layoutIfNeeded];
                break;
            }
        }
        _iconHD.hidden = !_video.isHD;
    }
    else if (typeCell == typeNewFeed) {
        _lblSubTitle.hidden = NO;
        _lblCreateTime.hidden = NO;
        _lblViewCount.hidden = YES;
        _viewIcon.hidden = YES;
        _lblTitle.text = _video.video_subtitle;
        _lblSubTitle.text = _video.video_title;
        _lblDuration.text = _video.time;
        NSString *time = [Utilities stringRelatedDateFromMilisecondsLessWeek:_video.dateCreated/1000];
        _lblCreateTime.text = [NSString stringWithFormat:@"%@",time];
        [_thumbImg setImageWithURL:[NSURL URLWithString:_video.video_image] placeholderImage:[UIImage imageNamed:kDefault_Video_Img]];
    }
    [self updateLayout];
}
- (IBAction)btnMoreTapped:(id)sender {
    if ([_delegate respondsToSelector:@selector(didButtonMoreTapped:)]) {
        if (_typeCell == typeFollow) {
            [_delegate didButtonMoreTapped:_channel];
        } else {
            [_delegate didButtonMoreTapped:_video];
        }
    }
}

- (void)updateLayout {
    CGFloat screenWidth = SCREEN_SIZE.width;
    if (_typeCell == typeVideoInSeasonFullScreen) {
        screenWidth = 375;
    }
    CGFloat width = screenWidth - (self.frame.size.height - 16)*16/9 - 16;
    if (_typeCell == typeVideoInSeason || _typeCell == typeWatchLater || _typeCell == typeFollow) {
        width = screenWidth - (self.frame.size.height - 16)*16/9 - 46;
    } else if (_typeCell == typeVideoInSeasonFullScreen) {
       width = screenWidth - (self.frame.size.height - 16)*16/9 - 65;
    }
    
    CGFloat heightTitle = [Utilities heightForCellWithContent:_lblTitle.text font:_lblTitle.font width:width];
    if (heightTitle > 36) {
        heightTitle = 36;
    }
    _lblTitle.translatesAutoresizingMaskIntoConstraints = YES;
    
    _lblTitle.frame = CGRectMake(_lblTitle.frame.origin.x, _lblTitle.frame.origin.y, width, heightTitle);
//    if (_typeCell != typeNewFeed) {
//        _lblTitle.frame = CGRectMake(_lblTitle.frame.origin.x, _lblTitle.frame.origin.y + 5, width, heightTitle);
//    }
    
    _transparentImg.translatesAutoresizingMaskIntoConstraints = YES;
    CGRect frameTransparent = _transparentImg.frame;
    _transparentImg.frame = CGRectMake(frameTransparent.origin.x, frameTransparent.origin.y, _thumbImg.frame.size.width, frameTransparent.size.height);
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, screenWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    if (_typeCell == typeVideoInSeasonFullScreen) {
        //lineView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
        lineView.hidden = YES;
    }
    [self addSubview:lineView];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


@end
