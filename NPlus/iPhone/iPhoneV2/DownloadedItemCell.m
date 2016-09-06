//
//  ItemCell.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/29/16.
//  Copyright © 2016 anhld. All rights reserved.
//

#import "DownloadedItemCell.h"
#import "Video.h"
#import "Util.h"
#import "DBHelper.h"

@implementation DownloadedItemCell



- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void) setContent:(FileDownloadInfo*) item{
    _video = item.videoDownload;
    
    double lastTime = [[DBHelper sharedInstance]getSecondsContinueVideo:_video];
    int duration = [[DBHelper sharedInstance]getSecondsDurationOfVideo:_video];
    int intSecond = (int)lastTime;
    
    NSString *stateViewed = @"Chưa xem";
    if (lastTime >= 0 && duration > 0) {
        float percent = (float) lastTime/duration *100;
        if (percent >= 100 ) {
            percent = 100;
            stateViewed = @"Đã xem";
        } else if (percent == 0) {
            stateViewed = @"Chưa xem";
        } else {
            stateViewed = [NSString stringWithFormat:@"Đã xem %.00f%%",percent];
            if ([stateViewed isEqualToString:@"Đã xem 0%"]) {
                stateViewed = @"Chưa xem";
            } else if ([stateViewed isEqualToString:@"Đã xem 100%"]) {
                stateViewed = @"Đã xem";
            }
        }
    } else if ((intSecond == duration) || (intSecond == (duration - 1)) || (intSecond == (duration + 1) )) {
        stateViewed = @"Đã xem";
    }
    [_lbSize setText: [NSString stringWithFormat:@"%@  |  %@",stateViewed,[Util getByteExecdtedWritten:item.totalBytesExpectedToWrite]] ];
    UIColor *fillColor = UIColorFromRGB(0x00adef);
    if ([stateViewed isEqualToString:@"Đã xem"]) {
        fillColor = [UIColor redColor];
    } else if ([stateViewed isEqualToString:@"Chưa xem"]) {
        fillColor = UIColorFromRGB(0x00adef);
    } else {
        fillColor = [UIColor redColor];
    }
    [_lbSize setAttributedText:[Utilities getAttributeText:_lbSize.text forSubstring:stateViewed fillColor:fillColor font:_lbSize.font]];
    [_thumbImg setImageWithURL:[NSURL URLWithString:_video.video_image] placeholderImage:[UIImage imageNamed:kDefault_Video_Img]];
    [_lblTitle setText:_video.video_subtitle];
    [_lblSubTitle setText:_video.video_title];
    [_lblDuration setText:_video.time];
    [_lbQuality setText:item.quality];
    [self updateLayout];
}


- (void)updateLayout {
    CGFloat width = SCREEN_SIZE.width - (self.frame.size.height - 16)*16/9 - 16;
    CGFloat heightTitle = [Utilities heightForCellWithContent:_lblTitle.text font:_lblTitle.font width:width];
    if (heightTitle > 36) {
        heightTitle = 36;
    }
    _lblTitle.translatesAutoresizingMaskIntoConstraints = YES;
    _lblTitle.frame = CGRectMake(_lblTitle.frame.origin.x, _lblTitle.frame.origin.y, width, heightTitle);
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, SCREEN_SIZE.width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self addSubview:lineView];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}




@end
