//
//  HotItemCell.h
//  NPlus
//
//  Created by Vo Chuong Thien on 10/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell.h"
#import "Artist.h"

@interface ArtistSuggestItemCell : UIGridViewCell{
}
@property (weak, nonatomic) IBOutlet UIImageView* imageIcon;
@property (weak, nonatomic) IBOutlet UILabel* lbName;
- (void) setContentArtist:(Artist *) artist;

@end

