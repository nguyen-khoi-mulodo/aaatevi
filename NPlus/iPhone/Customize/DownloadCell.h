//
//  DownloadCell.h
//  NPlus
//
//  Created by Anh Le Duc on 7/31/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileDownloadInfo.h"
@interface DownloadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UILabel *lbSize;
@property (weak, nonatomic) IBOutlet UILabel *lbPercent;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnDownload;
@property (weak, nonatomic) FileDownloadInfo *downloadInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck;
@property (weak, nonatomic) IBOutlet UILabel *lbDownload;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lbTitle_LeadingMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lbTitle_TrailingMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lbSize_LeadingMargin;
-(void)updateCell:(unsigned long)taskId;
-(void)setFileDownloadInfo:(FileDownloadInfo*)info;
- (void)showInfoDownloadingWithEdit:(BOOL)isEdit animated:(BOOL)animated;
- (void)showInfoDowloadedWithEdit:(BOOL)isEdit animated:(BOOL)animated;
- (void)checked:(BOOL)checked;
- (IBAction)btnDownload_Tapped:(id)sender;
@end