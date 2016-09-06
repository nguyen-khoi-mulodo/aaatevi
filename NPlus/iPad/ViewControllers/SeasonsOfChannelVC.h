//
//  ArtistSuggestVC.h
//  NPlus
//
//  Created by Vo Chuong Thien on 1/19/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SeasonsOfChannelDelegate <NSObject>
- (void) showVideo:(id) item;
@end

@interface SeasonsOfChannelVC : BaseVC{
    IBOutlet UITableView* myTableView;
    IBOutlet UILabel* lbTitlePlaylist;
}

@property (nonatomic, strong) id <SeasonsOfChannelDelegate> delegate;
@property (nonatomic, strong) Channel* mChannel;

- (void) loadDataWithChannel:(Channel*) channel;

@end
