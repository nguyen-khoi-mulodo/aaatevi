//
//  VideoHotCell.h
//  NPlus
//
//  Created by Vo Chuong Thien on 1/21/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ArtistDescriptionItemDelegate <NSObject>

- (void) doShowMore;

@end
@interface ArtistDescriptionItemCell : UITableViewCell{
    IBOutlet UILabel* lbTitle;
}
@property (nonatomic, assign) id <ArtistDescriptionItemDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITextView* tvDesc;
- (void) setContent:(NSString*) desc;
@end

