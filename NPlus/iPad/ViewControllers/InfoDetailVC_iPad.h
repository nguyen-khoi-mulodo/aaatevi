//
//  VideoDetailVC_iPad.h
//  NPlus
//
//  Created by Vo Chuong Thien on 2/22/16.
//  Copyright © 2016 thienvc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentItemCell.h"
#import "VideoSuggestOfVideoVC.h"
#import "VideosOfSeasonVC.h"
#import "Season.h"

@protocol InfoDetailDelegate <NSObject>
- (void) showChannel:(id) item;
- (void) showVideoSuggest:(BOOL) isSuggest andList:(NSMutableArray*) list;
@end

@interface InfoDetailVC_iPad : UIViewController<VideoSuggestOfVideoDelegate, VideosOfSeasonDelegate> {
    IBOutlet UITableView* myTableView;
    IBOutlet UIView* titleView;
    IBOutlet UIView* luotXemView;
    IBOutlet UIView* actionView;
    VideoSuggestOfVideoVC* videosSuggestOfVideoVC;
    VideosOfSeasonVC* videosOfSeasonVC;
    // Title View
    IBOutlet UILabel* lbTitleLuotXem;
    IBOutlet UILabel* lbLuotXem;
    IBOutlet UILabel* lbTitle;
    IBOutlet UILabel* line;
}

@property (nonatomic, strong) id <InfoDetailDelegate> delegate;
@property (nonatomic, strong) Video* mVideo;
@property (nonatomic, strong) Season* mSeason;
@property (nonatomic, strong) FileDownloadInfo* mFileInfo;
@property (nonatomic, strong) Channel* mChannel;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSArray* listVideosSuggest;
//@property (nonatomic, weak) IBOutlet UILabel* lbTitle;
- (void) loadDataWithVideo:(Video*) video;
- (void) loadDataWithFileInfo:(FileDownloadInfo*) fileInfo;

@end
