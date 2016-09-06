//
//  ItemCell.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/29/16.
//  Copyright © 2016 anhld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileDownloadInfo.h"

@protocol DownloadingItemCellDelegate <NSObject>

- (void)didButtonMoreTapped:(id)object;

@end

@interface DownloadingItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbImg;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet UILabel *lbSize;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbQuality;
@property (weak, nonatomic) IBOutlet UIProgressView* progressView;
@property (strong, nonatomic) id<DownloadingItemCellDelegate> delegate;
@property (weak, nonatomic) FileDownloadInfo *infoCurrent;

@property (strong, nonatomic) Video *video;

- (void) setContent:(FileDownloadInfo*) info;
- (void) updateCell:(unsigned long)taskId andInfo:(FileDownloadInfo*) info;
@end
