//
//  ArtistVC_iPad.h
//  NPlus
//
//  Created by Vo Chuong Thien on 3/3/16.
//  Copyright © 2016 thienvc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelDetail_iPad.h"
#import "SeasonsOfChannelVC.h"
#import "ChannelSuggest_iPad.h"
#import "RatingAlertVC_iPad.h"

@interface ChannelVC_iPad : GlobalViewController<ChannelSuggestDeleage, SeasonsOfChannelDelegate, ChannelDetailDelegate, RatingAlertDelegate>
{
    ChannelDetail_iPad* channelDetailVC;
    SeasonsOfChannelVC* seasonListVC;
    ChannelSuggest_iPad* channelSuggestVC;
}

@property (nonatomic, strong) Channel* mChannel;
@property (nonatomic, strong) IBOutlet UIButton* btnBack;
@property (nonatomic, weak) IBOutlet UIImageView* backgroundView;

- (void) getChannnelDetailWithChannel;
@end
