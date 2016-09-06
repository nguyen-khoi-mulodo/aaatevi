//
//  ArtistSuggestVC.h
//  NPlus
//
//  Created by Vo Chuong Thien on 1/19/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ArtistChannelDelegate <NSObject>
- (void) showChannel:(id) item;
@end

@interface ArtistChannel_iPad : GridViewBaseVC{
//    IBOutlet UITableView* myTableView;
    IBOutlet UIGridView* gridView;
}

@property (nonatomic, strong) Artist* mArtist;
@property (nonatomic, strong) id <ArtistChannelDelegate> delegate;

- (void) loadDataWithArtist:(Artist*) artist;

@end
