//
//  ArtistSuggestVC.h
//  NPlus
//
//  Created by Vo Chuong Thien on 1/19/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideosSuggestTableView.h"

@protocol VideoSuggestOfVideoDelegate <NSObject>
- (void) showVideosSuggestMore;
@end

@interface VideoSuggestOfVideoVC : BaseVC<UITableViewDelegate, UITableViewDataSource>{
    VideosSuggestTableView* myTableView;
    IBOutlet UILabel* lbTitle;
}

@property (nonatomic, strong) NSMutableArray* listVideos;
@property (nonatomic, strong) id <VideoSuggestOfVideoDelegate> delegate;

- (void) loadVideosSuggestFromVideoId:(NSString*) videoId;
@end
