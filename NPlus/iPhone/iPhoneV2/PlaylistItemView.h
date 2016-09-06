//
//  PlaylistItemView.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/5/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Season.h"

@protocol PlaylistItemViewDelegate <NSObject>

- (void)didTappedItem:(id)sender;

@end

@interface PlaylistItemView : UIView

@property (nonatomic, strong) UILabel *lblPlaylistName;
@property (nonatomic, strong) UILabel *lblNumOfVideo;
@property (nonatomic, readwrite) BOOL selected;
@property (nonatomic, strong) Season *season;
@property (nonatomic, strong) id<PlaylistItemViewDelegate> delegate;

- (void)loadContentSeason;
- (void)setSelected:(BOOL)selected;
@end
