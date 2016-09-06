//
//  ItemCell.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/29/16.
//  Copyright © 2016 anhld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileDownloadInfo.h"

@protocol DownloadedItemCellDelegate <NSObject>

- (void)didButtonMoreTapped:(id)object;

@end

@interface DownloadedItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbImg;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet UILabel *lbSize;
@property (weak, nonatomic) IBOutlet UILabel *lbQuality;
@property (strong, nonatomic) id<DownloadedItemCellDelegate> delegate;

@property (strong, nonatomic) Video *video;

- (void) setContent:(FileDownloadInfo*) item;
@end
