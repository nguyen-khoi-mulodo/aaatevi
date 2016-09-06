//
//  HotItemCell.h
//  NPlus
//
//  Created by Vo Chuong Thien on 10/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell.h"
#import "FileDownloadInfo.h"
#import "UCZProgressView.h"

@protocol DownloadItemDelegate <NSObject>
- (void) deleteItemInfo:(FileDownloadInfo*) info;
@end

@interface DownloadItemCell : UIGridViewCell{
    
}
@property (weak, nonatomic) IBOutlet UIImageView* imageIcon;
@property (weak, nonatomic) IBOutlet UILabel* lbName;
@property (weak, nonatomic) IBOutlet UILabel* lbChannel;
@property (weak, nonatomic) IBOutlet UIButton* btnDownloadStatus;
@property (weak, nonatomic) IBOutlet UILabel* lbPercent;
@property (weak, nonatomic) IBOutlet UILabel* lbQuality;
@property (weak, nonatomic) IBOutlet UIView* maskView;
@property (weak, nonatomic) FileDownloadInfo *infoCurrent;
@property (strong, nonatomic) UCZProgressView* processView;
@property (strong, nonatomic) id <DownloadItemDelegate> delegate;

-(void) setDownloadInfo:(FileDownloadInfo *)info;
- (void) setVideo:(Video *) item;
- (void) updateCell:(unsigned long)taskId;
@end

