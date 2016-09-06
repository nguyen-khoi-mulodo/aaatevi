//
//  ArtistVC_iPad.h
//  NPlus
//
//  Created by Vo Chuong Thien on 1/15/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtistDetail_iPad.h"
#import "ArtistSuggestVC.h"
#import "SeasonSuggestVC_iPad.h"
#import "Artist.h"

@interface ArtistVC_iPad : GlobalViewController<ArtistSuggestDelegate, ArtistDetailDelegate>
{
    ArtistDetail_iPad* artistDetailVC;
    ArtistSuggestVC* artistSuggestVC;
}

@property (nonatomic, strong) IBOutlet UIButton* btnBack;
@property (nonatomic, weak) IBOutlet UIImageView* backgroundView;

@property (nonatomic, strong) Artist* mArtist;
@end
