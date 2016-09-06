//
//  ArtistDetail_iPad.h
//  NPlus
//
//  Created by Vo Chuong Thien on 1/15/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPagerController.h"
#import "ArtistChannel_iPad.h"
#import "UIGridView.h"
#import "ChannelInfoDetailVC_iPad.h"

@protocol ChannelDetailDelegate <NSObject>
- (void) playVideoDefaultOfChannel;
- (void) showArtist:(id) item;
- (void) showRatingView:(id) vc;
- (void) showLoginWithTask:(NSString*) task withVC:(id) vc;
- (void) hideLoginView;
@end

@interface ChannelDetail_iPad : BaseVC<UIGridViewDelegate, ChannelInfoDetailDelegate>{
    ChannelInfoDetailVC_iPad* infoDetail;
    
    // thumb view
    IBOutlet UIImageView* thumbImageView;
    IBOutlet UILabel* lbRating;
    IBOutlet UILabel* lbUsersView;
}

@property (nonatomic, strong) id <ChannelDetailDelegate> delegate;

- (void) loadDataWithChannel:(Channel*) channel;



@end
