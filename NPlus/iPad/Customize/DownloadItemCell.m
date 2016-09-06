//
//  HotItemCell.m
//  NPlus
//
//  Created by Vo Chuong Thien on 10/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "DownloadItemCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation DownloadItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)init {
    
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, 300, 250);
        
        [[NSBundle mainBundle] loadNibNamed:@"DownloadItemCell" owner:self options:nil];
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.view];
        [self.lbPercent setTextColor:[UIColor whiteColor]];
        [self.lbQuality setTextColor:[UIColor whiteColor]];
        if (!_processView) {
            CGRect processViewFrame = CGRectMake(0, 0, 34, 34);
            _processView = [[UCZProgressView alloc] initWithFrame:processViewFrame];
            _processView.backgroundColor = [UIColor clearColor];
            _processView.backgroundView.backgroundColor = [UIColor clearColor];
            _processView.tintColor = UIColorFromRGB(0x00adef);
            _processView.center = _btnDownloadStatus.center;
            [self.view addSubview:_processView];
            [_processView setUserInteractionEnabled:NO];
        }
        [_processView setProgress:self.infoCurrent.downloadProgress animated:YES];

        [self.lbName setFont:[UIFont fontWithName:kFontSemibold size:17.0f]];
        [self.lbChannel setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
        [self.lbPercent setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
        [self.lbQuality setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
        [self.lbQuality.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [self.lbQuality.layer setBorderWidth:1.0f];
        [self.lbQuality.layer setCornerRadius:5.0f];
        [self.lbQuality setClipsToBounds:YES];
    }
    
    return self;
    
}

-(void) setDownloadInfo:(FileDownloadInfo *)info{
    
    [self.view setUserInteractionEnabled:YES];
    self.infoCurrent = info;
    [_imageIcon setClipsToBounds:YES];
    [_imageIcon setContentMode:UIViewContentModeScaleAspectFit];
    [_imageIcon setImageWithURL:[NSURL URLWithString:info.videoDownload.video_image] placeholderImage:[UIImage imageNamed:@"default-video-kenh-ipad"]];
    [_lbName setText:info.videoDownload.video_subtitle];
    [_lbChannel setText:info.videoDownload.video_title];
    [self.btnDownloadStatus setHidden:(info.isDownloaded)];
    [_processView setHidden:(info.isDownloaded)];
    [self.lbPercent setHidden:(info.isDownloaded)];
    [self.maskView setHidden:(info.isDownloaded)];
    [self.lbQuality setText:info.quality];
    if (!info.isDownloaded) {
        if (info) {
            if(self.infoCurrent.isDownloading)
            {
                [self.btnDownloadStatus setBackgroundImage:[UIImage imageNamed:@"icon-downloading"] forState:UIControlStateNormal];
                [_processView setProgress:info.downloadProgress animated:YES];
                [self.lbPercent setText:[NSString stringWithFormat:@"(%2.0f%%)", info.downloadProgress*100]];
            }
            else if(!self.infoCurrent.isDownloading && !self.infoCurrent.isWaiting && !self.infoCurrent.isError)
            {
                [self.btnDownloadStatus setBackgroundImage:[UIImage imageNamed:@"icon-download-continue"] forState:UIControlStateNormal];
                [_processView setProgress:info.downloadProgress animated:YES];
                if (info.downloadProgress > 0) {
                    [self.lbPercent setText:[NSString stringWithFormat:@"(%2.0f%%)", info.downloadProgress*100]];
                    [_processView setProgress:self.infoCurrent.downloadProgress animated:YES];
                }else{
                    [self.lbPercent setText:@""];
                    [_processView setProgress:0.0f animated:NO];
                }
                
            }else if(!self.infoCurrent.isDownloading && self.infoCurrent.isWaiting&&!self.infoCurrent.isError)
            {
                if (info.downloadProgress > 0) {
                    [self.lbPercent setText:[NSString stringWithFormat:@"(%2.0f%%)", info.downloadProgress*100]];
                    [_processView setProgress:info.downloadProgress animated:YES];
                }else{
                    [self.lbPercent setText:@""];
                    [_processView setProgress:0.0f animated:NO];
                }
                
                [self.btnDownloadStatus setBackgroundImage:[UIImage imageNamed:@"icon-waiting-down"] forState:UIControlStateNormal];
            }else if (self.infoCurrent.isError)
            {
                [self.btnDownloadStatus setBackgroundImage:[UIImage imageNamed:@"icon-error"] forState:UIControlStateNormal];
            }
        }
    }
}

-(void)updateCell:(unsigned long)taskId{
    if (self.infoCurrent.taskIdentifier != taskId) {
        return;
    }
    
    if(self.infoCurrent.isDownloading)
    {
        [self.lbPercent setText:[NSString stringWithFormat:@"(%2.0f%%)", self.infoCurrent.downloadProgress*100]];
        [self.btnDownloadStatus setBackgroundImage:[UIImage imageNamed:@"icon-downloading"] forState:UIControlStateNormal];
        if (self.infoCurrent.downloadProgress != 1.0) {
            [_processView setProgress:self.infoCurrent.downloadProgress animated:YES];
        }
        
    }
    else if(!self.infoCurrent.isDownloading && !self.infoCurrent.isWaiting && !self.infoCurrent.isError)
    {
        
        if (self.infoCurrent.downloadProgress > 0) {
            [self.lbPercent setText:[NSString stringWithFormat:@"(%2.0f%%)", self.infoCurrent.downloadProgress*100]];
            [_processView setProgress:self.infoCurrent.downloadProgress animated:YES];
        }else{
            [self.lbPercent setText:@""];
            [_processView setProgress:0.0f animated:NO];
        }
        [self.btnDownloadStatus setBackgroundImage:[UIImage imageNamed:@"icon-download-continue"] forState:UIControlStateNormal];
        [_processView setProgress:self.infoCurrent.downloadProgress animated:YES];
    }else if(!self.infoCurrent.isDownloading && self.infoCurrent.isWaiting && !self.infoCurrent.isError)
    {
        if (self.infoCurrent.downloadProgress > 0) {
            [self.lbPercent setText:[NSString stringWithFormat:@"(%2.0f%%)", self.infoCurrent.downloadProgress*100]];
            [_processView setProgress:self.infoCurrent.downloadProgress animated:YES];
        }else{
            [self.lbPercent setText:@""];
            [_processView setProgress:0.0f animated:NO];
        }
        [self.btnDownloadStatus setBackgroundImage:[UIImage imageNamed:@"icon-waiting-down"] forState:UIControlStateNormal];
    }else if (self.infoCurrent.isError)
    {
        [self.lbPercent setText:@""];
        [self.btnDownloadStatus setBackgroundImage:[UIImage imageNamed:@"icon-error"] forState:UIControlStateNormal];
    }
    
}

-(NSString *)getFileSizeString:(double)size
{
    if(size >= 1024*1024)
    {
        return [NSString stringWithFormat:@"%1.2fM ",size/1024/1024];
    }
    else if(size >= 1024 && size < 1024*1024)
    {
        return [NSString stringWithFormat:@"%1.2fK ",size/1024];
    }
    else
    {
        return @"-- ";
        return [NSString stringWithFormat:@"%1.2fB ",size];
    }
}

- (IBAction) btnStatusTapped:(id)sender{
    if ([self.infoCurrent.status isEqualToString:@"0"]) {
        [[DownloadManager sharedInstance] pause:self.infoCurrent];
    }else{
        [[DownloadManager sharedInstance] resume:self.infoCurrent];
    }
}

- (IBAction) btnDeleteTapped:(id)sender{
    if (self.infoCurrent.isDownloaded) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Bạn có chắc muốn xoá video này không?" delegate:self cancelButtonTitle:@"Thôi" otherButtonTitles:@"Xoá", nil];
        [alertView show];
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteItemInfo:)]) {
            [self.delegate deleteItemInfo:self.infoCurrent];
        }
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteItemInfo:)]) {
            [self.delegate deleteItemInfo:self.infoCurrent];
        }
    }
}

- (IBAction) doSelected:(id)sender{
    if (self.infoCurrent.isDownloaded) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

@end
