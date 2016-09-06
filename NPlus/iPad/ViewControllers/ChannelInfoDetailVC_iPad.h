//
//  VideoDetailVC_iPad.h
//  NPlus
//
//  Created by Vo Chuong Thien on 2/22/16.
//  Copyright © 2016 thienvc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DescriptionItemCell.h"
#import "ActionVC.h"

@protocol ChannelInfoDetailDelegate <NSObject>
- (void) showArtist:(id) item;
- (void) showRatingView:(id) vc;
- (void) showLoginWithTask:(NSString*) task withVC:(id) vc;
- (void) hideLoginView;
@end

@interface ChannelInfoDetailVC_iPad : UIViewController <DescriptionItemCellDelegate, UIGridViewDelegate, ActionDelegate>{
    IBOutlet UITableView* myTableView;
    IBOutlet UIView* titleViewChannel;
    IBOutlet UIView* titleViewSeason;
    IBOutlet UIView* rateView;
    IBOutlet UIView* artistView;
    IBOutlet UIGridView* gridView;
    
    // title view channel
    IBOutlet UILabel* cLbTitle;
    IBOutlet UILabel* cLbLuotXem;
    IBOutlet UIButton* cBtnFollow;
    IBOutlet UILabel* cLbTitleLuotXem;
    IBOutlet UIButton* cBtnShare;
    
    // title view season
    IBOutlet UILabel* sLbTitle;
    IBOutlet UILabel* sLbLuotXem;
    IBOutlet UIButton* sBtnFollow;
    IBOutlet UILabel* sLbTitleLuotXem;
    IBOutlet UIButton* sBtnShare;
    IBOutlet UIButton* sBtnRate;
    
    // rate view
    IBOutlet UILabel* lbBroadcast;
    IBOutlet UILabel* lbDirector;
    IBOutlet UILabel* lbProducer;
    IBOutlet UILabel* lbRating;
    IBOutlet UILabel* lbUsersRating;
    IBOutlet UILabel* lbTitleFollow;
    IBOutlet UILabel* lbFollow;
    
    IBOutlet UIView* starView;
    
    IBOutlet UILabel* lbTitleBroadcast;
    IBOutlet UILabel* lbTitleDirector;
    IBOutlet UILabel* lbTitleProducer;
    IBOutlet UILabel* lbTitleRating;
    
    // artist view
    IBOutlet UILabel* lbTitleArtist;
    
    
    //action
    ActionVC* actionVC;
    UIPopoverController* actionPopover;
}

@property (nonatomic, strong) Channel* mChannel;
@property (nonatomic, strong) Video* mVideo;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) id <ChannelInfoDetailDelegate> delegate;
@property (nonatomic, strong) NSMutableArray* listArtists;


- (void) loadDataWithChannel:(Channel*) channel;
- (void) loadDataWithSeason:(Season*) season andVideo:(Video*) video;

@end
