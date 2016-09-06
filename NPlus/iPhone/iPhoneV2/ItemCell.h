//
//  ItemCell.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/29/16.
//  Copyright © 2016 anhld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDHistory.h"

@protocol ItemCellDelegate <NSObject>

- (void)didButtonMoreTapped:(id)object;

@end

@interface ItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbImg;
@property (weak, nonatomic) IBOutlet UIImageView *transparentImg;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet UIButton *btnSelected;
@property (weak, nonatomic) IBOutlet UIImageView *viewIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblViewCount;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;
@property (weak, nonatomic) IBOutlet UIImageView *iconHD;
@property (weak, nonatomic) IBOutlet UILabel *lblCreateTime;

@property (assign, nonatomic) TypeCell typeCell;
@property (strong, nonatomic) id<ItemCellDelegate> delegate;

@property (strong, nonatomic) Video *video;
@property (strong, nonatomic) Channel *channel;

- (void)loadContentWithType:(TypeCell)typeCell;
- (void) setContent:(CDHistory*) item;
- (void) setCheck:(BOOL) selected;
@end
