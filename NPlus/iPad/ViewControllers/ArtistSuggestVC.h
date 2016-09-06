//
//  ArtistSuggestVC.h
//  NPlus
//
//  Created by Vo Chuong Thien on 1/19/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridView.h"

@protocol ArtistSuggestDelegate <NSObject>
- (void) getArtistDetailWithArtist:(Artist*) artist;
@end

@interface ArtistSuggestVC : GridViewBaseVC<UIGridViewDelegate>{
    IBOutlet UIGridView* gridView;
    IBOutlet UILabel* lbTitleArtist;
}

@property (nonatomic, strong) Artist* mArtist;
@property (nonatomic, strong) id <ArtistSuggestDelegate> delegate;

- (void) loadArtistsHot;


@end
