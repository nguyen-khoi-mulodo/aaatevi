//
//  ArtistDetail_iPad.h
//  NPlus
//
//  Created by Vo Chuong Thien on 1/15/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtistInfoDetailVC_iPad.h"
#import "ArtistChannel_iPad.h"
#import "ViewPagerController.h"

@protocol ArtistDetailDelegate <NSObject>
- (void) showChannel:(id)item;

@end

@interface ArtistDetail_iPad : ViewPagerController<ArtistChannelDelegate>{
    ArtistInfoDetailVC_iPad* artistInfo;
    ArtistChannel_iPad* artistChannel;
    
    // info
    IBOutlet UILabel* lbName;
    IBOutlet UILabel* lbAlias;
    IBOutlet UILabel* lbBirthDay;
    IBOutlet UILabel* lbGender;
    IBOutlet UILabel* lbNational;
    
    IBOutlet UILabel* lbTitleName;
    IBOutlet UILabel* lbTitleBirthDay;
    IBOutlet UILabel* lbTitleGender;
    IBOutlet UILabel* lbTitleNational;
    
    IBOutlet UIImageView* artistBannerView;
}
@property (nonatomic, strong) IBOutlet UIView* infoView;
@property (nonatomic, strong) IBOutlet UIImageView* artistImageView;
@property (nonatomic, strong) Artist* mArtist;
@property (nonatomic, strong) id <ArtistDetailDelegate> artistDelegate;

- (void) loadDataWithArtist:(Artist*) artist;

@end
