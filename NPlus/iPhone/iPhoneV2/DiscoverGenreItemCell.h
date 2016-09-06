//
//  DiscoverGenreItemCell.h
//  NPlus
//
//  Created by Vo Chuong Thien on 4/28/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiscoverGenreItemDelegate <NSObject>
- (void)didSelectGenre:(Genre*)parentGenre listGenres:(NSArray*)listGenres index:(NSInteger)index;
- (IBAction)btnGenreAction:(id)sender;
@end

@interface DiscoverGenreItemCell : UITableViewCell{
    IBOutlet UIView* genreView;
    IBOutlet UILabel* lbTitle;
    IBOutlet UIActivityIndicatorView* loadingView;
    IBOutlet UIButton* btnSelect;
    Genre* genreCurrent;
}

@property (nonatomic, strong) id <DiscoverGenreItemDelegate> delegate;

- (void) setHeightForCell:(float) height;
- (void) setGenre:(Genre*) genre;
- (void) setTitle:(NSString*) title andTag:(int) tag;
@end
