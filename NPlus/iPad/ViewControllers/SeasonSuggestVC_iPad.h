//
//  ArtistHotVC.h
//  NPlus
//
//  Created by Vo Chuong Thien on 1/19/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoSuggestItemCell.h"

@protocol SeasonSuggestVCDelegate <NSObject>
- (void) loadVideoPlayerWithItem:(id) item withIndex:(int) index fromRootView:(BOOL) fromRoot;
- (void) loadChannelDetailWithChannel:(Channel*) channel isAnimation:(BOOL) animation;
@end

@interface SeasonSuggestVC_iPad : BaseVC<UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView* myTableView;
    
    // channel info
    IBOutlet UIView* channelInfoView;
    IBOutlet UIImageView* channelThump;
    IBOutlet UILabel* lbChannelTitle;
    IBOutlet UILabel* lbChannelFollow;
    IBOutlet UIButton* btnFollow;
    
    // list info
    IBOutlet UIView* contentListView;
}
@property (nonatomic, weak) IBOutlet UILabel* lbTitle;
@property (nonatomic, strong) Video* mVideo;
@property (nonatomic, strong) Season* mSeason;
@property (nonatomic, strong) Channel* mChannel;
@property (nonatomic, strong) FileDownloadInfo* mFileInfo;
@property (nonatomic, strong) id <SeasonSuggestVCDelegate> delegate;

- (void) loadDataWithVideo:(Video*) video;
- (void) loadDataWithSeason:(Season*) season;
- (void) loadDataWithFileInfo:(FileDownloadInfo*) fileInfo;
- (IBAction) showChannelDetail:(id)sender;

@end
