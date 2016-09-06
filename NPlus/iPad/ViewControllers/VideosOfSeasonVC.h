//
//  ArtistSuggestVC.h
//  NPlus
//
//  Created by Vo Chuong Thien on 1/19/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoOfSeasonTableView.h"

@protocol VideosOfSeasonDelegate <NSObject>
- (void) showVideosOfSeason:(NSMutableArray*) list;
@end

@interface VideosOfSeasonVC : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    VideoOfSeasonTableView* myTableView;
    IBOutlet UILabel* lbHeader;
    IBOutlet UIButton* btnMore;
}

@property (nonatomic, strong) NSMutableArray* listVideos;
@property (nonatomic, strong) id <VideosOfSeasonDelegate> delegate;

- (void) loadVideosOfSeasonFromSeasonId:(NSString*) seasonId;
@end
