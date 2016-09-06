//
//  VideoView.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/28/16.
//  Copyright © 2016 anhld. All rights reserved.
//

#import "VideoView.h"

#define heightFooter 60
#define paddingY 5

@implementation VideoView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        
        _thumbImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, paddingY, width , height - heightFooter)];
        _thumbImg.contentMode = UIViewContentModeScaleAspectFill;
        [_thumbImg setClipsToBounds:YES];
        //_thumbImg.image = [UIImage imageNamed:@"default-video"];
        
        UIImageView *transferTime = [[UIImageView alloc]initWithFrame:CGRectMake(0, height - heightFooter - 25 + paddingY, width, 25)];
        transferTime.contentMode = UIViewContentModeScaleAspectFill;
        [transferTime setClipsToBounds:YES];
        transferTime.image = [UIImage imageNamed:@"bg-transpatrent-time-v2"];
            
        _lblDuration = [[UILabel alloc]initWithFrame:CGRectMake(width - 60, height - heightFooter - 21 + paddingY, 55, 21)];
        _lblDuration.textAlignment = NSTextAlignmentRight;
        _lblDuration.textColor = [UIColor whiteColor];
        _lblDuration.font = [UIFont fontWithName:kFontSemibold size:14];
        [_lblDuration setBackgroundColor:[UIColor clearColor]];
        //_lblDuration.text = @"24:03";
            
        _lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, height - heightFooter + 10, width - 10, 42)];
        _lblTitle.textAlignment = NSTextAlignmentLeft;
        _lblTitle.textColor = UIColorFromRGB(0x212121);
        [_lblTitle setNumberOfLines:2];
        _lblTitle.font = [UIFont fontWithName:kFontRegular size:14];
        [_lblTitle setBackgroundColor:[UIColor clearColor]];
        //_lblTitle.text = @"Tap 1 - Phan cuoi cung";
            
        _btnItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_btnItem addTarget:self action:@selector(btnItemTapped) forControlEvents:UIControlEventTouchUpInside];
        _btnItem.exclusiveTouch = YES;
        
        [self addSubview:_thumbImg];
        [self addSubview:transferTime];
        [self addSubview:_lblDuration];
        [self addSubview:_lblTitle];
        [self addSubview:_btnItem];
    }
    return self;
}

- (void)loadContent {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    if (!_video) {
        _thumbImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, paddingY, width , height - heightFooter)];
        _thumbImg.contentMode = UIViewContentModeScaleAspectFill;
        [_thumbImg setClipsToBounds:YES];
        //_thumbImg.image = [UIImage imageNamed:@"default-video"];
        
        UIImageView *transferTime = [[UIImageView alloc]initWithFrame:CGRectMake(0, height - heightFooter - 25 + paddingY, width, 25)];
        transferTime.contentMode = UIViewContentModeScaleAspectFill;
        [transferTime setClipsToBounds:YES];
        transferTime.image = [UIImage imageNamed:@"bg-transpatrent-time-v2"];
        
        _lblDuration = [[UILabel alloc]initWithFrame:CGRectMake(width - 60, height - heightFooter - 21 + paddingY, 55, 21)];
        _lblDuration.textAlignment = NSTextAlignmentRight;
        _lblDuration.textColor = [UIColor whiteColor];
        _lblDuration.font = [UIFont fontWithName:kFontSemibold size:14];
        [_lblDuration setBackgroundColor:[UIColor clearColor]];
        //_lblDuration.text = @"24:03";
        
        _lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, height - heightFooter + 10, width - 10, 42)];
        _lblTitle.textAlignment = NSTextAlignmentLeft;
        _lblTitle.textColor = UIColorFromRGB(0x212121);
        [_lblTitle setNumberOfLines:2];
        _lblTitle.font = [UIFont fontWithName:kFontRegular size:14];
        [_lblTitle setBackgroundColor:[UIColor clearColor]];
        //_lblTitle.text = @"Tap 1 - Phan cuoi cung";
        
        _btnItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_btnItem addTarget:self action:@selector(btnItemTapped) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_thumbImg];
        [self addSubview:transferTime];
        [self addSubview:_lblDuration];
        [self addSubview:_lblTitle];
        [self addSubview:_btnItem];
    }
}

- (void) setContent:(CDHistory*) item{
    CGFloat heightSelf = self.frame.size.height;
    if (!_video) {
        _video = [[Video alloc]init];
    }
    _video.video_id = item.videoId;
    _video.video_title = item.videoTitle;
    _video.video_subtitle = item.videoSubTitle;
    _video.video_image = item.videoImage;
    _video.time = item.time;
    _video.stream_url = item.quality;
    
    [_thumbImg setImageWithURL:[NSURL URLWithString:item.videoImage] placeholderImage:[UIImage imageNamed:kDefault_Video_Img]];
    [_lblTitle setText:item.videoTitle];
    [_lblSubTitle setText:item.videoSubTitle];
    [_lblDuration setText:item.time];
    
    CGRect titleRect = _lblTitle.frame;
    CGFloat height = [Utilities heightForCellWithContent:item.videoTitle font:_lblTitle.font width:titleRect.size.width];
    if (height > 30) {
        height = 34;
    }
    titleRect.origin.y =  heightSelf - heightFooter + 10;
    titleRect.size.height = height;
    _lblTitle.frame = titleRect;
}

- (void)btnItemTapped {
    if ([_delegate respondsToSelector:@selector(didSelectItem:)]) {
        [_delegate didSelectItem:_video];
    }
}

@end
