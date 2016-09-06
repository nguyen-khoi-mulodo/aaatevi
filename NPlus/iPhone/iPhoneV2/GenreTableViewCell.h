//
//  GenreTableViewCell.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 12/23/15.
//  Copyright © 2015 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Artist.h"

@interface GenreTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) Artist *artist;

- (void)loadContentViewArtist;

@end
