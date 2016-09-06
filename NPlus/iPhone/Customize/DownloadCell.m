//
//  DownloadCell.m
//  NPlus
//
//  Created by Anh Le Duc on 7/31/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "DownloadCell.h"
#import "DownloadManager.h"
@interface DownloadCell(){
}
@end
@implementation DownloadCell
@synthesize downloadInfo = _downloadInfo;
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFileDownloadInfo:(FileDownloadInfo *)info{
    if (info) {
        _downloadInfo = info;
        _lbTitle.text = [info.videoDownload video_title];
        _lbPercent.text = @"";
        if(_downloadInfo.isDownloading)
        {
            [_btnDownload setImage:[UIImage imageNamed:@"personal_icon_dangtai"] forState:UIControlStateNormal];
            _lbDownload.text = @"Đang tải";
            _lbDownload.textColor = RGB(0, 173, 239);
        }
        else if(!_downloadInfo.isDownloading && !_downloadInfo.isWaiting && !_downloadInfo.isError)
        {
            _lbSize.text = [NSString stringWithFormat:@"%@/%@", [self getFileSizeString:_downloadInfo.totalBytesWritten], [self getFileSizeString:_downloadInfo.totalBytesExpectedToWrite]];
            [_btnDownload setImage:[UIImage imageNamed:@"personal_icon_dangdung"] forState:UIControlStateNormal];
            _lbDownload.text = @"Đã dừng";
            _lbDownload.textColor = RGB(119, 119, 119);
        }else if(!_downloadInfo.isDownloading && _downloadInfo.isWaiting&&!_downloadInfo.isError)
        {
            _lbSize.text = [NSString stringWithFormat:@"%@/%@", [self getFileSizeString:_downloadInfo.totalBytesWritten], [self getFileSizeString:_downloadInfo.totalBytesExpectedToWrite]];
            [_btnDownload setImage:[UIImage imageNamed:@"personal_icon_dangcho"] forState:UIControlStateNormal];
            _lbDownload.text = @"Đang chờ";
            _lbDownload.textColor = RGB(119, 119, 119);
        }else if (_downloadInfo.isError)
        {
            _lbSize.text = @"Lỗi";
            [_btnDownload setImage:[UIImage imageNamed:@"personal_icon_error"] forState:UIControlStateNormal];
            _lbDownload.text = @"Thử lại";
            _lbDownload.textColor = RGB(119, 119, 119);
        }
        CGFloat constrainedSize = 265.0f; //or any other size
        UIFont * myFont = [UIFont systemFontOfSize:13.0f]; //or any other font that matches what you will use in the UILabel
        CGSize textSize = [_lbSize.text sizeWithFont: myFont
                             constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)
                                 lineBreakMode:NSLineBreakByWordWrapping];
        _lbSize.adjustsFontSizeToFitWidth  = YES;
        _lbSize.numberOfLines = 0;
        CGRect frame = _lbSize.frame;
        frame.size.height = 21;
        frame.size.width = textSize.width;
        _lbSize.frame = frame;
        frame = _lbPercent.frame;
        frame.size.height = 21;
        frame.origin.x = _lbSize.frame.origin.x + _lbSize.frame.size.width;
        _lbPercent.frame = frame;
    }
}

- (IBAction)btnDownload_Tapped:(id)sender {
    if ([_downloadInfo.status isEqualToString:@"0"]) {
        [[DownloadManager sharedInstance] pause:_downloadInfo];
    }else{
        [[DownloadManager sharedInstance] resume:_downloadInfo];
    }
    
}

-(void)updateCell:(unsigned long)taskId{
    if (_downloadInfo.taskIdentifier != taskId) {
        return;
    }
    _lbPercent.text = @"";
    if(_downloadInfo.isDownloading)
    {
        _lbSize.text = [NSString stringWithFormat:@"%@/%@", [self getFileSizeString:_downloadInfo.totalBytesWritten], [self getFileSizeString:_downloadInfo.totalBytesExpectedToWrite]];
        _lbPercent.text = [NSString stringWithFormat:@"(%2.0f%%)", _downloadInfo.downloadProgress*100];
        _lbDownload.text = @"Đang tải";
        _lbDownload.textColor = RGB(0, 173, 239);
        [_btnDownload setImage:[UIImage imageNamed:@"personal_icon_dangtai"] forState:UIControlStateNormal];
    }
    else if(!_downloadInfo.isDownloading && !_downloadInfo.isWaiting&&!_downloadInfo.isError)
    {
        _lbSize.text = [NSString stringWithFormat:@"%@/%@", [self getFileSizeString:_downloadInfo.totalBytesWritten], [self getFileSizeString:_downloadInfo.totalBytesExpectedToWrite]];
        _lbPercent.text = @"";
        _lbDownload.text = @"Đã dừng";
        _lbDownload.textColor = RGB(119, 119, 119);
        [_btnDownload setImage:[UIImage imageNamed:@"personal_icon_dangdung"] forState:UIControlStateNormal];
    }else if(!_downloadInfo.isDownloading && _downloadInfo.isWaiting&&!_downloadInfo.isError)
    {
        _lbPercent.text = @"";
        _lbSize.text = [NSString stringWithFormat:@"%@/%@", [self getFileSizeString:_downloadInfo.totalBytesWritten], [self getFileSizeString:_downloadInfo.totalBytesExpectedToWrite]];
        _lbDownload.text = @"Đang chờ";
        _lbDownload.textColor = RGB(119, 119, 119);
        [_btnDownload setImage:[UIImage imageNamed:@"personal_icon_dangcho"] forState:UIControlStateNormal];
    }else if (_downloadInfo.isError)
    {
        _lbPercent.text = @"";
        _lbSize.text = @"Lỗi";
        _lbDownload.text = @"Thử lại";
        _lbDownload.textColor = RGB(119, 119, 119);
        [_btnDownload setImage:[UIImage imageNamed:@"personal_icon_error"] forState:UIControlStateNormal];
    }
    CGFloat constrainedSize = 265.0f; //or any other size
    UIFont * myFont = [UIFont systemFontOfSize:13.0f]; //or any other font that matches what you will use in the UILabel
    CGSize textSize = [_lbSize.text sizeWithFont: myFont
                               constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)
                                   lineBreakMode:NSLineBreakByWordWrapping];
    _lbSize.adjustsFontSizeToFitWidth  = YES;
    _lbSize.numberOfLines = 0;
    CGRect frame = _lbSize.frame;
    frame.size.height = 21;
    frame.size.width = textSize.width;
    _lbSize.frame = frame;
    frame = _lbPercent.frame;
    frame.size.height = 21;
    frame.origin.x = _lbSize.frame.origin.x + _lbSize.frame.size.width;
    _lbPercent.frame = frame;
    
}

- (void)showInfoDowloadedWithEdit:(BOOL)isEdit animated:(BOOL)animated{
    _lbTitle_TrailingMargin.constant= 4;
    _lbTitle.backgroundColor = [UIColor clearColor];
    [_lbTitle layoutIfNeeded];
    _lbTitle_LeadingMargin.constant = isEdit ? 35 : 12;
    _lbSize_LeadingMargin.constant = isEdit ? 35 : 12;
    _lbSize.text = [self getFileSizeString:_downloadInfo.totalBytesExpectedToWrite];
    _lbPercent.hidden = YES;
    _btnDownload.hidden = YES;
    _lbDownload.hidden = YES;
    float time = animated ? 0.3f : 0.0f;
    if (!isEdit) {
        [UIView animateWithDuration:time animations:^{
            _imgCheck.alpha = 0.0f;
            [_lbTitle layoutIfNeeded];
            [_lbSize layoutIfNeeded];
        }];
    }else{
        [UIView animateWithDuration:time animations:^{
            _imgCheck.alpha = 1.0f;
            [_lbTitle layoutIfNeeded];
            [_lbSize layoutIfNeeded];
        }];
    }
}

-(void)checked:(BOOL)checked{
    if (checked) {
        [_imgCheck setImage:[UIImage imageNamed:@"personal_check_hover"]];
    }else{
        [_imgCheck setImage:[UIImage imageNamed:@"personal_check"]];
    }
}

-(void)showInfoDownloadingWithEdit:(BOOL)isEdit animated:(BOOL)animated{
    _lbTitle_LeadingMargin.constant = isEdit ? 35 : 12;
    _lbSize_LeadingMargin.constant = isEdit ? 35 : 12;
    float time = animated ? 0.3f : 0.0f;
    if (!isEdit) {
        [UIView animateWithDuration:time animations:^{
            _imgCheck.alpha = 0.0f;
            [_lbTitle layoutIfNeeded];
            [_lbSize layoutIfNeeded];
        }];
    }else{
        [UIView animateWithDuration:time animations:^{
            _imgCheck.alpha = 1.0f;
            [_lbTitle layoutIfNeeded];
            [_lbSize layoutIfNeeded];
        }];
    }
}

-(NSString *)getFileSizeString:(double)size
{
    if(size >= 1024*1024)
    {
        return [NSString stringWithFormat:@"%1.2fM",size/1024/1024];
    }
    else if(size >= 1024 && size < 1024*1024)
    {
        return [NSString stringWithFormat:@"%1.2fK",size/1024];
    }
    else
    {
        return @"--";
        return [NSString stringWithFormat:@"%1.2fB",size];
    }
}

@end
