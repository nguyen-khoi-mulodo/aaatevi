//
//  ItemCell.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/29/16.
//  Copyright © 2016 anhld. All rights reserved.
//

#import "DownloadingItemCell.h"

@implementation DownloadingItemCell



- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void) setContent:(FileDownloadInfo*) info{
    self.infoCurrent = info;
    NSLog(@"%d", (int) self.infoCurrent.taskIdentifier);
    _video = info.videoDownload;
    [_thumbImg setImageWithURL:[NSURL URLWithString:_video.video_image] placeholderImage:[UIImage imageNamed:kDefault_Video_Img]];
    [_lblTitle setText:_video.video_subtitle];
    [_lblDuration setText:_video.time];
    [_lbQuality setText:info.quality];
    [_lbSize setText:[Util getRatioWithBytesWritten:info.totalBytesWritten BytesExpectedToWrite:info.totalBytesExpectedToWrite]];
    [_lbQuality setText:[NSString stringWithFormat:@"%@", info.quality]];
    if (!info.isDownloaded) {
        if (info) {
            if(self.infoCurrent.isDownloading)
            {
                [self.lbStatus setText:@"Đang tải"];
            }
            else if(!self.infoCurrent.isDownloading && !self.infoCurrent.isWaiting && !self.infoCurrent.isError)
            {
                [self.lbStatus setText:@"Đang dừng"];
            }else if(!self.infoCurrent.isDownloading && self.infoCurrent.isWaiting&&!self.infoCurrent.isError)
            {
                [self.lbStatus setText:@"Đang chờ"];
            }else if (self.infoCurrent.isError)
            {
                [self.lbStatus setText:@"Bị lỗi"];
            }
            [_progressView setProgress:info.downloadProgress];
        }
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, SCREEN_SIZE.width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self addSubview:lineView];
}

- (void) updateCell:(unsigned long)taskId andInfo:(FileDownloadInfo*) info{
    if (self.infoCurrent.taskIdentifier != taskId || (![info.videoDownload.video_id isEqualToString:self.infoCurrent.videoDownload.video_id] || ([info.videoDownload.video_id isEqualToString:self.infoCurrent.videoDownload.video_id] && ![info.quality isEqualToString:self.infoCurrent.quality]))) {
        return;
    }
    self.infoCurrent = info;
    if(self.infoCurrent.isDownloading)
    {
        [self.lbStatus setText:@"Đang tải"];
        if (self.infoCurrent.downloadProgress != 1.0) {
            [_progressView setProgress:self.infoCurrent.downloadProgress];
            [_lbSize setText:[Util getRatioWithBytesWritten:info.totalBytesWritten BytesExpectedToWrite:info.totalBytesExpectedToWrite]];
        }
    }
    else if(!self.infoCurrent.isDownloading && !self.infoCurrent.isWaiting && !self.infoCurrent.isError)
    {
        
        [self.lbStatus setText:@"Đang dừng"];
        [_progressView setProgress:self.infoCurrent.downloadProgress];
        [_lbSize setText:[Util getRatioWithBytesWritten:info.totalBytesWritten BytesExpectedToWrite:info.totalBytesExpectedToWrite]];
    }else if(!self.infoCurrent.isDownloading && self.infoCurrent.isWaiting && !self.infoCurrent.isError)
    {
        [self.lbStatus setText:@"Đang đợi"];
        [_progressView setProgress:self.infoCurrent.downloadProgress];
        [_lbSize setText:[Util getRatioWithBytesWritten:info.totalBytesWritten BytesExpectedToWrite:info.totalBytesExpectedToWrite]];
    }else if (self.infoCurrent.isError)
    {
        [self.lbStatus setText:@"Bị lỗi"];
        [_progressView setProgress:self.infoCurrent.downloadProgress];
        [_lbSize setText:[Util getRatioWithBytesWritten:info.totalBytesWritten BytesExpectedToWrite:info.totalBytesExpectedToWrite]];
    }
}


@end
