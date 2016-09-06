//
//  VideoDetailVC_iPad.h
//  NPlus
//
//  Created by Vo Chuong Thien on 2/22/16.
//  Copyright © 2016 thienvc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtistDescriptionItemCell.h"


@interface ArtistInfoDetailVC_iPad : UIViewController <ArtistDescriptionItemDelegate, UIGridViewDelegate>{
    IBOutlet UITableView* myTableView;
}

@property (nonatomic, strong) Artist* mArtist;


- (void) loadDataWithArtist:(Artist*) artist;

@end
